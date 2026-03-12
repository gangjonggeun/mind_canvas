import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:mind_canvas/features/auth/domain/enums/login_type.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/utils/result.dart';

import '../../../../core/network/api_response_dto.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_data_source.dart';
import '../models/request/auth_request_dto.dart';
import '../models/response/auth_response_dto.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // ✅ import 필수

/// 🔑 인증 Repository 구현체 (업데이트)
///
/// 새로운 구조에 맞춰 수정:
/// - ApiResponse<T> 래핑 처리
/// - TokenManager 연동
/// - AuthStorage 연동
/// - 서버 API 구조와 매칭
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _dataSource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._dataSource, this._tokenManager);


  @override
  Future<Result<void>> deleteAccount() async {
    try {
      // 1. 보안 저장소에서 액세스 토큰 가져오기
      final token = await _tokenManager.getValidAccessToken();

      if (token == null) {
        print("액세스토큰 가져오기 실패");
        return Results.failure('auth 레포 deleteAccount 액세스토큰 가져오기 실패');
      }
      // 2. API 호출 (Bearer는 안 붙여도 인터셉터가 처리함)
      final response = await _dataSource.deleteAccount(token!);

      // 3. 응답 처리
      if (response.success) {
        return Results.success(null);
      } else {
        return Results.failure(response.error?.message ?? '계정 탈퇴 실패');
      }
    } on DioException catch (e) {
      print('❌ 계정 탈퇴 API 통신 에러: $e');
      return Results.failure('서버와의 통신에 실패했습니다.');
    } catch (e) {
      print('❌ 계정 탈퇴 처리 중 알 수 없는 에러: $e');
      return Results.failure('계정 탈퇴 중 오류가 발생했습니다.');
    }
  }

  // =============================================================
  // 🔐 로그인 메서드들
  // =============================================================
  /// 🔄 FCM 토큰 동기화 함수
  @override
  Future<void> syncFcmToken() async {
    print("🚀 [FCM] syncFcmToken 함수 호출됨!");

    try {
      // 1️⃣ Firebase 서버로부터 내 폰의 FCM 토큰을 받아옵니다.
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        print("⚠️ FCM 토큰을 가져오지 못했습니다.");
        return;
      }
      print("🔥 내 폰의 FCM Token: $fcmToken");

      // 2️⃣ 내 앱에 저장된 JWT Access Token(로그인 토큰)을 가져옵니다
      final accessToken = await _tokenManager.getValidAccessToken();

      if (accessToken == null) {
        print("⚠️ 로그인이 되어있지 않아 서버에 전송하지 않습니다.");
        return;
      }

      print("🚀 [FCM] 서버로 토큰 전송 시도: $fcmToken");
      // 3️⃣ 서버로 전송 (헤더에 JWT, 바디에 FCM 토큰)
      // "Bearer " 접두사는 TokenManager에서 붙여주거나 여기서 붙여야 함 (서버 설정에 따라)
      await _dataSource.updateFcmToken(
        accessToken, // 👈 헤더로 들어감
        {'token': fcmToken}, // 👈 바디로 들어감
      );

      print("✅ 서버에 FCM 토큰 저장 완료!");

    } catch (e) {
      print("❌ 토큰 동기화 실패: $e");
      // 이 에러는 사용자에게 팝업을 띄울 필요까진 없음 (백그라운드 작업이라)
    }
  }

  @override
  Future<Result<AuthResponse>> loginWithGoogle(
    String idToken, {
    String? deviceId,
    String? fcmToken,
  }) async {
    return _safeApiCall(() async {
      final request = GoogleLoginRequest(
        idToken: idToken,
        deviceId: deviceId,
        fcmToken: fcmToken,
      );

      // API 호출 - ApiResponse<AuthResponse> 반환
      final apiResponse = await _dataSource.loginWithGoogle(request);

      // ApiResponse 성공 체크
      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;

        // TokenManager에 저장
        await _tokenManager.saveAuthResponse(authResponse);

        return authResponse;
      } else {
        // 서버에서 실패 응답
        final errorMessage = apiResponse.errorMessage ?? 'Google 로그인에 실패했습니다';
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/google'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/google'),
            statusCode: 400,
            data: {'error_description': errorMessage},
          ),
        );
      }
    });
  }
  @override
  Future<Result<AuthResponse>> loginWithApple(
      String identityToken, {
        String? deviceId, // ✨ 추가
        String? fcmToken,
      }) async {
    return _safeApiCall(() async {
      // 1. 요청 객체 생성
      final request = AppleLoginRequest(
        identityToken: identityToken,
        fcmToken: fcmToken,
      );

      // 2. API 호출
      final apiResponse = await _dataSource.loginWithApple(request);

      // 3. 성공 시 토큰 저장
      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;
        await _tokenManager.saveAuthResponse(authResponse);
        return authResponse;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/apple'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/apple'),
            statusCode: 400,
            data: {'error_description': apiResponse.errorMessage ?? 'Apple 로그인에 실패했습니다'},
          ),
        );
      }
    });
  }

  /**
   *  자동로그인에서 사용 해당 리프레시 토큰 토큰매니져에서 가져오고 바디로
   *  감싸서 보냄 (rtt 방식 )
   *
   * */
  @override
  Future<Result<AuthResponse>> refreshTokens() async {
    return _safeApiCall(() async {
      // 현재 저장된 refresh token 가져오기
      final currentAuth = _tokenManager.currentAuth;
      if (currentAuth?.refreshToken == null) {
        throw Exception('Refresh Token이 없습니다');
      }

      // RefreshTokenRequest 객체 생성
      final request = RefreshTokenRequest(
        refreshToken: currentAuth!.refreshToken,
        deviceId: await _getDeviceId(), // 선택사항: 디바이스 ID 추가
      );

      // API 호출 (Body 방식)
      final apiResponse = await _dataSource.refreshTokens(request);

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;

        // 새로운 토큰으로 업데이트
        await _tokenManager.saveAuthResponse(authResponse);

        return authResponse;
      } else {
        final errorMessage = apiResponse.errorMessage ?? '토큰 갱신에 실패했습니다';
        throw Exception(errorMessage);
      }
    });
  }

  /**
   * 디바이스 가져오는 라이브러리 버전 맞춘 후 작업
   *
   * */
  Future<String?> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // 안드로이드 고유 ID
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // iOS 벤더 고유 식별자
      }
      return 'unknown_device';
    } catch (e) {
      print('디바이스 ID 추출 실패: $e');
      return null;
    }
  }


  @override
  Future<Result<void>> logout({bool logoutFromAllDevices = false}) async {
    return _safeApiCall(() async {
      try {
        final authHeader = _tokenManager.authorizationHeader;
        if (authHeader != null) {
          // 💡 validateStatus를 추가하여 500 에러가 나도 DioException을 던지지 않게 방어
          await _dataSource.logout(authHeader);
        }
      } catch (e) {
        print('⚠️ 서버 로그아웃 실패했으나 로컬 데이터 삭제 진행');
      }

      await _tokenManager.clearTokens();
    });
  }

  // =============================================================
  // 🔍 상태 확인 메서드들
  // =============================================================

  @override
  Future<bool> isLoggedIn() async {
    return _tokenManager.isLoggedIn;
  }

  @override
  Future<Result<AuthUser?>> getCurrentUser() async {
    return _safeApiCall(() async {
      // 1. 헤더에 넣을 토큰 가져오기
      final authHeader = _tokenManager.authorizationHeader;

      // 토큰 자체가 없으면 서버 찌를 필요도 없이 비로그인 상태
      if (authHeader == null) return null;

      // 2. 서버에 '나 아직 정상 유저야? 내 최신 정보 줘!' 요청
      final apiResponse = await _dataSource.getCurrentUser(authHeader);

      // 3. 응답 처리
      if (apiResponse.isSuccess && apiResponse.hasData) {
        final userData = apiResponse.data!;

        // ✨ 4. 혹시 다른 기기에서 닉네임 등을 바꿨을 수 있으니 로컬 캐시(TokenManager)도 업데이트
        final currentAuth = _tokenManager.currentAuth;
        if (currentAuth != null) {
          final updatedAuth = currentAuth.copyWith(
            nickname: userData.nickname,
            // 서버 Enum 값으로 동기화
          );
          await _tokenManager.saveAuthResponse(updatedAuth);
        }

        // 5. AuthUser 반환 (이 값으로 앱 전체 UI가 그려짐)
        return AuthUser(
          userId: userData.userId,
          nickname: userData.nickname,
          loginType: userData.loginType,
        );
      } else {
        // 토큰은 있는데 서버가 거절함 (탈퇴, 정지, 서버 강제 로그아웃 등)
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 401,
            data: {'message': apiResponse.errorMessage ?? '유효하지 않은 사용자'},
          ),
        );
      }
    });
  }

  @override
  Future<Result<void>> validateToken() async {
    try {
      // 1. 토큰 확인
      final authHeader = _tokenManager.authorizationHeader;
      if (authHeader == null) {
        return Result.failure('저장된 토큰이 없습니다', 'NO_TOKEN');
      }

      // 2. API 호출
      final apiResponse = await _dataSource.validateToken(authHeader);

      // 3. ApiResponse → Result 변환
      if (apiResponse.isSuccess && apiResponse.hasData) {
        return Result.success(null, '토큰이 유효합니다'); // ✅ void니까 null
      } else {
        return Result.failure(
          apiResponse.errorMessage ?? '토큰 검증 실패',
          apiResponse.errorCode ?? 'VALIDATION_FAILED',
        );
      }
    } catch (e) {
      print('❌ 토큰 검증 중 오류: $e');
      return Result.failure('토큰 검증 중 오류가 발생했습니다', 'VALIDATION_ERROR');
    }
  }

  // =============================================================
  // 🔧 토큰 관리 메서드들
  // =============================================================

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
    required int userId
  }) async {
    // TokenManager를 통해 저장
    final authResponse = AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );
    await _tokenManager.saveAuthResponse(authResponse);
  }

  @override
  Future<void> clearAuthTokens() async {
    await _tokenManager.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return await _tokenManager.getValidAccessToken();
  }

  @override
  Future<bool> isTokenExpired() async {
    // 💡 isTokenExpired 대신 isAccessTokenExpired 로 이름 변경
    return _tokenManager.isAccessTokenExpired;
  }

  @override
  Future<Result<AuthResponse>> loginAsGuest(   String languageCode, {
    String? deviceId, // ✨ 추가
    String? fcmToken,
  }) async {
    return _safeApiCall(() async {
      // 1. 디바이스 ID 추출 (필수)
      final deviceId = await _getDeviceId();
      if (deviceId == null) {
        throw Exception("기기 식별자를 가져올 수 없어 게스트 로그인이 불가능합니다.");
      }

      // 2. 요청 객체 생성
      final request = GuestLoginRequest(
        deviceId: deviceId,
        fcmToken: fcmToken,
        language: languageCode, // 예: 'ko'
      );

      // 3. API 호출
      final apiResponse = await _dataSource.loginAsGuest(request);

      // 4. 성공 시 토큰 저장
      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;
        await _tokenManager.saveAuthResponse(authResponse);
        return authResponse;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/guest'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/guest'),
            statusCode: 400,
            data: {'error_description': apiResponse.errorMessage ?? '게스트 로그인에 실패했습니다'},
          ),
        );
      }
    });
  }

  // =============================================================
  // 🛡️ 안전한 API 호출 래퍼
  // =============================================================

  /// API 호출을 안전하게 감싸는 공통 메서드 (업데이트)
  Future<Result<T>> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Results.success(result);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Results.failure('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  /// DioException 상세 처리
  Result<T> _handleDioException<T>(DioException e) {
    // 서버에서 ApiResponse 형태로 에러를 보낸 경우
    if (e.response?.data is Map<String, dynamic>) {
      final responseData = e.response!.data as Map<String, dynamic>;

      // ApiResponse 형태의 에러
      if (responseData.containsKey('error')) {
        final error = responseData['error'] as Map<String, dynamic>?;
        final errorMessage =
            error?['message'] ?? responseData['message'] ?? '서버 오류가 발생했습니다';
        final errorCode = error?['code'] ?? e.response?.statusCode?.toString();

        return Results.failure(errorMessage, errorCode);
      }
    }

    // 기본 HTTP 상태 코드별 처리
    switch (e.response?.statusCode) {
      case 401:
        return Results.failure('인증이 필요합니다', '401');
      case 403:
        return Results.failure('접근 권한이 없습니다', '403');
      case 404:
        return Results.failure('요청한 리소스를 찾을 수 없습니다', '404');
      case 500:
        return Results.failure('서버 내부 오류가 발생했습니다', '500');
      default:
        final errorMessage = e.message ?? '네트워크 오류가 발생했습니다';
        return Results.failure(
          errorMessage,
          e.response?.statusCode?.toString(),
        );
    }
  }
}
