import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/dto/comprehensive_analysis_response.dart';
import '../../domain/usecase/user_analysis_use_case.dart';

part 'comprehensive_analysis_notifier.freezed.dart';
part 'comprehensive_analysis_notifier.g.dart';

@freezed
class ComprehensiveAnalysisState with _$ComprehensiveAnalysisState {
  const factory ComprehensiveAnalysisState({
    @Default(false) bool isLoading,
    ComprehensiveAnalysisResponse? report,
    String? errorMessage,
  }) = _ComprehensiveAnalysisState;

  factory ComprehensiveAnalysisState.initial() => const ComprehensiveAnalysisState();
}

@riverpod
class ComprehensiveAnalysisNotifier extends _$ComprehensiveAnalysisNotifier {
  // Hive Box 이름 및 키 상수
  static const String _boxName = 'analysis_cache';
  static const String _keyName = 'comprehensive_report';

  @override
  ComprehensiveAnalysisState build() {
    // 🚀 화면(Provider)이 생성되자마자 Hive 캐시만 조용히 확인하도록 설정
    Future.microtask(() => _initLoadFromHive());
    return const ComprehensiveAnalysisState();
  }

  /// 📥 [추가] 앱 시작 시 Hive 캐시만 확인하는 함수
  Future<void> _initLoadFromHive() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final box = await Hive.openBox(_boxName);
      final cachedData = box.get(_keyName);

      if (cachedData != null) {
        // 캐시가 있으면 바로 화면에 띄움
        final report = ComprehensiveAnalysisResponse.fromJson(Map<String, dynamic>.from(cachedData));
        state = state.copyWith(isLoading: false, report: report);
      } else {
        // 캐시가 없으면 API를 부르지 않고 로딩만 끝냄 -> 'AI 종합 분석 받기' 버튼이 노출됨
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // 에러 발생 시 초기 상태로 둠
      state = state.copyWith(isLoading: false);
    }
  }

  /// 📥 리포트 로드 (Hive 우선 -> 없으면 API)
  Future<void> loadAnalysisReport() async {
    // 1. 이미 메모리에 있으면 스킵
    if (state.report != null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 2. Hive 캐시 확인
      final box = await Hive.openBox(_boxName);
      final cachedData = box.get(_keyName);

      if (cachedData != null) {
        // 캐시가 있으면 바로 적용
        try {
          // Hive에는 Map 형태로 저장됨 -> DTO 변환
          final report = ComprehensiveAnalysisResponse.fromJson(Map<String, dynamic>.from(cachedData));
          state = state.copyWith(isLoading: false, report: report);
          return; // API 호출 안 하고 종료
        } catch (e) {
          // 캐시 파싱 에러 시 무시하고 API 호출 진행
          await box.delete(_keyName);
        }
      }

      // 3. 캐시 없으면 API 호출
      await _fetchAndSave();

    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }

  /// 🔄 다시 받기 (API 강제 호출 -> Hive 덮어쓰기)
  Future<void> refreshAnalysis() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _fetchAndSave();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '재분석 중 오류가 발생했습니다.');
    }
  }

  /// ⚙️ 내부 메서드: API 호출 및 저장
  Future<void> _fetchAndSave() async {
    final useCase = ref.read(userAnalysisUseCaseProvider);
    final result = await useCase.getComprehensiveAnalysis();

    result.fold(
      onSuccess: (data) async {
        // 성공 시 Hive에 저장 (toJson)
        final box = await Hive.openBox(_boxName);
        await box.put(_keyName, data.toJson());

        state = state.copyWith(isLoading: false, report: data);
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }
}