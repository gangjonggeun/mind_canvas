import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 프로젝트 구조에 맞게 import 경로 확인
import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/utils/result.dart';
import '../../data/dto/content_rec_request.dart';
import '../../data/dto/content_rec_response.dart';
import '../../domain/enums/rec_category.dart';
import '../../domain/repository/recommendation_repository.dart';
import '../data_source/recommendation_data_source.dart';
import 'dart:convert'; // jsonEncode, jsonDecode용
import 'package:hive/hive.dart';

part 'recommendation_repository_impl.g.dart';

// ==========================================================
// ⚡ Riverpod Provider
// ==========================================================
@riverpod
RecommendationRepository recommendationRepository(RecommendationRepositoryRef ref) {
  final dataSource = ref.watch(recommendationDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);

  return RecommendationRepositoryImpl(dataSource, tokenManager);
}

// ==========================================================
// 🛠️ Repository Implementation
// ==========================================================
class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationDataSource _dataSource;
  final TokenManager _tokenManager;

  // 📦 Hive Box 이름 상수
  static const String _boxName = 'recommendation_cache';
  static const String _cacheKey = 'latest_rec_data';

  RecommendationRepositoryImpl(this._dataSource, this._tokenManager);
  @override
  Future<Result<ContentRecResponse>> recommendContent({
    required List<RecCategory> categories,
    String? userMood,
    bool forceRefresh = false,
  }) async {
    print('🚀 [Repo] 추천 요청 시작: forceRefresh=$forceRefresh'); // 1. 진입 로그

    try {
      // ✅ [안전 장치] 박스가 안 열려있으면 엶
      if (!Hive.isBoxOpen(_boxName)) {
        print('📦 [Repo] Hive 박스 오픈 시도: $_boxName');
        await Hive.openBox<String>(_boxName);
      }
      final box = Hive.box<String>(_boxName);

      // 1️⃣ [캐시 확인]
      if (!forceRefresh && box.containsKey(_cacheKey)) {
        print('📦 [Repo] 캐시 발견! 데이터 로드 시도');
        final cachedJsonString = box.get(_cacheKey);

        if (cachedJsonString != null) {
          try {
            final jsonMap = jsonDecode(cachedJsonString);
            final cachedResponse = ContentRecResponse.fromJson(jsonMap);
            print('✅ [Repo] 캐시 로드 성공');
            return Result.success(cachedResponse);
          } catch (e) {
            print('⚠️ [Repo] 캐시 파싱 실패 (데이터 구조 변경됨?): $e');
            // 파싱 실패하면 그냥 API 호출하러 내려감 (캐시 무시)
          }
        }
      }

      // 2️⃣ [서버 요청]
      print('🌐 [Repo] API 호출 준비...');
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('❌ [Repo] 토큰 없음');
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      final requestBody = ContentRecRequest(
        categories: categories,
        userMood: userMood,
      );

      print('📡 [Repo] API 요청 전송: /api/v1/recommendation/content');
      final apiResponse = await _dataSource.recommendContent(
        validToken, // Bearer는 DataSource나 TokenManager에서 처리한다고 가정
        requestBody,
      );

      // 3️⃣ [결과 처리]
      if (apiResponse.success && apiResponse.data != null) {
        print('✅ [Repo] API 성공: ${apiResponse.data!.results.length}개 그룹 수신');
        final responseData = apiResponse.data!;

        // 저장
        await box.put(_cacheKey, jsonEncode(responseData.toJson()));
        print('💾 [Repo] Hive 캐시 저장 완료');

        return Result.success(responseData);
      } else {
        print('❌ [Repo] API 실패 응답: ${apiResponse.message}');
        return Result.failure(apiResponse.message ?? '실패', apiResponse.error?.code);
      }

    } on DioException catch (e) {
      print('🔥 [Repo] Dio 에러: ${e.message}, ${e.response?.statusCode}'); // 에러 로그
      return _handleDioException(e);
    } catch (e, stack) {
      print('💀 [Repo] 알 수 없는 에러: $e');
      print(stack); // 스택 트레이스 출력
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }

  /// 🛠️ 공통 DioException 핸들러 (기존 코드와 동일하게 유지)
  Result<T> _handleDioException<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Result.failure('서버 연결 시간이 초과되었습니다. 네트워크를 확인해주세요.', 'TIMEOUT');
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;

      // 코인 부족 예외 처리 (서버가 402 혹은 특정 에러 코드를 줄 때)
      // 만약 서버 ErrorCode가 "NOT_ENOUGH_COINS"라면 여기서 캐치 가능
      // 여기서는 일반적인 HTTP 상태 코드 처리
      switch (statusCode) {
        case 401:
          return Result.failure('인증이 만료되었습니다. 다시 로그인해주세요.', 'AUTHENTICATION_EXPIRED');
        case 402: // Payment Required (코인 부족 시 주로 사용)
          return Result.failure('코인이 부족합니다.', 'NOT_ENOUGH_COINS');
        case 403:
          return Result.failure('접근 권한이 없습니다.', 'FORBIDDEN');
        case 404:
          return Result.failure('요청한 서비스를 찾을 수 없습니다.', 'NOT_FOUND');
        case 500:
          return Result.failure('서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', 'SERVER_ERROR');
        default:
          return Result.failure('서버 통신 중 오류가 발생했습니다. ($statusCode)', 'HTTP_ERROR');
      }
    }

    if (e.error.toString().contains('SocketException')) {
      return Result.failure('인터넷 연결을 확인해주세요.', 'NETWORK_DISCONNECTED');
    }

    return Result.failure('네트워크 오류가 발생했습니다.', 'NETWORK_ERROR');
  }
}