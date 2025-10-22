// =============================================================
// 📁 lib/features/test/data/models/response/test_content_response.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_content_response.freezed.dart';
part 'test_content_response.g.dart';

/// 🧠 테스트 콘텐츠 응답 DTO (서버 API 매칭)
@freezed
class TestContentResponse with _$TestContentResponse {
  const factory TestContentResponse({
    @JsonKey(name: 'pages') required List<TestPageDto> pages,
    @JsonKey(name: 'totalQuestions') required int totalQuestions,
    @JsonKey(name: 'totalPages') required int totalPages,
  }) = _TestContentResponse;

  factory TestContentResponse.fromJson(Map<String, dynamic> json) =>
      _$TestContentResponseFromJson(json);
}

/// 📖 테스트 페이지 DTO
@freezed
class TestPageDto with _$TestPageDto {
  const factory TestPageDto({
    @JsonKey(name: 'pageNumber') required int pageNumber,
    @JsonKey(name: 'questions') required List<TestQuestionDto> questions,
  }) = _TestPageDto;

  factory TestPageDto.fromJson(Map<String, dynamic> json) =>
      _$TestPageDtoFromJson(json);
}

/// ❓ 테스트 질문 DTO
@freezed
class TestQuestionDto with _$TestQuestionDto {
  const factory TestQuestionDto({
    @JsonKey(name: 'questionId') required String questionId,
    @JsonKey(name: 'questionText') required String questionText,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'inputType') required String inputType,
    @JsonKey(name: 'options') List<OptionDto>? options,
    @JsonKey(name: 'questionOrder') required int questionOrder,
  }) = _TestQuestionDto;

  factory TestQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$TestQuestionDtoFromJson(json);
}

/// 🔘 선택지 DTO
@freezed
class OptionDto with _$OptionDto {
  const factory OptionDto({
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'value') required String value,
    @JsonKey(name: 'optionOrder') required int optionOrder,
  }) = _OptionDto;

  factory OptionDto.fromJson(Map<String, dynamic> json) =>
      _$OptionDtoFromJson(json);
}