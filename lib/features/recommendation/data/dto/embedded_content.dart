import 'package:freezed_annotation/freezed_annotation.dart';

part 'embedded_content.freezed.dart';
part 'embedded_content.g.dart';

@freezed
class EmbeddedContent with _$EmbeddedContent {
  const factory EmbeddedContent({
    required String type,       // MOVIE, BOOK ...
    @JsonKey(name: 'content_id') String? contentId,
    required String title,
    String? thumbnail,
    @JsonKey(name: 'sub_text') String? subText, // 연도, 장르 등
  }) = _EmbeddedContent;

  factory EmbeddedContent.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedContentFromJson(json);
}