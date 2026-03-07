import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/response/profile_dto.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'ink_history_provider.g.dart';

@riverpod
class InkHistoryNotifier extends _$InkHistoryNotifier {

  @override
  Future<List<InkHistoryResponse>> build() async {
    final useCase = ref.read(profileUseCaseProvider);
    final result = await useCase.getInkHistory(0, 10);

    return result.fold(
      onSuccess: (pageData) {
        print('✅ [InkNotifier] UI 데이터 로드 완료: ${pageData.content.length}개');
        return pageData.content;
      },
      onFailure: (msg, code) {
        throw Exception(msg);
      },
    );
  }

  /// 💳 [신규 추가] RevenueCat 결제 완료 후 서버와 동기화하는 함수
  Future<void> syncPurchaseWithServer() async {
    try {
      final useCase = ref.read(profileUseCaseProvider);

      // 1. 서버에 RevenueCat 동기화 API 핑(요청) 보내기
      // (ProfileUseCase에 syncRevenueCat API 호출 로직을 미리 만들어두셔야 합니다)
      final result = await useCase.syncRevenueCat();

      result.fold(
        onSuccess: (_) {
          print('✅ [InkNotifier] 서버에 결제 내역 동기화 성공!');

          // 2. 유저 전체 상태 갱신 (지갑의 잉크 잔액 업데이트)
          // userNotifierProvider에 refreshUser() 혹은 프로필 새로고침 함수 호출
          // ref.read(userNotifierProvider.notifier).refreshProfile();

          // 3. ✨[핵심] 결제 내역(History) 리스트 새로고침
          // invalidateSelf()를 호출하면 build()가 다시 실행되면서 맨 위 최신 내역이 추가됩니다!
          ref.invalidateSelf();
        },
        onFailure: (msg, code) {
          print('❌ [InkNotifier] 서버 동기화 실패: $msg');
          // 필요하다면 에러 처리 (스낵바를 띄우기 위해 return 타입 변경 등)
        },
      );
    } catch (e) {
      print('❌ [InkNotifier] 동기화 중 에러 발생: $e');
    }
  }
}