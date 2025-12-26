import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../../../core/utils/result.dart';
import '../../data/dto/anger_vent_response.dart';
import '../../data/dto/journal_response.dart';
import '../../data/dto/therapy_chat_request.dart';
import '../../data/dto/therapy_chat_response.dart';
import '../../data/repository/therapy_repository_impl.dart';
import '../repository/therapy_repository.dart'; // Repository Provider import

part 'therapy_use_case.g.dart';

/// 🏭 TherapyUseCase Provider
@riverpod
TherapyUseCase therapyUseCase(TherapyUseCaseRef ref) {
  // Repository Provider를 구독
  final repository = ref.read(therapyRepositoryProvider);
  return TherapyUseCase(repository);
}

/// 🧠 심리 상담(채팅) 비즈니스 로직
class TherapyUseCase {
  final TherapyRepository _repository;

  TherapyUseCase(this._repository);


  /// AI 샌드백에게 화풀기 메시지를 보내고 맞장구 답변을 받음
  Future<Result<AngerVentResponse>> sendAngerVentMessage({
    required String message,
    required List<ChatHistory> history,
  }) async {
    try {
      print('🔥 TherapyUseCase - sendAngerVentMessage 호출: "$message"');
      print('📜 전송할 히스토리 개수: ${history.length}');

      // Repository의 화풀기 전용 메서드 호출
      final result = await _repository.sendAngerVentMessage(
        message: message,
        history: history,
      );

      if (result.isSuccess) {
        print('✅ TherapyUseCase - 화풀기 응답 성공');
      } else {
        print('❌ TherapyUseCase - 화풀기 응답 실패: ${result.errorCode}');
      }

      return result;
    } catch (e) {
      print('💥 TherapyUseCase - 예상치 못한 오류: $e');
      return Result.failure('답변을 생성하는 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }


  // =============================================================
  // 🗣️ 상담 메시지 전송
  // =============================================================

  /// AI에게 메시지를 보내고 답변을 받음
  ///
  /// [message]: 사용자의 현재 입력
  /// [history]: 이전 대화 내역 (Context 유지용)
  Future<Result<TherapyChatResponse>> sendMessage({
    required String message,
    required List<ChatHistory> history,
  }) async {
    try {
      print('🧠 TherapyUseCase - sendMessage 호출: "$message"');
      print('📜 전송할 히스토리 개수: ${history.length}');

      final result = await _repository.sendChatMessage(
        message: message,
        history: history,
      );

      if (result.isSuccess) {
        print('✅ TherapyUseCase - 응답 성공');
      } else {
        print('❌ TherapyUseCase - 응답 실패: ${result.errorCode}');
      }

      return result;
    } catch (e) {
      print('💥 TherapyUseCase - 예상치 못한 오류: $e');
      return Result.failure('답변을 생성하는 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }



  // 👇 [신규 추가] 감정 일기 작성 및 분석 요청
  Future<Result<JournalResponse>> createJournal({
    required String date,
    required String content,
  }) async {
    try {
      print('📝 TherapyUseCase - createJournal 호출: $date');

      final result = await _repository.createJournal(
        date: date,
        content: content,
      );

      if (result.isSuccess) {
        print('✅ TherapyUseCase - 일기 분석 성공');
      } else {
        print('❌ TherapyUseCase - 일기 분석 실패: ${result.errorCode}');
      }

      return result;
    } catch (e) {
      print('💥 TherapyUseCase - 예상치 못한 오류: $e');
      return Result.failure('일기 분석 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }


}