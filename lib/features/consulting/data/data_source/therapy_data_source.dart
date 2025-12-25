import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 프로젝트 구조에 맞게 import 경로 수정 필요
import '../../../../../core/network/api_response_dto.dart';
import '../../../../core/network/dio_provider.dart';
import '../dto/journal_response.dart';
import '../dto/journal_submit_request.dart';
import '../dto/therapy_chat_request.dart';
import '../dto/therapy_chat_response.dart';

part 'therapy_data_source.g.dart';

@riverpod
TherapyDataSource therapyDataSource(TherapyDataSourceRef ref) {
  final dio = ref.watch(dioProvider); // 전역 Dio Provider
  return TherapyDataSource(dio);
}

/// 🧠 [TherapyDataSource]
///
/// AI 심리 상담(채팅) 관련 API 호출을 담당합니다.
/// 서버 Controller: TherapyController
@RestApi()
abstract class TherapyDataSource {
  factory TherapyDataSource(Dio dio, {String baseUrl}) = _TherapyDataSource;

  /// 🗣️ AI 상담 메시지 전송
  ///
  /// - 엔드포인트: POST /api/therapy/chat
  /// - 기능: 사용자의 메시지와 이전 대화 내역을 보내 AI 답변을 받음.
  /// - 인증: 필수 (AccessToken)
  @POST('/therapy/chat')
  Future<ApiResponse<TherapyChatResponse>> sendChatMessage(
    @Header('Authorization') String authorization,
    @Body() TherapyChatRequest request,
  );

  @POST('/journals')
  Future<ApiResponse<JournalResponse>> createJournal(
    @Header('Authorization') String authorization,
    @Body()



    JournalSubmitRequest request,
  );
}
