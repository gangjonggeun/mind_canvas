import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 프로젝트 구조에 맞게 import 경로를 확인해주세요
import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/network/dio_provider.dart'; // Dio 인스턴스 제공자
import '../../../../core/utils/result.dart';
import '../../data/data_source/therapy_data_source.dart';
import '../../domain/repository/therapy_repository.dart';
import '../dto/anger_vent_request.dart';
import '../dto/anger_vent_response.dart';
import '../dto/journal_response.dart';
import '../dto/journal_submit_request.dart';
import '../dto/therapy_chat_request.dart';
import '../dto/therapy_chat_response.dart';

part 'therapy_repository_impl.g.dart';
// ==========================================================
// 2️⃣ Riverpod Provider
// ==========================================================
@riverpod
TherapyRepository therapyRepository(TherapyRepositoryRef ref) {
  // 위에서 만든 dataSourceProvider를 watch
  final dataSource = ref.watch(therapyDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);

  return TherapyRepositoryImpl(dataSource, tokenManager);
}

// ==========================================================
// 3️⃣ Repository Implementation (Data Layer)
// ==========================================================
class TherapyRepositoryImpl implements TherapyRepository {
  final TherapyDataSource _dataSource;
  final TokenManager _tokenManager;

  TherapyRepositoryImpl(this._dataSource, this._tokenManager);

  // 👇 [신규 추가] AI 화풀기 메시지 전송 구현
  @override
  Future<Result<AngerVentResponse>> sendAngerVentMessage({
    required String message,
    required List<ChatHistory> history,
  }) async {
    try {
      // 1. 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      // 2. 요청 DTO 생성 (AngerVentRequest)
      final requestBody = AngerVentRequest(
        message: message,
        history: history,
      );

      // 3. API 호출
      // DataSource에 새로 추가한 sendAngerVentMessage 호출
      final apiResponse = await _dataSource.sendAngerVentMessage(
        validToken,
        requestBody,
      );

      // 4. 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        final errorMessage = apiResponse.message ?? '답변을 받아오지 못했습니다.';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';
        return Result.failure(errorMessage, errorCode);
      }

    } on DioException catch (e) {
      return _handleDioException(e); // 기존 에러 핸들러 재사용
    } catch (e) {
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }

  @override
  Future<Result<TherapyChatResponse>> sendChatMessage({
    required String message,
    required List<ChatHistory> history,
  }) async {
    try {
      // 1. 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      // 2. 요청 DTO 생성
      final requestBody = TherapyChatRequest(
        message: message,
        history: history,
      );

      // 3. API 호출
      // Retrofit DataSource 메서드 호출 (Authorization 헤더에 Bearer 토큰 주입)
      final apiResponse = await _dataSource.sendChatMessage(
        validToken,
        requestBody,
      );

      // 4. 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        // 서버 비즈니스 로직 에러
        final errorMessage = apiResponse.message ?? '답변을 생성하지 못했습니다.';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';
        return Result.failure(errorMessage, errorCode);
      }

    } on DioException catch (e) {
      // 5. Dio 에러 핸들링 (기존 코드와 통일성 유지)
      return _handleDioException(e);

    } catch (e) {
      // 6. 그 외 예상치 못한 에러
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }


  // 👇 [신규 추가] 감정 일기 작성 구현
  @override
  Future<Result<JournalResponse>> createJournal({
    required String date,
    required String content,
  }) async {
    try {
      // 1. 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      // 2. 요청 DTO 생성
      final requestBody = JournalSubmitRequest(
        date: date,
        content: content,
      );

      // 3. API 호출
      final apiResponse = await _dataSource.createJournal(
        validToken,
        requestBody,
      );

      // 4. 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        final errorMessage = apiResponse.message ?? '일기를 저장하지 못했습니다.';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';
        return Result.failure(errorMessage, errorCode);
      }

    } on DioException catch (e) {
      return _handleDioException(e); // 기존 에러 핸들러 재사용
    } catch (e) {
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }

  /// 🛠️ 공통 DioException 핸들러
  Result<T> _handleDioException<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Result.failure('서버 연결 시간이 초과되었습니다. 네트워크를 확인해주세요.', 'TIMEOUT');
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 401:
          return Result.failure('인증이 만료되었습니다. 다시 로그인해주세요.', 'AUTHENTICATION_EXPIRED');
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