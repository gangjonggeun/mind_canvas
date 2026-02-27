
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// ✅ HTP 엔티티 재사용
import '../../../../features/htp/domain/entities/htp_session_entity.dart';

class FbtSessionNotifier extends StateNotifier<HtpSessionEntity?> {
  // ⚠️ [중요] HTP와 데이터 섞이지 않게 박스 이름 다르게 설정
  static const String _boxName = 'fbt_session_box';
  static const String _sessionKey = 'current_session';

  late Box<String> _box;
  late Directory _imageDir;

  FbtSessionNotifier() : super(null) {
    _initialize();
  }

  Future<void> savePdiAnswers(Map<String, String> answers) async {
    if (state == null) return;

    state = state!.copyWith(pdiAnswers: answers);
    await _saveSession();

    print('📝 [Provider] fbt PDI 답변 저장 완료: ${answers.length}개');
  }

  Future<void> _initialize() async {

    try {
      // Hive 박스 열기
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(_boxName);

      // 이미지 디렉토리 설정
      final appDir = await getApplicationDocumentsDirectory();

      _imageDir = Directory('${appDir.path}/fbt_temp'); // 폴더 분리
      if (!await _imageDir.exists()) {
        await _imageDir.create(recursive: true);
      }

      // 저장된 세션 복원
      await _loadSession();

      print('✅ [Provider] fbt 세션 Provider 초기화 완료');
    } catch (e) {
      print('❌ [Provider] fbt 초기화 실패: $e');
    }


  }

  Future<void> startNewSession(String userId) async {
    // ... (HTP와 동일하게 생성)
    final session = HtpSessionEntity(
      sessionId: 'fbt_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      startTime: DateTime.now().millisecondsSinceEpoch,
      drawings: [],
      supportsPressure: false,
    );
    state = session;
    await _saveSession();
  }

  bool get canComplete {
    if (state == null) return false;

    // 별바다의 경우 그림 1개
    final bool isDrawingComplete = state!.drawings.isNotEmpty;
    // HTP의 경우: final bool isDrawingComplete = state!.drawings.length == 3;

    final bool isPdiComplete = state!.pdiAnswers != null && state!.pdiAnswers!.isNotEmpty;

    return isDrawingComplete && isPdiComplete; // 둘 다 완료되어야 true
  }


  // 헬퍼: 별바다 그림 가져오기 (타입 고정)
  HtpDrawingEntity? getDrawing() {
    if (state == null) return null;
    try {
      return state!.drawings.firstWhere((d) => d.type == HtpType.pitr);
    } catch (_) {
      return null;
    }
  }

  // =============================================================
  // 여기 아래 부터 노티파이어 동일 메소드
  // =============================================================

  /// 그림 추가/수정
  /// 그림 추가/수정
  Future<void> updateDrawing(HtpDrawingEntity drawing, File imageFile) async {
    if (state == null) return;

    try {
      // 1. 이미지 파일 저장
      final savedPath = await _saveImageFile(imageFile, drawing.type);
      final updatedDrawing = drawing.copyWith(imagePath: savedPath);

      // 2. Entity의 비즈니스 로직 사용
      state = state!.updateDrawing(updatedDrawing);
      await _saveSession();

      print('💾 [Provider] fbt 진행 상태: ${state!.progress * 100}%');
    } catch (e) {
      print('❌ [Provider] fbt 그림 업데이트 실패: $e');
    }
  }

  /// 세션 완료 (서버 전송 전)
  Future<void> completeSession() async {
    if (state == null) return;

    state = state!.copyWith(
      endTime: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveSession();
    print('✅ [Provider] fbt 세션 완료: ${state!.sessionId}');
  }

  /// 세션 초기화 (전송 완료 후)
  Future<void> clearSession() async {
    // 임시 이미지 파일 삭제
    if (_imageDir.existsSync()) {
      await _imageDir.delete(recursive: true);
      await _imageDir.create();
    }

    // Hive에서 삭제
    await _box.delete(_sessionKey);
    state = null;

    print('🗑️ [Provider] fbt 세션 초기화 완료');
  }

  /// 세션 저장
  Future<void> _saveSession() async {
    if (state == null) return;
    await _box.put(_sessionKey, state!.toJsonString());
  }

  /// 세션 로드
  Future<void> _loadSession() async {
    final jsonString = _box.get(_sessionKey);
    if (jsonString != null) {
      state = HtpSessionEntity.fromJsonString(jsonString);
      print('📂 [Provider] fbt 세션 복원: ${state!.sessionId}');
      print('   - 그림 개수: ${state!.drawings.length}');
    }
  }

  /// 이미지 파일 저장
  Future<String> _saveImageFile(File imageFile, HtpType type) async {
    final fileName =
        '${type.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}.png';
    final savePath = '${_imageDir.path}/$fileName';
    await imageFile.copy(savePath);
    return savePath;
  }

  // 👇 [추가] 갤러리 이미지 업로드 전용 메서드
  Future<void> updateDrawingFromGallery(HtpType type, File imageFile) async {
    if (state == null) return;

    try {
      // 1. 이미지 파일 로컬 저장
      final savedPath = await _saveImageFile(imageFile, type);

      // 2. 기존 그림 데이터 확인 (순서 유지용)
      // final existingDrawing = getDrawing();

      // 3. 순서(Order) 결정: 기존 것이면 유지, 새 것이면 리스트 맨 뒤
      // final int orderIndex = existingDrawing?.orderIndex ?? state!.drawings.length;

      // 4. 엔티티 생성
      // 갤러리 업로드는 압력, 그리기 시간, 획수 등의 메타데이터가 없으므로 기본값 처리
      final newDrawing = HtpDrawingEntity(
        type: type,
        imagePath: savedPath,
        sketchJson: null,
        // 스케치 데이터 없음
        strokeCount: 0,
        // 획수 0
        averagePressure: 0.5,
        // 압력 중간값(기본)
        // pressureData: [],       // 압력 상세 데이터 빈 리스트
        startTime: DateTime.now().millisecondsSinceEpoch,
        // 업로드 시점
        endTime: DateTime.now().millisecondsSinceEpoch,
        // 즉시 완료 처리
        // durationSeconds: 0,     // 소요 시간 0
        modificationCount: 0,
        // 수정 횟수 0
        // canvasWidth: 0,         // 캔버스 크기 알 수 없음 (0 처리)
        // canvasHeight: 0,
        // backgroundImage: null,  // 배경 없음
        orderIndex: 0, // 순서 할당
      );

      // 5. 상태 업데이트
      state = state!.updateDrawing(newDrawing);
      await _saveSession();

      print('📸 [Provider] fbt갤러리 이미지 업로드 완료: ${type.name} (path: $savedPath)');
    } catch (e) {
      print('❌ [Provider] fbt 갤러리 업로드 실패: $e');
    }
  }
}

/// Provider 정의
final fbtSessionProvider =
StateNotifierProvider<FbtSessionNotifier, HtpSessionEntity?>(
      (ref) => FbtSessionNotifier(),
);
