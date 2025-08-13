// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../../../../core/network/api_response_dto.dart';
// import '../../../../core/network/dio_provider.dart';
// import '../../../../core/utils/result.dart';
// import '../models/response/auth_response_dto.dart';
//
// part 'auth_service.g.dart';
//
// @riverpod
// AuthService authService(AuthServiceRef ref) {
//   final dio = ref.read(dioProvider);
//   return AuthService(dio);
// }
//
// class AuthService {
//   final Dio _dio;
//
//   AuthService(this._dio);
//
//   /// 🔐 토큰 유효성 검증 (서버 API 호출)
//   Future<Result<bool>> validateToken() async {
//     try {
//       final response = await _dio.post('/auth/validate-token');
//
//       final apiResponse = ApiResponse<bool>.fromJson(
//         response.data,
//             (json) => json as bool,
//       );
//
//       if (apiResponse.isSuccess && apiResponse.hasData) {
//         return Result.success(apiResponse.data!);
//       } else {
//         return Result.failure(
//           apiResponse.errorMessage ?? '토큰 검증 실패',
//           apiResponse.errorCode,
//         );
//       }
//     } on DioException catch (e) {
//       print('❌ 토큰 검증 API 오류: ${e.message}');
//
//       // 네트워크 오류별 세분화된 처리
//       return switch (e.type) {
//         DioExceptionType.connectionTimeout =>
//             Result.failure('서버 연결 시간 초과', 'CONNECTION_TIMEOUT'),
//         DioExceptionType.receiveTimeout =>
//             Result.failure('응답 수신 시간 초과', 'RECEIVE_TIMEOUT'),
//         DioExceptionType.badResponse when e.response?.statusCode == 401 =>
//             Result.failure('토큰이 만료되었습니다', 'TOKEN_EXPIRED'),
//         DioExceptionType.badResponse when e.response?.statusCode == 403 =>
//             Result.failure('토큰이 유효하지 않습니다', 'TOKEN_INVALID'),
//         _ => Result.failure('토큰 검증 중 오류가 발생했습니다', 'VALIDATION_ERROR'),
//       };
//     } catch (e) {
//       print('❌ 예상치 못한 토큰 검증 오류: $e');
//       return Result.failure('예상치 못한 오류가 발생했습니다', 'UNEXPECTED_ERROR');
//     }
//   }
//
//   /// 🚪 로그인
//   Future<Result<AuthResponse>> login(LoginRequest request) async {
//     try {
//       final response = await _dio.post('/auth/login', data: request.toJson());
//
//       final apiResponse = AuthApiResponse.fromJson(
//         response.data,
//             (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
//       );
//
//       if (apiResponse.isSuccess && apiResponse.hasData) {
//         return Result.success(apiResponse.data!);
//       } else {
//         return Result.failure(
//           apiResponse.errorMessage ?? '로그인 실패',
//           apiResponse.errorCode,
//         );
//       }
//     } on DioException catch (e) {
//       return _handleAuthError(e, '로그인');
//     } catch (e) {
//       return Result.failure('로그인 중 예상치 못한 오류', 'LOGIN_ERROR');
//     }
//   }
//
//   /// 🔄 토큰 갱신
//   Future<Result<AuthResponse>> refreshToken(String refreshToken) async {
//     try {
//       final response = await _dio.post('/auth/refresh', data: {
//         'refreshToken': refreshToken,
//       });
//
//       final apiResponse = AuthApiResponse.fromJson(
//         response.data,
//             (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
//       );
//
//       if (apiResponse.isSuccess && apiResponse.hasData) {
//         return Result.success(apiResponse.data!);
//       } else {
//         return Result.failure(
//           apiResponse.errorMessage ?? '토큰 갱신 실패',
//           apiResponse.errorCode,
//         );
//       }
//     } on DioException catch (e) {
//       return _handleAuthError(e, '토큰 갱신');
//     } catch (e) {
//       return Result.failure('토큰 갱신 중 예상치 못한 오류', 'REFRESH_ERROR');
//     }
//   }
//
//   /// 🚪 로그아웃
//   Future<Result<String>> logout() async {
//     try {
//       final response = await _dio.post('/auth/logout');
//
//       final apiResponse = ApiResponse<String>.fromJson(
//         response.data,
//             (json) => json as String,
//       );
//
//       if (apiResponse.isSuccess) {
//         return Result.success(
//           apiResponse.data ?? '로그아웃 완료',
//           apiResponse.message,
//         );
//       } else {
//         return Result.failure(
//           apiResponse.errorMessage ?? '로그아웃 실패',
//           apiResponse.errorCode,
//         );
//       }
//     } on DioException catch (e) {
//       return _handleAuthError(e, '로그아웃');
//     } catch (e) {
//       return Result.failure('로그아웃 중 예상치 못한 오류', 'LOGOUT_ERROR');
//     }
//   }
//
//   /// 🚨 인증 에러 공통 처리
//   Result<T> _handleAuthError<T>(DioException e, String operation) {
//     final statusCode = e.response?.statusCode;
//     final message = e.response?.data?['message'] ?? e.message;
//
//     return switch (statusCode) {
//       400 => Result.failure('잘못된 요청입니다', 'BAD_REQUEST'),
//       401 => Result.failure('인증이 필요합니다', 'UNAUTHORIZED'),
//       403 => Result.failure('접근이 거부되었습니다', 'FORBIDDEN'),
//       404 => Result.failure('요청한 리소스를 찾을 수 없습니다', 'NOT_FOUND'),
//       409 => Result.failure('이미 존재하는 데이터입니다', 'CONFLICT'),
//       500 => Result.failure('서버 내부 오류입니다', 'INTERNAL_SERVER_ERROR'),
//       _ => Result.failure('$operation 중 오류가 발생했습니다: $message', 'NETWORK_ERROR'),
//     };
//   }
// }