import 'package:mind_canvas/core/services/google/google_oauth_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';
import '../../../../core/providers/google_oauth_provider.dart';
import '../../domain/entities/auth_user_entity.dart';
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

    if (isLoggedIn) {
      final userResult = await authUseCase.getCurrentUser();
      return userResult.fold(
        onSuccess: (user) => user,
        onFailure: (_, __) => null,
      );
    }

    return null;
  }

  /// 🌐 Google 로그인 (새로운 서비스와 연결된 최종 버전)
  Future<Result<AuthUser?>> googleLogin() async {
    state = const AsyncLoading(); // UI에 로딩 상태 알림

    print("✅ 체크포인트 1: googleLogin 메서드 시작됨.");
    // ✨ 4. 우리가 만든 GoogleOAuthService를 Provider를 통해 가져옵니다.
    final googleOAuthService = ref.read(googleOAuthServiceProvider);

    // ✨ 5. 서비스에게 "로그인 해줘!" 라고 시키기만 하면 끝.
    //        웹/모바일 구분은 서비스가 알아서 처리합니다.
    final googleResult = await googleOAuthService.signIn();
    print("✅ 체크포인트 2: googleOAuthService.signIn() 호출 완료. 결과 타입: ${googleResult.runtimeType}");


    // 구글 로그인 결과(성공/실패)에 따라 다음 행동을 결정합니다.
    return await googleResult.when(

      // 구글 로그인 성공 시 (idToken을 받아옴)
      success: (idToken) async {
        print("✅ 체크포인트 3-1: success 블록 진입 성공!");
        // 획득한 idToken으로 우리 서버에 최종 로그인(또는 회원가입)을 요청합니다.
        final authUseCase = ref.read(authUseCaseProvider);
        print("✅ 체크포인트 3-2: AuthUseCase 가져오기 성공!");
        final result = await authUseCase.completeLoginFlow(idToken: idToken);
        print("✅ 체크포인트 3-3: 서버 로그인(completeLoginFlow) 완료!");
        // 우리 서버의 최종 로그인 결과에 따라 상태를 업데이트합니다.
        return result.fold(

          onSuccess: (authUser) {
            print("✅ 체크포인트 3-4: 서버 로그인 최종 성공!");
            state = AsyncData(authUser); // UI에 최종 유저 정보 업데이트
            return Results.success(authUser);
          },
          onFailure: (message, code) {
            print("❌ 체크포인트 3-5: 서버 로그인 최종 실패! 원인: $message");
            state = AsyncError(message, StackTrace.current); // UI에 에러 상태 업데이트
            return Results.failure<AuthUser?>(message, code);
          },
        );
      },

      // 구글 로그인 실패 시 (사용자가 팝업을 닫는 등)
      failure: (error) {
        print("실패 !! $error ");
        state = AsyncData(state.valueOrNull); // 로딩 상태를 풀고 이전 상태로 복귀
        return Results.failure(error.message); // OAuthError의 메시지를 그대로 반환
      },
    );
  }

  /// 🚪 로그아웃 (새로운 서비스와 연결된 최종 버전)
  Future<Result<void>> logout() async {
    try {
      final authUseCase = ref.read(authUseCaseProvider);
      final googleOAuthService = ref.read(googleOAuthServiceProvider);

      // ✨ 6. 우리 서버 로그아웃과 구글 로그아웃을 동시에 처리합니다.
      await Future.wait([
        authUseCase.logout(),
        googleOAuthService.signOut(),
      ]);

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