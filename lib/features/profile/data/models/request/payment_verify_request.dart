import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_verify_request.freezed.dart';
part 'payment_verify_request.g.dart';

@freezed
class PaymentVerifyRequest with _$PaymentVerifyRequest {
  const factory PaymentVerifyRequest({
    required String merchantUid, // 주문 번호
    required String portoneId,   // 포트원 결제 고유 ID (imp_uid)
  }) = _PaymentVerifyRequest;

  factory PaymentVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentVerifyRequestFromJson(json);
}