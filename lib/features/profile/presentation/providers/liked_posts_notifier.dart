import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/utils/result.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'liked_posts_notifier.g.dart';
@riverpod
class LikedPostsNotifier extends _$LikedPostsNotifier {
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  FutureOr<List<PostResponse>> build() async {
    // 초기 데이터 로드
    _currentPage = 0;
    return _fetchLikedPosts();
  }

  Future<List<PostResponse>> _fetchLikedPosts() async {
    final result = await ref.read(profileUseCaseProvider).getLikedPosts(
        _currentPage,5);

    return result.fold(
      onSuccess: (pageResponse) {
        _isLastPage = pageResponse.last; // 서버 응답의 마지막 페이지 여부 저장

        // 💡 팁: '좋아요한 게시글' 목록이므로 서버 응답과 상관없이
        // 클라이언트에서 강제로 isLiked를 true로 설정해주는 것이 안전합니다.
        return pageResponse.content
            .map((post) => post.copyWith(isLiked: true))
            .toList();
      },
      onFailure: (msg, code) {
        // 에러 발생 시 런타임 에러를 던져서 AsyncValue.error로 처리되게 함
        throw Exception(msg);
      },
    );
  }

  /// 스크롤 하단 도달 시 추가 데이터 로드
  Future<void> loadMore() async {
    if (state.isLoading || _isLastPage) return;

    final previousPosts = state.value ?? [];
    _currentPage++;

    // 로딩 상태를 보여주고 싶다면 이전 데이터와 함께 로딩을 띄울 수 있음
    // state = const AsyncLoading();

    final nextResult = await AsyncValue.guard(() async {
      final newPosts = await _fetchLikedPosts();
      return [...previousPosts, ...newPosts];
    });

    state = nextResult;
  }
}