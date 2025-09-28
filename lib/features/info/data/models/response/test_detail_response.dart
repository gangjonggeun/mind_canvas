// lib/features/info/data/models/response/test_detail_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_detail_response.freezed.dart';
part 'test_detail_response.g.dart';

@freezed
class TestDetailResponse with _$TestDetailResponse {
  const factory TestDetailResponse({
    required int testId,
    String? imagePath,
    String? psychologyTag,
    required String title,
    String? subtitle,
    required int estimatedTime,
    required String difficulty,
    String? introduction,
    List<String>? instructions,
    String? backgroundGradient,
    String? darkModeGradient,
  }) = _TestDetailResponse;

  factory TestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TestDetailResponseFromJson(json);
}