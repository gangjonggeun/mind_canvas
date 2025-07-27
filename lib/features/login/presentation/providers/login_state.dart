import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.freezed.dart';

/// 🔑 로그인 상태 클래스
/// 
/// 불변 객체로 안전한 상태 관리
/// - 메모리 효율적인 50바이트 이하 설계
/// - 상태별 명확한 구분
/// - 로딩/성공/실패 상태 관리
@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  
  const factory LoginState.loading({
    required AuthProvider provider,
    String? message,
  }) = _Loading;
  
  const factory LoginState.success({
    required UserEntity user,
    required AuthProvider provider,
  }) = _Success;
  
  const factory LoginState.failure({
    required String message,
    String? errorCode,
    AuthProvider? provider,
  }) = _Failure;
}

/// 🎮 로그인 상태 관리 NotifierProvider
/// 
/// Riverpod을 사용한 메모리 효율적인 상태 관리
/// - 자동 메모리 해제 (생명주기 기반)
/// - 타입 안전한 상태 업데이트
/// - 테스트 가능한 설계
class LoginNotifier extends StateNotifier<LoginState> {
  static const String _logTag = 'LoginNotifier';
  
  final LoginUseCase _loginUseCase;
  
  LoginNotifier(this._loginUseCase) : super(const LoginState.initial());

  /// 📧 이메일로 로그인
  Future<void> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // 🔄 로딩 상태로 변경
    state = const LoginState.loading(
      provider: AuthProvider.email,
      message: '이메일 로그인 중...',
    );

    try {
      // 🎯 Use Case 실행
      final result = await _loginUseCase.loginWithEmail(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      // 📊 결과에 따른 상태 업데이트
      result.when(
        success: (user) {
          state = LoginState.success(
            user: user,
            provider: AuthProvider.email,
          );
        },
        failure: (message, code) {
          state = LoginState.failure(
            message: message,
            errorCode: code,
            provider: AuthProvider.email,
          );
        },
        loading: () {
          // 이미 로딩 상태이므로 무시
        },
      );

    } catch (e) {
      state = LoginState.failure(
        message: '로그인 중 예상치 못한 오류가 발생했습니다',
        errorCode: 'UNEXPECTED_ERROR',
        provider: AuthProvider.email,
      );
    }
  }

  /// 🌐 Google로 로그인
  Future<void> loginWithGoogle() async {
    state = const LoginState.loading(
      provider: AuthProvider.google,
      message: 'Google 로그인 중...',
    );

    try {
      final result = await _loginUseCase.loginWithGoogle();

      result.when(
        success: (user) {
          state = LoginState.success(
            user: user,
            provider: AuthProvider.google,
          );
        },
        failure: (message, code) {
          state = LoginState.failure(
            message: message,
            errorCode: code,
            provider: AuthProvider.google,
          );
        },
        loading: () {},
      );

    } catch (e) {
      state = LoginState.failure(
        message: 'Google 로그인 중 오류가 발생했습니다',
        errorCode: 'UNEXPECTED_ERROR',
        provider: AuthProvider.google,
      );
    }
  }

  /// 🍎 Apple로 로그인
  Future<void> loginWithApple() async {
    state = const LoginState.loading(
      provider: AuthProvider.apple,
      message: 'Apple 로그인 중...',
    );

    try {
      final result = await _loginUseCase.loginWithApple();

      result.when(
        success: (user) {
          state = LoginState.success(
            user: user,
            provider: AuthProvider.apple,
          );
        },
        failure: (message, code) {
          state = LoginState.failure(
            message: message,
            errorCode: code,
            provider: AuthProvider.apple,
          );
        },
        loading: () {},
      );

    } catch (e) {
      state = LoginState.failure(
        message: 'Apple 로그인 중 오류가 발생했습니다',
        errorCode: 'UNEXPECTED_ERROR',
        provider: AuthProvider.apple,
      );
    }
  }

  /// 👥 게스트로 로그인
  Future<void> loginAsGuest() async {
    state = const LoginState.loading(
      provider: AuthProvider.guest,
      message: '게스트 로그인 중...',
    );

    try {
      final result = await _loginUseCase.loginAsGuest();

      result.when(
        success: (user) {
          state = LoginState.success(
            user: user,
            provider: AuthProvider.guest,
          );
        },
        failure: (message, code) {
          state = LoginState.failure(
            message: message,
            errorCode: code,
            provider: AuthProvider.guest,
          );
        },
        loading: () {},
      );

    } catch (e) {
      state = LoginState.failure(
        message: '게스트 로그인 중 오류가 발생했습니다',
        errorCode: 'UNEXPECTED_ERROR',
        provider: AuthProvider.guest,
      );
    }
  }

  /// 🔍 익명으로 로그인
  Future<void> loginAsAnonymous() async {
    state = const LoginState.loading(
      provider: AuthProvider.anonymous,
      message: '익명 로그인 중...',
    );

    try {
      // TODO: 실제 익명 로그인 UseCase 구현
      // 현재는 게스트 로그인과 동일하게 처리
      final result = await _loginUseCase.loginAsGuest();

      result.when(
        success: (user) {
          state = LoginState.success(
            user: user,
            provider: AuthProvider.anonymous,
          );
        },
        failure: (message, code) {
          state = LoginState.failure(
            message: message,
            errorCode: code,
            provider: AuthProvider.anonymous,
          );
        },
        loading: () {},
      );

    } catch (e) {
      state = LoginState.failure(
        message: '익명 로그인 중 오류가 발생했습니다',
        errorCode: 'UNEXPECTED_ERROR',
        provider: AuthProvider.anonymous,
      );
    }
  }

  /// 🔄 상태 초기화
  void resetState() {
    state = const LoginState.initial();
  }

  /// 🎯 에러 상태 클리어
  void clearError() {
    if (state is _Failure) {
      state = const LoginState.initial();
    }
  }
}

/// 🔗 Provider 정의들
/// 
/// Riverpod 의존성 주입을 위한 Provider 선언
/// - 메모리 효율적인 autoDispose 사용
/// - 타입 안전한 의존성 주입

// TODO: LoginUseCase Provider (구현 필요)
// final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return LoginUseCase(authRepository);
// });

// final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
//   final loginUseCase = ref.watch(loginUseCaseProvider);
//   return LoginNotifier(loginUseCase);
// });

/// 🎯 LoginState 확장 메서드
extension LoginStateExtension on LoginState {
  /// 로딩 중인지 확인
  bool get isLoading => this is _Loading;
  
  /// 성공 상태인지 확인
  bool get isSuccess => this is _Success;
  
  /// 실패 상태인지 확인
  bool get isFailure => this is _Failure;
  
  /// 초기 상태인지 확인
  bool get isInitial => this is _Initial;

  /// 현재 로딩 중인 제공자 반환
  AuthProvider? get loadingProvider {
    return maybeWhen(
      loading: (provider, _) => provider,
      orElse: () => null,
    );
  }

  /// 성공한 사용자 반환
  UserEntity? get successUser {
    return maybeWhen(
      success: (user, _) => user,
      orElse: () => null,
    );
  }

  /// 에러 메시지 반환
  String? get errorMessage {
    return maybeWhen(
      failure: (message, _, __) => message,
      orElse: () => null,
    );
  }

  /// 로딩 메시지 반환
  String? get loadingMessage {
    return maybeWhen(
      loading: (_, message) => message,
      orElse: () => null,
    );
  }
}
