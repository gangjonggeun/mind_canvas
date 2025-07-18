// lib/core/htp/providers/htp_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../htp/model/HtpSessionData.dart';


//TODO: provider 예시 정리된 후 실제 api랑 연동 아직 서버없음

// ===== 1. API Service =====
class HtpApiService {
  final Dio _dio;

  HtpApiService(this._dio);

  /// AI 분석 데이터 전송
  Future<HtpResult<String>> submitHtpAnalysis(HtpAnalysisData data) async {
    try {
      print('🚀 HTP 분석 데이터 전송 시작...');

      final response = await _dio.post(
        '/api/htp/analyze',
        data: data.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('✅ HTP 분석 전송 성공: ${response.data}');
      return HtpSuccess(response.data['message'] ?? '분석 완료');

    } on DioException catch (e) {
      print('❌ HTP API 오류: ${e.message}');
      return HtpFailure('서버 연결 오류: ${e.message}');
    } catch (e) {
      print('❌ 예상치 못한 오류: $e');
      return HtpFailure('알 수 없는 오류가 발생했습니다');
    }
  }

  /// 그림 이미지 업로드 (선택적)
  Future<HtpResult<String>> uploadDrawingImage(
      String sessionId,
      String drawingType,
      List<int> imageBytes
      ) async {
    try {
      final formData = FormData.fromMap({
        'sessionId': sessionId,
        'drawingType': drawingType,
        'image': MultipartFile.fromBytes(imageBytes, filename: '${drawingType}.png'),
      });

      final response = await _dio.post('/api/htp/upload-image', data: formData);
      return HtpSuccess(response.data['imageUrl']);

    } catch (e) {
      return HtpFailure('이미지 업로드 실패: $e');
    }
  }
}

// ===== 2. Repository =====
class HtpRepository {
  final HtpApiService _apiService;

  HtpRepository(this._apiService);

  /// HTP 세션 제출
  Future<HtpResult<String>> submitSession(HtpSession session) async {
    try {
      // 1. 세션 데이터 검증
      if (!session.isCompleted) {
        return const HtpFailure('모든 그림을 완료해주세요');
      }

      // 2. AI 분석용 데이터 변환
      final analysisData = session.toAnalysisData();

      // 3. API 서비스 호출
      final result = await _apiService.submitHtpAnalysis(analysisData);

      return result;

    } catch (e) {
      return HtpFailure('세션 제출 실패: $e');
    }
  }

  /// 그림 이미지 저장 (로컬 또는 서버)
  Future<HtpResult<String>> saveDrawingImage(
      String sessionId,
      String drawingType,
      List<int> imageBytes,
      ) async {
    // 로컬 저장 또는 서버 업로드 로직
    try {
      // 서버 업로드 옵션
      return await _apiService.uploadDrawingImage(sessionId, drawingType, imageBytes);
    } catch (e) {
      return HtpFailure('이미지 저장 실패: $e');
    }
  }
}

// ===== 3. Session State =====
class HtpSessionState {
  final HtpSession? currentSession;
  final Map<String, HtpDrawing> drawings;
  final List<String> drawingOrder;
  final bool isLoading;
  final String? error;
  final bool isSubmitted;

  const HtpSessionState({
    this.currentSession,
    this.drawings = const {},
    this.drawingOrder = const [],
    this.isLoading = false,
    this.error,
    this.isSubmitted = false,
  });

  HtpSessionState copyWith({
    HtpSession? currentSession,
    Map<String, HtpDrawing>? drawings,
    List<String>? drawingOrder,
    bool? isLoading,
    String? error,
    bool? isSubmitted,
  }) {
    return HtpSessionState(
      currentSession: currentSession ?? this.currentSession,
      drawings: drawings ?? this.drawings,
      drawingOrder: drawingOrder ?? this.drawingOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  /// 완료된 그림 개수
  int get completedCount => drawings.length;

  /// 제출 가능 여부
  bool get canSubmit => completedCount == 3 && !isSubmitted;

  /// 특정 그림 상태
  HtpDrawingStatus getDrawingStatus(String type) {
    if (drawings.containsKey(type)) {
      return HtpDrawingStatus.completed;
    } else if (drawingOrder.contains(type)) {
      return HtpDrawingStatus.inProgress;
    } else {
      return HtpDrawingStatus.notStarted;
    }
  }
}

// ===== 4. Session Notifier =====
class HtpSessionNotifier extends StateNotifier<HtpSessionState> {
  final HtpRepository _repository;

  HtpSessionNotifier(this._repository) : super(const HtpSessionState()) {
    _initializeSession();
  }

  /// 새 세션 초기화
  void _initializeSession() {
    final session = HtpSession(
      sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_123', // 실제 사용자 ID로 변경 필요
      startTime: DateTime.now().millisecondsSinceEpoch,
      drawings: [],
      supportsPressure: _checkPressureSupport(),
    );

    state = state.copyWith(currentSession: session);
    print('🎨 새 HTP 세션 시작: ${session.sessionId}');
  }

  /// 디바이스 필압 지원 여부 확인
  bool _checkPressureSupport() {
    // 실제 구현에서는 Platform.isIOS 등으로 체크
    return false; // 일단 false로 설정 (scribble 속도 기반 사용)
  }

  /// 그림 시작 (순서 기록)
  void startDrawing(String drawingType) {
    if (!state.drawingOrder.contains(drawingType)) {
      state = state.copyWith(
        drawingOrder: [...state.drawingOrder, drawingType],
      );
      print('📝 그리기 시작: $drawingType (순서: ${state.drawingOrder.length})');
    }
  }

  /// 그림 완료 (데이터 저장)
  void addDrawing(String drawingType, HtpDrawing drawing) {
    // 실제 그린 순서에 따라 orderIndex 할당
    final orderIndex = state.drawingOrder.indexOf(drawingType);
    final updatedDrawing = drawing.copyWith(orderIndex: orderIndex);

    final newDrawings = Map<String, HtpDrawing>.from(state.drawings);
    newDrawings[drawingType] = updatedDrawing;

    state = state.copyWith(drawings: newDrawings);

    print('✅ 그림 완료: $drawingType (순서: $orderIndex)');
    print('   - 스트로크: ${drawing.strokeCount}개');
    print('   - 수정: ${drawing.modificationCount}회');
    print('   - 시간: ${drawing.durationSeconds}초');
  }

  /// 세션 제출
  Future<void> submitSession() async {
    if (!state.canSubmit) {
      state = state.copyWith(error: '모든 그림을 완료해주세요');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 최종 세션 데이터 생성
      final completedSession = state.currentSession!.copyWith(
        endTime: DateTime.now().millisecondsSinceEpoch,
        drawings: state.drawings.values.toList(),
      );

      // Repository를 통해 제출
      final result = await _repository.submitSession(completedSession);

      if (result is HtpSuccess) {
        state = state.copyWith(
          isLoading: false,
          isSubmitted: true,
          currentSession: completedSession,
        );
        print('🎉 HTP 세션 제출 성공!');
      } else if (result is HtpFailure) {
        state = state.copyWith(
          isLoading: false
          // error: result.message,
        );
        // print('❌ HTP 세션 제출 실패: ${result.message}');
      }

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '제출 중 오류가 발생했습니다: $e',
      );
      print('💥 예상치 못한 오류: $e');
    }
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 세션 리셋 (새로 시작)
  void resetSession() {
    state = const HtpSessionState();
    _initializeSession();
    print('🔄 HTP 세션 리셋');
  }

  /// 특정 그림 삭제 (재시작용)
  void removeDrawing(String drawingType) {
    final newDrawings = Map<String, HtpDrawing>.from(state.drawings);
    newDrawings.remove(drawingType);

    final newOrder = List<String>.from(state.drawingOrder);
    newOrder.remove(drawingType);

    state = state.copyWith(
      drawings: newDrawings,
      drawingOrder: newOrder,
    );

    print('🗑️ 그림 삭제: $drawingType');
  }
}

// ===== 5. Providers =====

/// Dio 인스턴스 Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // 기본 설정
  dio.options.baseUrl = 'https://your-api-server.com'; // 실제 서버 URL로 변경
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  // 개발 환경에서 로깅 (운영환경에서는 제거)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => print('🌐 $obj'),
  ));

  return dio;
});

/// API Service Provider
final htpApiServiceProvider = Provider<HtpApiService>((ref) {
  final dio = ref.read(dioProvider);
  return HtpApiService(dio);
});

/// Repository Provider
final htpRepositoryProvider = Provider<HtpRepository>((ref) {
  final apiService = ref.read(htpApiServiceProvider);
  return HtpRepository(apiService);
});

/// 메인 Session Provider (StateNotifierProvider)
final htpSessionProvider = StateNotifierProvider<HtpSessionNotifier, HtpSessionState>((ref) {
  final repository = ref.read(htpRepositoryProvider);
  return HtpSessionNotifier(repository);
});

// ===== 6. 편의용 Provider들 =====

/// 완료된 그림 개수
final completedDrawingsCountProvider = Provider<int>((ref) {
  final session = ref.watch(htpSessionProvider);
  return session.completedCount;
});

/// 제출 가능 여부
final canSubmitProvider = Provider<bool>((ref) {
  final session = ref.watch(htpSessionProvider);
  return session.canSubmit;
});

/// 특정 그림 상태
final drawingStatusProvider = Provider.family<HtpDrawingStatus, String>((ref, drawingType) {
  final session = ref.watch(htpSessionProvider);
  return session.getDrawingStatus(drawingType);
});

/// 로딩 상태
final isLoadingProvider = Provider<bool>((ref) {
  final session = ref.watch(htpSessionProvider);
  return session.isLoading;
});

/// 에러 메시지
final errorMessageProvider = Provider<String?>((ref) {
  final session = ref.watch(htpSessionProvider);
  return session.error;
});

// ===== 7. HTP Drawing Status Enum (기존과 동일) =====
enum HtpDrawingStatus {
  notStarted,   // 시작 안함
  inProgress,   // 작업중
  completed,    // 완료
}

// ===== 8. 사용 예시 (주석) =====
/*
// main.dart에서 ProviderScope 감싸기
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Dashboard에서 사용
class HtpDashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(completedDrawingsCountProvider);
    final canSubmit = ref.watch(canSubmitProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final error = ref.watch(errorMessageProvider);

    // 에러 리스닝
    ref.listen(errorMessageProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
      }
    });

    return Scaffold(...);
  }

  void _navigateToDrawing(String type, WidgetRef ref) async {
    // 그리기 시작 알림
    ref.read(htpSessionProvider.notifier).startDrawing(type);

    final result = await Navigator.push(...);

    if (result is HtpDrawing) {
      // 그림 완료 데이터 추가
      ref.read(htpSessionProvider.notifier).addDrawing(type, result);
    }
  }

  void _submitSession(WidgetRef ref) {
    ref.read(htpSessionProvider.notifier).submitSession();
  }
}
*/