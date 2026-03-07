import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquiry_request.freezed.dart';
part 'inquiry_request.g.dart';

@freezed
class InquiryRequest with _$InquiryRequest {
  const factory InquiryRequest({
    required String category,
    required String title,
    required String content,
    required String osInfo,
    required String appVersion,
  }) = _InquiryRequest;

  factory InquiryRequest.fromJson(Map<String, dynamic> json) => _$InquiryRequestFromJson(json);
}