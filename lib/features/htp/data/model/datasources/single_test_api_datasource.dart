// lib/features/single_test/data/datasources/single_test_api_datasource.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/network/dio_provider.dart';
import '../../../../../core/network/api_response_dto.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';

part 'single_test_api_datasource.g.dart';

@riverpod
SingleTestApiDataSource singleTestApiDataSource(SingleTestApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return SingleTestApiDataSource(dio);
}

class SingleTestApiDataSource {
  final Dio _dio;
  SingleTestApiDataSource(this._dio);

  Future<ApiResponse<TestResultResponse>> _analyze({
    required String path,
    required File imageFile,
    required String requestJson,
    required String accessToken,
  }) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'imageFile': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', fileName.endsWith('png') ? 'png' : 'jpeg'),
      ),
      'request': MultipartFile.fromString(
        requestJson,
        contentType: MediaType('application', 'json'),
      ),
    });

    final response = await _dio.post(
      path,
      data: formData,
      options: Options(
        headers: {'Authorization': accessToken},
        contentType: 'multipart/form-data',
      ),
    );

    return ApiResponse<TestResultResponse>.fromJson(
      response.data,
          (json) => TestResultResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<TestResultResponse>> analyzeStarrySea(File image, String json, String token) =>
      _analyze(path: '/analyze/starry-sea', imageFile: image, requestJson: json, accessToken: token);

  Future<ApiResponse<TestResultResponse>> analyzePitr(File image, String json, String token) =>
      _analyze(path: '/analyze/pitr', imageFile: image, requestJson: json, accessToken: token);

  Future<ApiResponse<TestResultResponse>> analyzeFishbowl(File image, String json, String token) =>
      _analyze(path: '/analyze/fishbowl', imageFile: image, requestJson: json, accessToken: token);
}