import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/recommended_content_entity.dart';
import '../data/recommended_content_data_service.dart';



/// 🔧 데이터 서비스 프로바이더 (의존성 주입)
/// 테스트에서 Mock으로 교체 가능
final recommendedContentDataServiceProvider = 
    Provider<IRecommendedContentDataService>((ref) {
  return RecommendedContentDataService();
});

/// 🎬 추천 컨텐츠 상태 관리 노티파이어
class RecommendedContentNotifier extends StateNotifier<RecommendedContentState> {
  RecommendedContentNotifier(this._dataService) : super(const RecommendedContentState());

  final IRecommendedContentDataService _dataService;

  /// 🔄 컨텐츠 타입 변경
  void changeContentType(ContentType contentType) {
    if (state.selectedContentType == contentType) return;
    
    // logger.state('컨텐츠 타입 변경: $contentType');
    
    state = state.copyWith(selectedContentType: contentType);
    _loadRecommendedContents();
  }

  /// 🔄 컨텐츠 모드 변경 (개인 vs 함께보기)
  void changeContentMode(ContentMode contentMode) {
    if (state.selectedContentMode == contentMode) return;

    // logger.state('컨텐츠 모드 변경: $contentMode');
    
    state = state.copyWith(selectedContentMode: contentMode);
    _loadRecommendedContents();
  }

  /// 🔄 파트너 MBTI 변경
  void changePartnerMbti(String mbtiType) {
    if (state.partnerMbti.type == mbtiType) return;

    // logger.state('파트너 MBTI 변경: $mbtiType');
    
    state = state.copyWith(
      partnerMbti: MbtiInfo(type: mbtiType),
    );

    // 함께 보기 모드일 때만 다시 로드
    if (state.selectedContentMode == ContentMode.together) {
      _loadRecommendedContents();
    }
  }

  /// 🔄 사용자 MBTI 변경
  void changeUserMbti(String mbtiType) {
    if (state.userMbti.type == mbtiType) return;

    // logger.state('사용자 MBTI 변경: $mbtiType');
    
    state = state.copyWith(
      userMbti: MbtiInfo(type: mbtiType),
    );
    
    _loadRecommendedContents();
  }

  /// 📊 추천 컨텐츠 로드
  Future<void> _loadRecommendedContents() async {
    // 중복 로딩 방지
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    // logger.state('추천 컨텐츠 로딩: type=${state.selectedContentType}, mode=${state.selectedContentMode}');

    final result = await _dataService.getRecommendedContents(
      contentType: state.selectedContentType,
      contentMode: state.selectedContentMode,
      userMbti: state.userMbti,
      partnerMbti: state.partnerMbti,
    );

    // TODO:  이부분 다시 제작
    // result.when(
    //   success: (contents) {
    //     // logger.state('추천 컨텐츠 로딩 성공: ${contents.length}개');
    //
    //     state = state.copyWith(
    //       contents: contents,
    //       isLoading: false,
    //       errorMessage: null,
    //     );
    //   },
    //   failure: (message, code) {
    //     // logger.e('추천 컨텐츠 로딩 실패: $message', null, null, AppLogger.tagState);
    //
    //     state = state.copyWith(
    //       isLoading: false,
    //       errorMessage: message,
    //     );
    //   },
    //   loading: () {
    //     // 이미 로딩 상태 설정됨
    //   },
    // );
  }

  /// 🔄 새로고침
  Future<void> refresh() async {
    // logger.state('추천 컨텐츠 새로고침');
    await _loadRecommendedContents();
  }

  /// 🎯 초기 로드
  Future<void> initialize() async {
    // logger.state('추천 컨텐츠 초기화');
    await _loadRecommendedContents();
  }

  /// 🧹 리소스 정리
  @override
  void dispose() {
    // logger.state('RecommendedContentNotifier 정리');
    super.dispose();
  }
}

/// 🎬 추천 컨텐츠 상태 프로바이더
final recommendedContentProvider = StateNotifierProvider<
    RecommendedContentNotifier, RecommendedContentState>((ref) {
  final dataService = ref.watch(recommendedContentDataServiceProvider);
  return RecommendedContentNotifier(dataService);
});

/// 📱 MBTI 타입 목록 프로바이더
final mbtiTypesProvider = Provider<List<String>>((ref) {
  final dataService = ref.watch(recommendedContentDataServiceProvider);
  return dataService.getMbtiTypes();
});

/// 🎯 현재 표시할 컨텐츠 목록 (computed property)
final currentContentsProvider = Provider<List<RecommendedContentEntity>>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.contents;
});

/// 🔄 로딩 상태 프로바이더
final isLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.isLoading;
});

/// ❌ 에러 상태 프로바이더
final errorMessageProvider = Provider<String?>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.errorMessage;
});

/// 🎨 선택된 컨텐츠 타입 프로바이더
final selectedContentTypeProvider = Provider<ContentType>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.selectedContentType;
});

/// 👥 선택된 컨텐츠 모드 프로바이더
final selectedContentModeProvider = Provider<ContentMode>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.selectedContentMode;
});

/// 📱 사용자 MBTI 프로바이더
final userMbtiProvider = Provider<MbtiInfo>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.userMbti;
});

/// 👫 파트너 MBTI 프로바이더
final partnerMbtiProvider = Provider<MbtiInfo>((ref) {
  final state = ref.watch(recommendedContentProvider);
  return state.partnerMbti;
});

/// 🎯 컨텐츠 액션 프로바이더 (UI에서 액션 호출용)
final recommendedContentActionsProvider = Provider<RecommendedContentActions>((ref) {
  final notifier = ref.watch(recommendedContentProvider.notifier);
  return RecommendedContentActions(notifier);
});

/// 🎬 추천 컨텐츠 액션 클래스
/// UI와 비즈니스 로직 분리를 위한 액션 래퍼
class RecommendedContentActions {
  final RecommendedContentNotifier _notifier;
  
  RecommendedContentActions(this._notifier);

  /// 컨텐츠 타입 변경
  void changeContentType(ContentType contentType) =>
      _notifier.changeContentType(contentType);

  /// 컨텐츠 모드 변경
  void changeContentMode(ContentMode contentMode) =>
      _notifier.changeContentMode(contentMode);

  /// 파트너 MBTI 변경
  void changePartnerMbti(String mbtiType) =>
      _notifier.changePartnerMbti(mbtiType);

  /// 사용자 MBTI 변경
  void changeUserMbti(String mbtiType) =>
      _notifier.changeUserMbti(mbtiType);

  /// 새로고침
  Future<void> refresh() => _notifier.refresh();

  /// 초기화
  Future<void> initialize() => _notifier.initialize();
}
