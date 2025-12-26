import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mind_canvas/features/consulting/data/dto/therapy_chat_request.dart';

part 'anger_vent_request.freezed.dart';
part 'anger_vent_request.g.dart';

@freezed
class AngerVentRequest with _$AngerVentRequest {
  const factory AngerVentRequest({
    /// 사용자가 입력한 화풀이 메시지
    required String message,

    /// 대화 내역 (Context 유지용)
    @Default([]) List<ChatHistory> history,
  }) = _AngerVentRequest;

  factory AngerVentRequest.fromJson(Map<String, dynamic> json) =>
      _$AngerVentRequestFromJson(json);
}

