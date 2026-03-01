import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/response/profile_dto.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'ink_history_provider.g.dart';

@riverpod
class InkHistoryNotifier extends _$InkHistoryNotifier {

  // 🌟 build() 메서드에서 바로 비동기 로딩을 수행합니다.
  @override
  Future<List<InkHistoryResponse>> build() async {
    final useCase = ref.read(profileUseCaseProvider);

    // 10개만 요청
    final result = await useCase.getInkHistory(0, 10);

    return result.fold(
      onSuccess: (pageData) {
        print('✅ [InkNotifier] UI 데이터 로드 완료: ${pageData.content.length}개');
        return pageData.content; // 이 값이 바로 state(AsyncData)가 됩니다.
      },
      onFailure: (msg, code) {
        // 에러를 던지면 UI의 error 위젯이 받아서 처리합니다.
        throw Exception(msg);
      },
    );
  }
}