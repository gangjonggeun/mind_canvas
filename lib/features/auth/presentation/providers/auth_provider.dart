import 'package:mind_canvas/core/services/google/google_oauth_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../../../core/auth/auth_storage.dart';
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
    final authUseCase = ref.read(authUseCaseProvider);

    // 1. 로컬 토큰 유무 확인
    final hasLocalToken = await authUseCase.isLoggedIn();
    print("🧐 [Build] 로컬 토큰 존재 여부: $hasLocalToken");

    if (hasLocalToken) {
      // 🚨 [핵심 보안] 토큰이 있다고 바로 통과시키지 않습니다.
      // 무조건 서버에 '현재 유저 정보(getCurrentUser)'를 요청하여 검증받아야 합니다.
      final userResult = await authUseCase.getCurrentUser();

      print("🧐 [Build] 서버 검증 통신 결과 성공여부: ${userResult.isSuccess}");

      return userResult.fold(
        onSuccess: (user) {
          // 서버 응답이 정상일 때만 FCM 및 프로필 갱신 수행
          Future.microtask(() async {
            ref.read(userNotifierProvider.notifier).refreshProfile();
            await ref.read(authRepositoryProvider).syncFcmToken();
          });
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

  /// 🌐 Google 로그인 (새로운 서비스와 연결된 최종 버전)
  /// 🌐 Google 로그인
  Future<Result<AuthUser?>> googleLogin() async {
    state = const AsyncLoading();

    final googleOAuthService = ref.read(googleOAuthServiceProvider);
    final googleResult = await googleOAuthService.signIn();

    return await googleResult.when(
      success: (idToken) async {
        final authUseCase = ref.read(authUseCaseProvider);
        final result = await authUseCase.completeLoginFlow(idToken: idToken);

        return result.fold(
          onSuccess: (authResponse) {
            print(
                "✅ 서버 로그인 성공! 닉네임: ${authResponse.nickname}, 코인: ${authResponse.coins}");

            // 💰 [핵심 수정 1] UserNotifier에 데이터 주입!
            // 이제 앱 전역(MainScreen 등)에서 코인 정보를 알 수 있게 됩니다.
            ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

            // AuthUser 변환 (기존 로직)
            final authUser = AuthUser(
              nickname: authResponse.nickname,
              loginType: LoginType.google,
            );

            state = AsyncData(authUser);
            return Results.success(authUser);
          },
          onFailure: (message, code) {
            print("❌ 서버 로그인 실패: $message");
            state = AsyncError(message, StackTrace.current);
            return Results.failure<AuthUser?>(message, code);
          },
        );
      },
      failure: (error) {
        print("구글 로그인 실패: $error");
        state = AsyncData(state.valueOrNull);
        return Results.failure(error.message);
      },
    );
  }

  /// 🍎 Apple 로그인 (새로 추가)
  Future<Result<AuthUser?>> appleLogin() async {
    state = const AsyncLoading();

    try {
      // 1. Apple SDK 네이티브 팝업 호출
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;

      if (identityToken == null) {
        state = AsyncData(state.valueOrNull);
        return Results.failure('Apple 인증 토큰을 가져오지 못했습니다.');
      }

      // 2. UseCase 호출하여 우리 서버로 토큰 전송
      final authUseCase = ref.read(authUseCaseProvider);
      final result = await authUseCase.loginWithApple(identityToken);

      return result.fold(
        onSuccess: (authResponse) {
          print("✅ 서버 애플 로그인 성공! 닉네임: ${authResponse.nickname}");

          // 전역 유저 데이터 세팅
          ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

          final authUser = AuthUser(
            nickname: authResponse.nickname,
            loginType: LoginType.apple, // 🍎 로그인 타입 Apple
          );

          state = AsyncData(authUser);
          return Results.success(authUser);
        },
        onFailure: (message, code) {
          print("❌ 서버 애플 로그인 실패: $message");
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (e) {
      print("🍎 애플 로그인 에러 (취소 등): $e");
      // 사용자가 팝업을 닫은 경우 등
      state = AsyncData(state.valueOrNull);
      return Results.failure('Apple 로그인 중 오류가 발생했거나 취소되었습니다.');
    }
  }

  /// 👻 Guest 로그인 (새로 추가)
  Future<Result<AuthUser?>> guestLogin() async {
    state = const AsyncLoading();

    try {
      // 1. 🌐 Notifier 안에서 언어 상태를 읽어옵니다! (클린 아키텍처의 핵심)
      final languageCode = ref.read(appLanguageProvider);

      // 2. UseCase 호출 (언어 코드 전달)
      final authUseCase = ref.read(authUseCaseProvider);
      final result = await authUseCase.loginAsGuest(languageCode);

      return result.fold(
        onSuccess: (authResponse) {
          print("✅ 게스트 로그인 성공! 발급된 닉네임: ${authResponse.nickname}");

          // 전역 유저 데이터 세팅
          ref.read(userNotifierProvider.notifier).setAuthData(authResponse);

          final authUser = AuthUser(
            nickname: authResponse.nickname,
            loginType: LoginType.guest, // 👻 로그인 타입 Guest
          );

          state = AsyncData(authUser);
          return Results.success(authUser);
        },
        onFailure: (message, code) {
          print("❌ 게스트 로그인 실패: $message");
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (e) {
      print("👻 게스트 로그인 에러: $e");
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
      final currentUser = state.valueOrNull;
      if (currentUser == null) {
        return Result.failure('로그인이 필요합니다');
      }

      print('📝 프로필 설정 시작: nickname=$nickname');

      // 🌐 서버 업데이트
      final profileUseCase = ref.read(profileUseCaseProvider);
      final setupResult = await profileUseCase.setupProfile(
        nickname: nickname,
        isTermsAgreed: isTermsAgreed,
        imageFile: null,
      );

      return setupResult.fold(
        onSuccess: (authResponse) {
          print("✅ 체크포인트 3-4: 서버 로그인 최종 성공!");
          print("🔍 서버 응답 닉네임: ${authResponse?.nickname}");

          final authUser = AuthUser(
            nickname: authResponse?.nickname, // 🎯 서버에서 받은 닉네임 사용
            loginType: LoginType.google,
          );

          print("🔍 생성된 AuthUser: $authUser");
          print("🔍 AuthUser 닉네임: ${authUser.nickname}");

          state = AsyncData(authUser);
          print("🔍 state 업데이트 후: $state");

          return Results.success(authUser);
        },
        onFailure: (message, code) {
          print("❌ 체크포인트 3-5: 서버 로그인 최종 실패! 원인: $message");
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (e) {
      print('❌ 프로필 설정 예외: $e');
      return Result.failure('네트워크 오류가 발생했습니다: $e');
    }
  }

  Future<Result<void>> deleteAccount() async {
    state = const AsyncLoading(); // 로딩 상태로 변경

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

  /// 🚪 로그아웃 (새로운 서비스와 연결된 최종 버전)
  Future<Result<void>> logout() async {
    try {
      final authUseCase = ref.read(authUseCaseProvider);
      final googleOAuthService = ref.read(googleOAuthServiceProvider);

      // ✨ 6. 우리 서버 로그아웃과 구글 로그아웃을 동시에 처리합니다.
      await Future.wait([authUseCase.logout(), googleOAuthService.signOut()]);

      ref.read(userNotifierProvider.notifier).logout();

      state = const AsyncData(null); // UI에 로그아웃 상태(유저 없음)를 알림
      return Results.success(null);
    } catch (error) {
      return Results.success(null); //에러 나도 그냥 로그인으로
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
