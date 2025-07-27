import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';

import '../../data/models/request/auth_request_dto.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'auth_provider.g.dart';

/// 🔐 인증 상태 관리 Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthUser?> build() async {
    // 초기 상태: 저장된 사용자 정보 확인
    return await _checkStoredUser();
  }

  /// 🍎 Apple 로그인
  Future<Result<AuthUser>> appleLogin({
    required String identityToken,
    required String authorizationCode,
  }) async {
    state = const AsyncLoading();

    try {
      final loginRequest = AppleLoginRequest(
        identityToken: identityToken,
        authorizationCode: authorizationCode,
      );

      // UseCase 호출 (향후 구현)
      await Future.delayed(const Duration(seconds: 1));

      final mockUser = AuthUser(
        id: 'apple_user_123',
        email: 'user@icloud.com',
        nickname: null,                    // 닉네임 설정 다이얼로그 필요
        profileImageUrl: null,             // Apple에서 제공하지 않을 수 있음
        authProvider: AuthProvider.apple,
        isEmailVerified: true,             // Apple 인증됨
        isProfileComplete: false,          // 닉네임 설정 필요
      );

      state = AsyncData(mockUser);
      return Results.success(mockUser);

    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return Results.failure(error.toString());
    }
  }

  /// 🌐 Google 로그인
  Future<Result<AuthUser>> googleLogin({
    required String idToken,
    required String accessToken,
  }) async {
    state = const AsyncLoading();

    try {
      final loginRequest = GoogleLoginRequest(
        idToken: idToken,
        accessToken: accessToken,
      );

      // UseCase 호출 (향후 구현)
      await Future.delayed(const Duration(seconds: 1));

      final mockUser = AuthUser(
        id: 'google_user_123',
        email: 'user@gmail.com',
        nickname: null,                    // 닉네임 설정 다이얼로그 필요
        profileImageUrl: 'https://lh3.googleusercontent.com/example', // Google 프로필 이미지
        authProvider: AuthProvider.google,
        isEmailVerified: true,             // Google 인증됨
        isProfileComplete: false,          // 닉네임 설정 필요
      );

      state = AsyncData(mockUser);
      return Results.success(mockUser);

    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return Results.failure(error.toString());
    }
  }

  /// 👤 익명 로그인
  Future<Result<AuthUser>> anonymousLogin() async {
    state = const AsyncLoading();

    try {
      // UseCase 호출 (향후 구현)
      await Future.delayed(const Duration(milliseconds: 500));

      final mockUser = AuthUser(
        id: 'anon_${DateTime.now().millisecondsSinceEpoch}', // 임시 ID
        email: null,                       // 익명은 이메일 없음
        nickname: null,                    // 닉네임 설정 다이얼로그 필요
        profileImageUrl: null,             // 기본 아바타 사용
        authProvider: AuthProvider.anonymous,
        isEmailVerified: true,             // 의미없지만 true
        isProfileComplete: false,          // 닉네임 설정 필요
      );

      state = AsyncData(mockUser);
      return Results.success(mockUser);

    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return Results.failure(error.toString());
    }
  }

  /// 📝 닉네임 설정 (로그인 플로우 완성)
  Future<Result<AuthUser>> setNickname(String nickname) async {
    final currentUser = state.value;
    if (currentUser == null) {
      return Results.failure('로그인이 필요합니다');
    }

    try {
      // UseCase 호출 (향후 구현)
      await Future.delayed(const Duration(milliseconds: 800));

      final updatedUser = currentUser.copyWith(
        nickname: nickname,
        isProfileComplete: true,         // 프로필 설정 완료
      );

      state = AsyncData(updatedUser);
      return Results.success(updatedUser);

    } catch (error) {
      return Results.failure('닉네임 설정에 실패했습니다: ${error.toString()}');
    }
  }

  /// 🚪 로그아웃
  Future<Result<void>> logout() async {
    try {
      // 로컬 스토리지 정리
      await _clearStoredUser();

      // 상태 초기화
      state = const AsyncData(null);

      return Results.success(null);
    } catch (error) {
      return Results.failure(error.toString());
    }
  }

  /// 🔄 토큰 갱신
  Future<Result<void>> refreshToken() async {
    try {
      // 저장된 refresh token으로 갱신 (향후 구현)
      await Future.delayed(const Duration(milliseconds: 500));
      return Results.success(null);
    } catch (error) {
      return Results.failure(error.toString());
    }
  }

  /// 💾 저장된 사용자 확인 (로컬 스토리지)
  Future<AuthUser?> _checkStoredUser() async {
    try {
      // SharedPreferences나 Hive에서 사용자 정보 확인
      await Future.delayed(const Duration(milliseconds: 500));

      // 임시로 null 반환 (로그인되지 않은 상태)
      return null;

      // 실제 구현 예시:
      // final prefs = await SharedPreferences.getInstance();
      // final userJson = prefs.getString('auth_user');
      // if (userJson != null) {
      //   return AuthUser.fromJson(jsonDecode(userJson));
      // }
      // return null;
    } catch (error) {
      return null;
    }
  }

  /// 🗑️ 저장된 사용자 정보 삭제
  Future<void> _clearStoredUser() async {
    try {
      // SharedPreferences나 Hive에서 사용자 정보 삭제
      await Future.delayed(const Duration(milliseconds: 200));

      // 실제 구현 예시:
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove('auth_user');
      // await prefs.remove('access_token');
      // await prefs.remove('refresh_token');
    } catch (error) {
      // 로깅만 하고 에러는 무시
      print('Error clearing stored user: $error');
    }
  }
}

/// 🎯 인증 상태 확인 Providers
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (user) => user != null) ?? false;
}

@riverpod
AuthUser? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull<AuthUser?>(
    data: (user) => user,
  );
}


@riverpod
bool isLoading(IsLoadingRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isLoading;
}

@riverpod
bool needsNickname(NeedsNicknameRef ref) {
  final user = ref.watch(currentUserProvider);
  return user != null && user.needsNickname;
}

@riverpod
bool isAnonymousUser(IsAnonymousUserRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAnonymous ?? false;
}

@riverpod
bool isSocialUser(IsSocialUserRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isSocialLogin ?? false;
}