// ==========================================================
// 1️⃣ Repository Interface (Domain Layer)
// ==========================================================
import '../../../../core/utils/result.dart';
import '../../data/dto/journal_response.dart';
import '../../data/dto/therapy_chat_request.dart';
import '../../data/dto/therapy_chat_response.dart';

abstract class TherapyRepository {
  /// AI 상담 메시지 전송
  /// [message]: 사용자의 현재 고민
  /// [history]: 이전 대화 내역 리스트 (Context 유지용)
  Future<Result<TherapyChatResponse>> sendChatMessage({
    required String message,
    required List<ChatHistory> history,
  });
  Future<Result<JournalResponse>> createJournal({
    required String date,
    required String content,
  });

}