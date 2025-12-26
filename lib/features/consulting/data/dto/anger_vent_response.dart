import 'package:freezed_annotation/freezed_annotation.dart';

part 'anger_vent_response.freezed.dart';
part 'anger_vent_response.g.dart';

@freezed
class AngerVentResponse with _$AngerVentResponse {
  const factory AngerVentResponse({
    /// AI의 반응 (위로, 공감, 또는 샌드백 역할)
    required String aiResponse,
  }) = _AngerVentResponse;

  factory AngerVentResponse.fromJson(Map<String, dynamic> json) =>
      _$AngerVentResponseFromJson(json);
}