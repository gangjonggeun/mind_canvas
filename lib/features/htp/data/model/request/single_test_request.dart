// lib/features/single_test/data/model/request/single_test_request.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../htp/data/model/request/htp_basic_request.dart'; // DrawingProcess 임포트

part 'single_test_request.freezed.dart';
part 'single_test_request.g.dart';

@freezed
class SingleTestRequest with _$SingleTestRequest {
  const factory SingleTestRequest({
    required Map<String, String> answers,
    required DrawingProcess drawingProcess, // 🚀 메타데이터 포함!
  }) = _SingleTestRequest;

  factory SingleTestRequest.fromJson(Map<String, dynamic> json) =>
      _$SingleTestRequestFromJson(json);
}