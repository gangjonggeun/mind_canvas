import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
class ProfileSummaryResponse with _$ProfileSummaryResponse {
  const factory ProfileSummaryResponse({
    required String nickname,
    String? profileImageUrl,
    required int inkBalance,
    required int postCount,
    required int testCount,
    required int receivedLikeCount,
    required String language,
  }) = _ProfileSummaryResponse;

  factory ProfileSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileSummaryResponseFromJson(json);
}

@freezed
class InkHistoryResponse with _$InkHistoryResponse {
  const factory InkHistoryResponse({
    required int id,
    required String type, // CHARGE, USED, AD_REWARD
    required int amount,
    required int balanceAfter,
    required String description,
    required DateTime createdAt,
  }) = _InkHistoryResponse;

  factory InkHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InkHistoryResponseFromJson(json);
}

@freezed
class MyTestResultSummaryResponse with _$MyTestResultSummaryResponse {
  const factory MyTestResultSummaryResponse({
    required int id,
    required String testTitle,
    required String testTag,
    // required String resultKey,
    // required String resultTag,
    // required String briefDescription,
    required String createdAt,
  }) = _MyTestResultSummaryResponse;

  factory MyTestResultSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$MyTestResultSummaryResponseFromJson(json);
}