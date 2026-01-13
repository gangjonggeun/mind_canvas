import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_response.freezed.dart';
part 'page_response.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class PageResponse<T> with _$PageResponse<T> {
  const factory PageResponse({
    required List<T> content,
    required int totalPages,
    required int totalElements,
    required int size,
    required int number, // 현재 페이지 번호
    required bool last,
    required bool first,
  }) = _PageResponse;

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PageResponseFromJson(json, fromJsonT);
}