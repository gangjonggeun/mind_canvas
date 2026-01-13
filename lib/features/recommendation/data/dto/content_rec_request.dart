import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/rec_category.dart';


part 'content_rec_request.freezed.dart';
part 'content_rec_request.g.dart';

@freezed
class ContentRecRequest with _$ContentRecRequest {
  @JsonSerializable(explicitToJson: true)
  const factory ContentRecRequest({
    /// 추천받고 싶은 카테고리 리스트 (최소 1개)
    required List<RecCategory> categories,

    /// 사용자의 현재 기분 (옵션)
    String? userMood,
  }) = _ContentRecRequest;

  factory ContentRecRequest.fromJson(Map<String, dynamic> json) =>
      _$ContentRecRequestFromJson(json);
}