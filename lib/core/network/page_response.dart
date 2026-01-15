import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_response.freezed.dart';
part 'page_response.g.dart';

// ✅ 여기서 genericArgumentFactories: true를 설정해야 제네릭 T를 처리할 수 있습니다.
@Freezed(genericArgumentFactories: true)
class PageResponse<T> with _$PageResponse<T> {
  const factory PageResponse({
    required List<T> content,
    required int totalPages,
    required int totalElements,
    required int size,
    required int number,
    required bool last,
    required bool first,
  }) = _PageResponse;

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PageResponseFromJson(json, fromJsonT);
}