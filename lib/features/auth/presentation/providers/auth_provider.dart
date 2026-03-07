import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mind_canvas/core/services/google/google_oauth_result.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../../../core/auth/auth_storage.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/providers/app_language_provider.dart';
import '../../../../core/providers/google_oauth_provider.dart';
import '../../../profile/domain/usecases/profile_usecase_provider.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/enums/login_type.dart';
import '../../domain/repositories/auth_repository_provider.dart';
import '../../domain/usecases/auth_usecase_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  // ✨ 3. GoogleSignIn 직접 의존성 완전 제거!
  // final GoogleSignIn _googleSignIn = GoogleSignIn(); // <- 이 줄을 과감하게 삭제합니다.

  @override
  Future<AuthUser?> build() async {
    await ref.read(tokenManagerProvider).initFromStorage();

    final authUseCase = ref.read(authUseCaseProvider);

    // 1. 토큰이 없으면 명확하게 null 반환
    final hasLocalToken = await authUseCase.isLoggedIn();
    if (!hasLocalToken) return null;


    if (hasLocalToken) {
      // 🚨 [핵심 보안] 토큰이 있다고 바로 통과시키지 않습니다.
      // 무조건 서버에 '현재 유저 정보(getCurrentUser)'를 요청하여 검증받아야 합니다.
      final userResult = await authUseCase.getCurrentUser()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return Result.failure("서버 응답 시간 초과", "TIMEOUT");
      });

      print("🧐 [Build] 서버 검증 통신 결과 성공여부: ${userResult.isSuccess}");

      return userResult.fold(
        onSuccess: (user) {
          if (user != null) {
            // 서버 응답이 정상일 때만 FCM 및 프로필 갱신 수행
            Future.microtask(() async {
              ref.read(userNotifierProvider.notifier).refreshProfile();
              await ref.read(authRepositoryProvider).syncFcmToken();
            });
          }
          return user; // 🟢 서버 검증 성공 -> 유저 객체 반환 (홈으로 이동)
        },
        onFailure: (error, code) {
          // 🔴 서버가 꺼져있거나(500 Network Error) 토큰이 만료(401)된 경우
          print("❌ [Build] 서버 검증 실패(서버 다운 또는 토큰 만료): $error");

          // 보안: 로컬 캐시에 찌꺼기가 남지 않게 로그아웃 처리(또는 토큰 클리어)를 강제하는 것이 좋습니다.
          // ref.read(tokenManagerProvider).clearTokens();

          return null; // 무조건 null을 반환하여 강제로 로그인 화면으로 유도
        },
      );
    }

    return null; // 토큰 없음 -> 로그인 화면
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios_id';
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // 안드로이드 고유 ID
    }
    return 'unknown_device_id';
  }

  /// 🌐 Google 로그인 (새로운 서비스와 연결된 최종 버전)
  /// 🌐 Google 로그인
  Future<Result<AuthUser?>> googleLogin() async {
    state = const AsyncLoading();

    final googleOAuthService = ref.read(googleOAuthServiceProvider);
    final googleResult = await googleOAuthService.signIn();

    return await googleResult.when(
      success: (idToken) async {
        final authUseCase = ref.read(authUseCaseProvider);

        // 📱 기기 식별자 가져오기
        final deviceId = await _getDeviceId();
        // FCM 토큰은 여기서 FirebaseMessaging.instance.getToken() 으로 가져오거나, 기존처럼 syncFcmToken()으로 후처리 해도 무방합니다.

        final result = await authUseCase.completeLoginFlow(
          idToken: idToken,
          deviceId: deviceId, // ✨ 주입!
        );

        return result.fold(
          onSuccess: (authResponse) async {
            // 💰 UserNotifier에 데이터 주입
            ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

            // ✨ AuthUser 변환 (userId 포함!)
            final authUser = AuthUser(
              userId: authResponse.userId,
              nickname: authResponse.nickname,
              loginType: LoginType.google,
            );

            // 💳 [핵심] RevenueCat에 유저 로그인 알림! (이전 답변 내용 적용)
            try {
              await Purchases.logIn("user_${authResponse.userId}");
            } catch (e) {
              print("⚠️ RevenueCat 로그인 실패 (무시하고 앱 로그인 진행): $e");
            }

            state = AsyncData(authUser);
            return Results.success(authUser);
          },
          onFailure: (message, code) {
            state = AsyncError(message, StackTrace.current);
            return Results.failure<AuthUser?>(message, code);
          },
        );
      },
      failure: (error) {
        state = AsyncData(state.valueOrNull);
        return Results.failure(error.message);
      },
    );
  }

  /// 🍎 Apple 로그인
  Future<Result<AuthUser?>> appleLogin() async {
    state = const AsyncLoading();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        state = AsyncData(state.valueOrNull);
        return Results.failure('Apple 인증 토큰을 가져오지 못했습니다.');
      }

      final authUseCase = ref.read(authUseCaseProvider);
      final deviceId = await _getDeviceId(); // 📱 기기 정보 수집

      final result = await authUseCase.loginWithApple(
          identityToken: identityToken,
          deviceId: deviceId // ✨ 주입!
      );

      return result.fold(
        onSuccess: (authResponse) async {
          ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

          final authUser = AuthUser(
            userId: authResponse.userId, // ✨ userId 추가
            nickname: authResponse.nickname,
            loginType: LoginType.apple,
          );

          try {
            await Purchases.logIn("user_${authResponse.userId}");
          } catch (e) {
            print("⚠️ RevenueCat 로그인 실패 (무시함): $e");
          }

          state = AsyncData(authUser);
          return Results.success(authUser);
        },
        onFailure: (message, code) {
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (e) {
      state = AsyncData(state.valueOrNull);
      return Results.failure('Apple 로그인 중 오류가 발생했거나 취소되었습니다.');
    }
  }

  /// 👻 Guest 로그인
  Future<Result<AuthUser?>> guestLogin() async {
    state = const AsyncLoading();
    try {
      final languageCode = ref.read(appLanguageProvider);
      final authUseCase = ref.read(authUseCaseProvider);
      final deviceId = await _getDeviceId(); // 📱 기기 정보 수집

      final result = await authUseCase.loginAsGuest(
          languageCode: languageCode,
          deviceId: deviceId // ✨ 주입!
      );

      return result.fold(
        onSuccess: (authResponse) async {
          ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

          final authUser = AuthUser(
            userId: authResponse.userId, // ✨ userId 추가
            nickname: authResponse.nickname,
            loginType: LoginType.guest,
          );

          try {
            await Purchases.logIn("user_${authResponse.userId}");
          } catch (e) {
            print("⚠️ RevenueCat 로그인 실패 (무시함): $e");
          }


          state = AsyncData(authUser);
          return Results.success(authUser);
        },
        onFailure: (message, code) {
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (e) {
      state = AsyncData(state.valueOrNull);
      return Results.failure('게스트 로그인 중 오류가 발생했습니다.');
    }
  }

  /// 📝 프로필 설정 (개선된 버전)
  Future<Result<void>> setupProfile({
    required String nickname,
    required bool isTermsAgreed,
    String? profileImageUrl,
  }) async {
    try {
      // 1. 현재 로그인되어 있는 유저 정보 가져오기
      final currentUser = state.valueOrNull;
      if (currentUser == null) {
        return Result.failure('로그인이 필요합니다');
      }

      print('📝 프로필 설정 시작: nickname=$nickname');

      final profileUseCase = ref.read(profileUseCaseProvider);
      final setupResult = await profileUseCase.setupProfile(
        nickname: nickname,
        isTermsAgreed: true,
        imageFile: null,
      );

      return setupResult.fold(
        onSuccess: (profileResponse) {
          // 2. ✨ 여기가 핵심! 기존 유저 정보에서 닉네임만 싹 바꿔치기 (userId, loginType은 그대로 유지)
          final updatedUser = currentUser.copyWith(
            nickname: profileResponse?.nickname ??
                nickname, // 서버 응답이 없으면 내가 입력한 닉네임 사용
          );

          print("🔍 업데이트된 AuthUser: $updatedUser");

          // 3. 상태 업데이트
          state = AsyncData(updatedUser);

          return Results.success(null);
        },
        onFailure: (message, code) {
          state = AsyncError(message, StackTrace.current);
          return Results.failure<void>(message, code);
        },
      );
    } catch (e) {
      return Result.failure('네트워크 오류가 발생했습니다: $e');
    }
  }

  Future<Result<void>> deleteAccount() async {
    // state = const AsyncLoading(); // 로딩 상태로 변경

    try {
      final authUseCase = ref.read(authUseCaseProvider);
      final googleOAuthService = ref.read(googleOAuthServiceProvider);

      // 1. 우리 서버에 계정 탈퇴(소프트 딜리트) 요청
      final result =
      await authUseCase.deleteAccount(); // 🔥 UseCase에 이 함수가 있어야 합니다!

      return await result.fold(
        onSuccess: (_) async {
          print("✅ 서버 계정 탈퇴 완료");

          // 2. 소셜 로그인(구글) 연동 해제 (기기에 남은 캐시 삭제)
          await googleOAuthService.signOut();

          // 3. UserNotifier (앱 전역 유저 정보) 비우기
          ref.read(userNotifierProvider.notifier).logout();

          // 4. 보안 저장소 캐시 완벽 삭제
          await AuthStorage.clearAll();

          // 5. AuthNotifier 상태 비우기 (UI를 로그인 없는 상태로 그림)
          state = const AsyncData(null);

          return Results.success(null);
        },
        onFailure: (message, code) {
          print("❌ 계정 탈퇴 실패: $message");
          // 실패 시 기존 유저 상태 복구
          state = AsyncData(state.valueOrNull);
          return Results.failure<void>(message, code);
        },
      );
    } catch (e) {
      print("❌ 계정 탈퇴 중 예외 발생: $e");
      state = AsyncData(state.valueOrNull);
      return Results.failure('탈퇴 처리 중 오류가 발생했습니다.');
    }
  }

  /// 🚪 로그아웃
  Future<Result<void>> logout() async {
    print("🔑 [AUTH_NOTIFIER] A. logout() 함수 진입");

    try {
      final authUseCase = ref.read(authUseCaseProvider);
      final googleOAuthService = ref.read(googleOAuthServiceProvider);

      print("🔑 [AUTH_NOTIFIER] B. 서버 및 소셜 로그아웃 시도");
      try {
        await Future.wait([authUseCase.logout(), googleOAuthService.signOut()]);
        print("🔑 [AUTH_NOTIFIER] B-1. 서버/소셜 로그아웃 완료");
      } catch (e) {
        print("🔑[AUTH_NOTIFIER] ⚠️ 서버/구글 로그아웃 에러 (무시): $e");
      }

      print("🔑 [AUTH_NOTIFIER] C. RevenueCat 로그아웃 시도");
      try {
        await Purchases.logOut();
        print("🔑 [AUTH_NOTIFIER] C-1. RevenueCat 로그아웃 완료");
      } catch (e) {
        print("🔑 [AUTH_NOTIFIER] ⚠️ RevenueCat 에러 (무시): $e");
      }

      print("🔑[AUTH_NOTIFIER] D. 로컬 캐시 및 UserNotifier 삭제");
      await AuthStorage.clearAll();
      ref.read(userNotifierProvider.notifier).logout();

      print(
          "🔑 [AUTH_NOTIFIER] E. 🚨 [가장 중요] state를 null로 변경! (이 직후 GoRouter가 낚아챔)");
      state = const AsyncData(null);

      print("🔑 [AUTH_NOTIFIER] F. logout() 정상 종료 완료");
      return Results.success(null);
    } catch (error) {
      print("🔑 [AUTH_NOTIFIER] ❌ 알 수 없는 에러 발생: $error");
      state = const AsyncData(null);
      return Results.failure('로그아웃 처리 중 문제가 발생했습니다.');
    }
  }
}

/// 편의 Provider들 (이 부분은 수정할 필요가 없습니다)
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (user) => user != null) ?? false;
}

@riverpod
AuthUser? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull<AuthUser?>(data: (user) => user);
}
