import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';

import '../../data/models/request/auth_request_dto.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/auth_usecase_provider.dart';
part 'auth_provider.g.dart';

/// 🔐 인증 상태 관리 Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {

  late final AuthUseCase _authUseCase;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  Future<AuthUser?> build() async {
    // 초기 상태: 저장된 사용자 정보 확인
    _authUseCase = ref.read(authUseCaseProvider);
    return null;
  }

  /// 🍎 Apple 로그인
  Future<Result<AuthUser>> appleLogin({
    required String identityToken,
    required String authorizationCode,
  }) async {
    state = const AsyncLoading();

    try {
      final loginRequest = AppleLoginRequest(
        idToken: identityToken
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
  Future<Result<AuthUser>> googleLogin() async { // ✨ 파라미터 제거
    state = const AsyncLoading();

    try {
      // 1. Google 로그인 실행 및 인증 정보 가져오기
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = AsyncData(state.valueOrNull); // 취소 시 이전 상태로 복귀
        return Results.failure('Google 로그인이 취소되었습니다.');
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        state = AsyncData(state.valueOrNull);
        return Results.failure('Google ID 토큰을 가져오지 못했습니다.');
      }

      // 2. [변경점] UseCase 호출!
      // 이제 서버 통신을 포함한 모든 복잡한 로직은 UseCase가 담당합니다.
      final result = await _authUseCase.loginWithGoogle(
        // 실제 토큰 전달 (향후 UseCase에서 사용)
      );

      // 3. UseCase의 결과에 따라 상태 업데이트
      result.when(
        success: (user) {
          state = AsyncData(user);
          // 로컬에 사용자 정보 저장
          _saveUserToLocal(user);
        },
        failure: (message, code) {
          state = AsyncError(message, StackTrace.current);
        },
        loading: () {
          // UseCase에서 로딩 상태를 처리하지 않으므로 이 부분은 거의 호출되지 않음
        },
      );

      return result;

    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return Results.failure(error.toString());
    }
  }

  Future<void> _saveUserToLocal(AuthUser user) async {
    try {
      // SharedPreferences나 Hive에 사용자 정보 저장
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('auth_user', jsonEncode(user.toJson()));
    } catch (e) {
      print('Failed to save user to local storage: $e');
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