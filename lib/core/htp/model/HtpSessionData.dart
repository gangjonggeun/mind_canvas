// ===== 극도로 간소화된 HTP 데이터 (메모리/CPU 최적화) =====
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HtpSessionData.freezed.dart';
part 'HtpSessionData.g.dart';

// ===== 메인 HTP 세션 =====
@freezed
class HtpSession with _$HtpSession {
  const factory HtpSession({
    required String sessionId,
    required String userId,
    required int startTime, // Unix timestamp (밀리초)
    int? endTime,
    required List<HtpDrawing> drawings,
    required bool supportsPressure, // 디바이스 필압 지원 여부
  }) = _HtpSession;

  factory HtpSession.fromJson(Map<String, dynamic> json) =>
      _$HtpSessionFromJson(json);
}

// ===== 개별 그림 데이터 =====
@freezed
class HtpDrawing with _$HtpDrawing {
  const factory HtpDrawing({
    required HtpType type, // house, tree, person
    required int startTime,
    int? endTime,
    required int strokeCount, // 총 스트로크 수
    required int modificationCount, // 총 수정 횟수 (undo + 지우개 + 초기화)
    required double averagePressure, // 평균 필압 (실제 또는 추정)
    @Default(-1) int orderIndex, // 그린 순서 (0, 1, 2) - 대시보드에서 할당
  }) = _HtpDrawing;

  factory HtpDrawing.fromJson(Map<String, dynamic> json) =>
      _$HtpDrawingFromJson(json);
}

// ===== HTP 타입 =====
enum HtpType {
  house, tree, person
}

// ===== AI 전송용 최종 데이터 =====
@freezed
class HtpAnalysisData with _$HtpAnalysisData {
  const factory HtpAnalysisData({
    required String sessionId,
    required String userId,
    required int totalDurationSeconds, // 총 소요 시간 (초)
    required List<int> drawingOrder, // 그린 순서 [0=house, 1=tree, 2=person]
    required List<int> drawingDurations, // 각 그림별 소요시간 (초)
    required List<double> averagePressures, // 각 그림별 평균 필압
    required int totalModifications, // 총 수정 횟수
    required bool hasPressureData, // 실제 필압 데이터 여부
  }) = _HtpAnalysisData;

  factory HtpAnalysisData.fromJson(Map<String, dynamic> json) =>
      _$HtpAnalysisDataFromJson(json);
}

// ===== 확장 메서드 =====
extension HtpSessionX on HtpSession {
  // 완료 여부
  bool get isCompleted => drawings.length == 3 &&
      drawings.every((d) => d.endTime != null);

  // 총 소요 시간 (초)
  int get totalDurationSeconds {
    if (endTime == null) return 0;
    return ((endTime! - startTime) / 1000).round();
  }

  // AI 전송용 데이터 변환
  HtpAnalysisData toAnalysisData() {
    return HtpAnalysisData(
      sessionId: sessionId,
      userId: userId,
      totalDurationSeconds: totalDurationSeconds,
      drawingOrder: drawings.map((d) => d.type.index).toList(),
      drawingDurations: drawings.map((d) => d.durationSeconds).toList(),
      averagePressures: drawings.map((d) => d.averagePressure).toList(),
      totalModifications: drawings.map((d) => d.modificationCount).fold(0, (a, b) => a + b),
      hasPressureData: supportsPressure,
    );
  }
}

extension HtpDrawingX on HtpDrawing {
  // 소요 시간 (초)
  int get durationSeconds {
    if (endTime == null) return 0;
    return ((endTime! - startTime) / 1000).round();
  }
}

// ===== 실시간 데이터 수집기 (메모리 효율적) =====
class HtpDataCollector {
  int _strokeCount = 0;
  int _modificationCount = 0;

  // ✅ 변경: 단순 합계/개수 대신 지수 이동 평균(EMA)을 위한 변수
  double _emaPressure = 0.5; // 초기 평균 필압은 중간값인 0.5로 시작
  bool _isFirstStroke = true; // 첫 스트로크인지 확인

  // EMA 가중치 (0.0 ~ 1.0, 낮을수록 부드럽게, 높을수록 민감하게 반응)
  final double _alpha = 0.1;

  int get strokeCount => _strokeCount;
  int get modificationCount => _modificationCount;
  // ✅ 변경: 현재의 EMA 필압 값을 반환
  double get averagePressure => _emaPressure;

  // ✅ 변경: EMA 계산 로직 적용
  void addStroke(double newPressure) {
    _strokeCount++;

    if (_isFirstStroke) {
      // 첫 스트로크는 그 값으로 평균을 초기화
      _emaPressure = newPressure;
      _isFirstStroke = false;
    } else {
      // EMA 공식: NewEMA = (NewValue * alpha) + (OldEMA * (1 - alpha))
      _emaPressure = (newPressure * _alpha) + (_emaPressure * (1 - _alpha));
    }
  }

  void addModification() {
    _modificationCount++;
  }

  static double calculatePressureFromSpeed(double pixelsPerSecond) {
    const double maxSpeed = 1500.0;
    const double minPressure = 0.2;
    const double maxPressure = 1.0;
    final normalizedSpeed = (pixelsPerSecond / maxSpeed).clamp(0.0, 1.0);
    return maxPressure - (normalizedSpeed * (maxPressure - minPressure));
  }

  HtpDrawing createDrawing({
    required HtpType type,
    required int startTime,
    required int endTime,
  }) {
    // 최종 그림 데이터 생성 시 현재의 EMA 평균 필압을 사용
    return HtpDrawing(
      type: type,
      startTime: startTime,
      endTime: endTime,
      strokeCount: _strokeCount,
      modificationCount: _modificationCount,
      averagePressure: _emaPressure,
    );
  }

  void reset() {
    _strokeCount = 0;
    _modificationCount = 0;
    _emaPressure = 0.5; // 다음 그림을 위해 초기화
    _isFirstStroke = true;
  }
}

// ===== Result 패턴 (가벼운 에러) =====
sealed class HtpResult<T> {
  const HtpResult();
}

class HtpSuccess<T> extends HtpResult<T> {
  final T data;
  const HtpSuccess(this.data);
}

class HtpFailure<T> extends HtpResult<T> {
  final String message;
  const HtpFailure(this.message);

  @override
  String toString() => 'HtpError: $message';
}

// ===== 사용 예시 =====
/*
// 1. 세션 시작
final session = HtpSession(
  sessionId: 'session_123',
  userId: 'user_456', 
  startTime: DateTime.now().millisecondsSinceEpoch,
  drawings: [],
  supportsPressure: false, // scribble 속도 기반 사용
);

// 2. 데이터 수집기 초기화
final collector = HtpDataCollector();

// 3. scribble 이벤트에서 호출
void onScribbleStroke(Stroke scribbleStroke) {
  // scribble의 속도 계산
  final speed = calculateStrokeSpeed(scribbleStroke);
  final pressure = HtpDataCollector.calculatePressureFromSpeed(speed);
  
  // 스트로크 추가
  collector.addStroke(pressure);
}

// 4. 수정 버튼 클릭 시
void onUndo() => collector.addModification();
void onErase() => collector.addModification();  
void onClear() => collector.addModification();

// 5. 그림 완료 시
final drawing = collector.createDrawing(
  type: HtpType.house,
  startTime: houseStartTime,
  endTime: DateTime.now().millisecondsSinceEpoch,
  orderIndex: 0,
);

// 6. AI 전송
final analysisData = session.toAnalysisData();
await sendToAI(analysisData); // 초경량 데이터만 전송
*/