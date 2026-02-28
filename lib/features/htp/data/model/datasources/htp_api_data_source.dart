// lib/features/htp/data/datasources/remote/htp_api_data_source.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/network/dio_provider.dart';
import '../../../../../core/network/api_response_dto.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';

part 'htp_api_data_source.g.dart';

@riverpod
HtpApiDataSource htpApiDataSource(HtpApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return HtpApiDataSource(dio);
}

class HtpApiDataSource {
  final Dio _dio;
  HtpApiDataSource(this._dio);

  /// 🧠 HTP 프리미엄/기본 분석 공통 처리
  Future<ApiResponse<TestResultResponse>> _analyze({
    required String path,
    required List<File> images,
    required String requestJson,
    required String accessToken,
  }) async {
    // 1. 이미지 파일들을 MultipartFile로 변환
    final List<MultipartFile> imageParts = [];
    for (var file in images) {
      final fileName = file.path.split('/').last;
      imageParts.add(await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('image', fileName.endsWith('png') ? 'png' : 'jpeg'),
      ));
    }

    // 2. JSON 요청 데이터를 MultipartFile로 변환 (Content-Type 지정)
    final requestPart = MultipartFile.fromString(
      requestJson,
      contentType: MediaType('application', 'json'),
    );

    // 3. FormData 생성
    final formData = FormData.fromMap({
      'images': imageParts, // 서버의 @RequestPart("images")와 매칭
      'request': requestPart, // 서버의 @RequestPart("request")와 매칭
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

  Future<ApiResponse<TestResultResponse>> analyzeBasic(
      List<File> images, String requestJson, String token) {
    return _analyze(path: '/htp/basic-analysis', images: images, requestJson: requestJson, accessToken: token);
  }

  Future<ApiResponse<TestResultResponse>> analyzePremium(
      List<File> images, String requestJson, String token) {
    return _analyze(path: '/htp/premium-analysis', images: images, requestJson: requestJson, accessToken: token);
  }
}