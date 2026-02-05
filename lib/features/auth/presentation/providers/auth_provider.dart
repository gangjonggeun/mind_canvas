import 'package:mind_canvas/core/services/google/google_oauth_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';
import '../../../../app/presentation/notifier/user_notifier.dart';
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
    // build 메서드는 앱의 자체 로그인 상태를 확인하는 역할이므로
    // 수정할 필요가 없습니다. 완벽합니다.
    final authUseCase = ref.read(authUseCaseProvider);
    final isLoggedIn = await authUseCase.isLoggedIn();

    print("🧐 [Build] 로그인 상태: $isLoggedIn");

    if (isLoggedIn) {
      final userResult = await authUseCase.getCurrentUser();

      print("🧐 [Build] 유저 정보 결과 성공여부: ${userResult.isSuccess}");

      if (userResult.isSuccess) {
        Future.microtask(() async {
          ref.read(userNotifierProvider.notifier).refreshProfile();

          print("🚩 [Build] 모든 조건 만족! syncFcmToken 호출 시도");

          final repo = ref.read(authRepositoryProvider);

          await repo.syncFcmToken();
          // authUseCase.syncFcmToken();
        });

      }

      return userResult.fold(
        onSuccess: (user) => user,
        onFailure: (_, __) => null,
      );
    }

    return null;
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
            print("✅ 서버 로그인 성공! 닉네임: ${authResponse.nickname}, 코인: ${authResponse.coins}");

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


  /// 📝 프로필 설정 (개선된 버전)
  Future<Result<void>> setupProfile({
    required String nickname,
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
        profileImageUrl: profileImageUrl,
      );

      return setupResult.fold(
        onSuccess: (authResponse) {
          print("✅ 체크포인트 3-4: 서버 로그인 최종 성공!");
          print("🔍 서버 응답 닉네임: ${authResponse?.nickname}");

          final authUser = AuthUser(
            nickname: authResponse?.nickname,  // 🎯 서버에서 받은 닉네임 사용
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
      return Results.failure('로그아웃 중 오류가 발생했습니다.');
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
