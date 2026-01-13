import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/community_enums.dart';

part 'channel_recommendation_response.freezed.dart';
part 'channel_recommendation_response.g.dart';

@freezed
class ChannelRecommendationResponse with _$ChannelRecommendationResponse {
  const factory ChannelRecommendationResponse({
    required ChannelType channel,
    required String name,
    required String description,
    required String reason,
    @JsonKey(name: 'is_joined') required bool isJoined,
  }) = _ChannelRecommendationResponse;

  factory ChannelRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$ChannelRecommendationResponseFromJson(json);
}