import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import 경로 확인 필요
import '../../../../core/utils/result.dart'; // Result 클래스
import '../../data/dto/content_rec_response.dart'; // DTO
import '../../domain/entity/recommendation_result.dart'; // Entity
import '../../domain/enums/rec_category.dart';
import '../../domain/usecase/recommend_content_use_case.dart';

part 'recommendation_notifier.freezed.dart';
part 'recommendation_notifier.g.dart';

/// 🎬 추천 상태 (State)
@freezed
class RecommendationState with _$RecommendationState {
  const factory RecommendationState({
    @Default(false) bool isLoading,              // 로딩 중 여부
    RecommendationResult? result,                // 추천 결과 (Entity)
    String? errorMessage,
    String? errorCode// 에러 메시지
  }) = _RecommendationState;

  factory RecommendationState.initial() => const RecommendationState();
}

/// 🎬 추천 Notifier
///
/// - keepAlive: true 설정으로 사용자가 화면을 떠나도 데이터가 메모리에 유지됩니다.
/// - 명시적으로 refresh를 요청해야만 새로운 데이터를 불러옵니다.
@Riverpod(keepAlive: true)
class RecommendationNotifier extends _$RecommendationNotifier {
  @override
  RecommendationState build() {
    // 💡 생성되자마자 저장된 데이터가 있는지 확인하고 로드
    _loadInitialData();
    return RecommendationState.initial();
  }


  /// 🏁 초기 데이터 로드 (API 호출 안 함, 로컬만 확인)
  Future<void> _loadInitialData() async {
    // 빈 리스트라도 넘겨서 로컬 데이터 확인 시도 (Repository 로직상 로컬 있으면 리턴함)
    // 단, 카테고리는 필수가 아니거나, 저장된 거 불러올 때는 무시되도록 로직이 흐름
    // 여기서는 간단히 fetchRecommendations 호출하되 forceRefresh=false로 함.

    // 만약 로컬 데이터가 없다면 아무것도 안 하거나,
    // 기본 상태(null)로 두어 UI에서 "추천받기" 버튼을 누르게 유도

    final useCase = ref.read(recommendContentUseCaseProvider);

    // 임시 카테고리 (로컬 데이터 조회용이라 실제 API 호출까진 안 감)
    final result = await useCase.execute(
        categories: [],
        forceRefresh: false
    );

    result.fold(
      onSuccess: (data) {
        // 저장된 데이터가 있으면 상태 업데이트
        final entity = _mapDtoToEntity(data);
        state = state.copyWith(result: entity);
      },
      onFailure: (msg, code) {
        // 저장된 데이터 없으면 그냥 무시 (유저가 버튼 누르게 함)
      },
    );
  }

  /// 콘텐츠 추천 요청
  Future<void> fetchRecommendations({
    required List<RecCategory> categories,
    String? userMood,
    bool forceRefresh = false, // ✅ 강제 새로고침 여부
  }) async {
    // 1. 이미 데이터가 있고, 강제 새로고침이 아니면 요청하지 않음 (캐싱)
    if (state.result != null && !forceRefresh) {
      return;
    }

    // 2. ✅ [핵심] 상태 업데이트: 로딩 중으로 변경
    // forceRefresh가 true면 'result'를 null로 만들어서 화면을 싹 비우고 로딩만 띄웁니다.
    state = state.copyWith(
      isLoading: true,
      result: forceRefresh ? null : state.result, // 재요청 시 기존 데이터 안 보여주고 로딩창 띄우기
      errorMessage: null,
    );

    try {
      final useCase = ref.read(recommendContentUseCaseProvider);

      // 3. UseCase 호출 (파라미터 전달 확인!)
      final result = await useCase.execute(
        categories: categories,
        userMood: userMood,
        forceRefresh: forceRefresh, // ✅ [중요] 여기서 true를 꼭 넘겨줘야 함!
      );

      // 4. 결과 처리
      result.fold(
        onSuccess: (responseDto) {
          final entity = _mapDtoToEntity(responseDto);
          state = state.copyWith(
            isLoading: false,
            result: entity,
            errorMessage: null,
            errorCode: null,
          );
        },
        onFailure: (message, code) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: message, // 실패 시 에러 메시지 표시
            // result: null, // (선택) 실패 시 기존 데이터도 날릴지, 남겨둘지 결정
            errorCode: code,
          );
        },
      );
    } catch (e) {
      print('🔥 Notifier 에러: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'unknow error',
      );
    }
  }

  /// 🔄 DTO -> Domain Entity 변환 헬퍼
  RecommendationResult _mapDtoToEntity(ContentRecResponse dto) {
    return RecommendationResult(
      createdAt: DateTime.now(),
      groups: dto.results.map((groupDto) {
        return RecommendationCategoryGroup(
          category: groupDto.category,
          items: groupDto.items.map((itemDto) {
            return RecommendationContent(
              title: itemDto.title,
              description: itemDto.description,
              reason: itemDto.reason,
              matchPercent: itemDto.matchPercent,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 상태 초기화 (필요 시 호출하여 메모리 정리)
  void clear() {
    state = RecommendationState.initial();
  }
}