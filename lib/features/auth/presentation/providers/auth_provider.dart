import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mind_canvas/core/utils/result.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/auth_usecase_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<AuthUser?> build() async {
    // 간단한 초기화
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

  /// 🌐 Google 로그인 (간단 버전)
  Future<Result<AuthUser?>> googleLogin() async {
    state = const AsyncLoading();

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = AsyncData(state.valueOrNull);
        return Results.failure('로그인이 취소되었습니다.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        state = AsyncData(state.valueOrNull);
        return Results.failure('ID 토큰을 가져오지 못했습니다.');
      }

      final authUseCase = ref.read(authUseCaseProvider);
      final result = await authUseCase.completeLoginFlow(idToken: idToken);

      return result.fold(
        onSuccess: (authUser) {
          state = AsyncData(authUser);
          return Results.success(authUser);
        },
        onFailure: (message, code) {
          state = AsyncError(message, StackTrace.current);
          return Results.failure<AuthUser?>(message, code);
        },
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return Results.failure('로그인 중 오류가 발생했습니다.');
    }
  }

  /// 🚪 로그아웃
  Future<Result<void>> logout() async {
    try {
      final authUseCase = ref.read(authUseCaseProvider);
      await authUseCase.logout();
      await _googleSignIn.signOut();

      state = const AsyncData(null);
      return Results.success(null);
    } catch (error) {
      return Results.failure('로그아웃 중 오류가 발생했습니다.');
    }
  }
}

/// 편의 Provider들
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