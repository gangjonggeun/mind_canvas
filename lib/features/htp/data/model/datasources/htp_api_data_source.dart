// =============================================================
// 📁 data/datasources/remote/htp_api_data_source.dart
// =============================================================

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../../../../../core/network/dio_provider.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../response/htp_response.dart';

part 'htp_api_data_source.g.dart';

/// 🎨 HTP(집-나무-사람) 그림검사 API 데이터 소스
///
/// <p><strong>핵심 기능:</strong></p>
/// - 🖼️ 그림 이미지 3장 업로드 (House, Tree, Person)
/// - 🧠 AI 기반 심리 분석 (기본 / 프리미엄)
/// - 📊 그리기 과정 데이터 분석 (시간, 순서, 압력 등)
/// - 🔒 인증 필수 (Bearer 토큰)
///
/// <p><strong>Multipart 업로드 처리:</strong></p>
/// - images: 그림 파일 리스트 (PNG/JPG, 최대 5MB/장)
/// - request: JSON 데이터 (그리기 과정, PDI 답변 등)
///
/// <p><strong>주의사항:</strong></p>
/// - Multipart 요청의 복잡성 때문에 Retrofit 대신 순수 Dio 사용
/// - Content-Type 명시 필수

@riverpod
HtpApiDataSource htpApiDataSource(HtpApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return HtpApiDataSource(dio);
}

/// 🎨 HTP API 데이터 소스 (순수 Dio 구현)
class HtpApiDataSource {
  final Dio _dio;

  HtpApiDataSource(this._dio);

  /// 🖼️ HTP 기본 분석
  ///
  /// <p><strong>요청 구성:</strong></p>
  /// - images: List<MultipartFile> (3장)
  /// - request: MultipartFile (JSON, Content-Type: application/json)
  ///
  /// <p><strong>응답:</strong></p>
  /// - ApiResponse<HtpResponse>
  Future<ApiResponse<TestResultResponse>> analyzeBasic(
      List<MultipartFile> images,
      MultipartFile request,
      String authorization,
      ) async {
    try {
      // FormData 구성
      final formData = FormData.fromMap({
        'images': images, // 이미지 배열
        'request': request, // JSON (Content-Type 이미 지정됨)
      });

      // API 호출
      final response = await _dio.post(
        '/htp/basic-analysis',
        data: formData,
        options: Options(
          headers: {
            'Authorization': authorization,
          },
          contentType: 'multipart/form-data',
        ),
      );

      // ✅ 성공 응답 파싱
      print('✅ API 응답 수신: ${response.statusCode}');
      return ApiResponse<TestResultResponse>.fromJson(
        response.data,
            (json) => TestResultResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      // ❌ 에러 응답 처리
      print('❌ API 요청 실패: ${e.type}');

      if (e.response != null) {
        // 서버 응답이 있는 경우
        try {
          return ApiResponse<TestResultResponse>.fromJson(
            e.response!.data,
                (json) => TestResultResponse.fromJson(json as Map<String, dynamic>),
          );
        } catch (_) {
          // 응답 파싱 실패 시 기본 에러 응답
          return ApiResponse<TestResultResponse>(
            success: false,
            error: ErrorInfo(
              code: 'NETWORK_ERROR',
              message: e.message ?? '네트워크 오류가 발생했습니다',
            ),
          );
        }
      } else {
        // 네트워크 오류 (응답 없음)
        return ApiResponse<TestResultResponse>(
          success: false,
          error: ErrorInfo(
            code: 'CONNECTION_ERROR',
            message: '서버에 연결할 수 없습니다',
          ),
        );
      }
    }
  }

  /// 🧠 HTP 프리미엄 분석
  ///
  /// <p><strong>요청 구성:</strong></p>
  /// - images: List<MultipartFile> (3장)
  /// - request: MultipartFile (JSON, Content-Type: application/json)
  ///
  /// <p><strong>응답:</strong></p>
  /// - ApiResponse<HtpResponse>
  Future<ApiResponse<TestResultResponse>> analyzePremium(
      List<MultipartFile> images,
      MultipartFile request,
      String authorization,
      ) async {
    try {
      // FormData 구성
      final formData = FormData.fromMap({
        'images': images,
        'request': request,
      });

      // API 호출
      final response = await _dio.post(
        '/htp/premium-analysis',
        data: formData,
        options: Options(
          headers: {
            'Authorization': authorization,
          },
          contentType: 'multipart/form-data',
        ),
      );

      // ✅ 성공 응답 파싱
      print('✅ API 응답 수신: ${response.statusCode}');
      return ApiResponse<TestResultResponse>.fromJson(
        response.data,
            (json) => TestResultResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      // ❌ 에러 응답 처리
      print('❌ API 요청 실패: ${e.type}');

      if (e.response != null) {
        try {
          return ApiResponse<TestResultResponse>.fromJson(
            e.response!.data,
                (json) => TestResultResponse.fromJson(json as Map<String, dynamic>),
          );
        } catch (_) {
          return ApiResponse<TestResultResponse>(
            success: false,
            error: ErrorInfo(
              code: 'NETWORK_ERROR',
              message: e.message ?? '네트워크 오류가 발생했습니다',
            ),
          );
        }
      } else {
        return ApiResponse<TestResultResponse>(
          success: false,
          error: ErrorInfo(
            code: 'CONNECTION_ERROR',
            message: '서버에 연결할 수 없습니다',
          ),
        );
      }
    }
  }
}