// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../services/google_oauth_service.dart';
//
// part 'oauth_provider.g.dart';
//
// /// 🔐 Google OAuth Controller - Firebase 없이
// ///
// /// **상태 관리:** OAuth 로그인/로그아웃 프로세스 관리
// /// **메모리 최적화:** sealed class로 타입 안전한 상태 관리
// @riverpod
// class GoogleOAuthController extends _$GoogleOAuthController {
//   @override
//   GoogleOAuthState build() => const GoogleOAuthState.initial();
//
//   /// Google 로그인 실행
//   Future<void> signIn() async {
//     state = const GoogleOAuthState.loading();
//
//     final result = await GoogleOAuthService.instance.signIn();
//
//     state = result.when(
//       success: (userInfo) => GoogleOAuthState.authenticated(userInfo),
//       failure: (error) => GoogleOAuthState.error(error),
//     );
//   }
//
//   /// 자동 로그인 시도
//   Future<void> tryAutoSignIn() async {
//     state = const GoogleOAuthState.loading();
//
//     final result = await GoogleOAuthService.instance.signInSilently();
//
//     state = result.when(
//       success: (userInfo) => GoogleOAuthState.authenticated(userInfo),
//       failure: (error) => error == OAuthError.notAuthenticated
//           ? const GoogleOAuthState.initial()
//           : GoogleOAuthState.error(error),
//     );
//   }
//
//   /// 로그아웃
//   Future<void> signOut() async {
//     state = const GoogleOAuthState.loading();
//
//     final success = await GoogleOAuthService.instance.signOut();
//
//     state = success
//         ? const GoogleOAuthState.initial()
//         : const GoogleOAuthState.error(OAuthError.unknown);
//   }
//
//   /// 에러 상태 초기화
//   void clearError() {
//     if (state.isError) {
//       state = const GoogleOAuthState.initial();
//     }
//   }
//
//   /// 현재 ID Token 반환 (Spring 백엔드 전송용)
//   String? get idToken => state.userInfo?.idToken;
//
//   /// 현재 사용자 정보 반환
//   GoogleUserInfo? get currentUser => state.userInfo;
//
//   /// 인증 상태 확인
//   bool get isAuthenticated => state.isAuthenticated;
// }
//
// /// 🎨 Google OAuth 상태 - sealed class로 타입 안전성 보장
// sealed class GoogleOAuthState {
//   const GoogleOAuthState();
//
//   const factory GoogleOAuthState.initial() = GoogleOAuthStateInitial;
//   const factory GoogleOAuthState.loading() = GoogleOAuthStateLoading;
//   const factory GoogleOAuthState.authenticated(GoogleUserInfo userInfo) = GoogleOAuthStateAuthenticated;
//   const factory GoogleOAuthState.error(OAuthError error) = GoogleOAuthStateError;
//
//   /// 패턴 매칭으로 상태별 처리
//   T when<T>({
//     required T Function() initial,
//     required T Function() loading,
//     required T Function(GoogleUserInfo userInfo) authenticated,
//     required T Function(OAuthError error) error,
//   }) {
//     return switch (this) {
//       GoogleOAuthStateInitial() => initial(),
//       GoogleOAuthStateLoading() => loading(),
//       GoogleOAuthStateAuthenticated(:final userInfo) => authenticated(userInfo),
//       GoogleOAuthStateError(:final error) => error(error),
//     };
//   }
//
//   /// 편의 getter들
//   bool get isInitial => this is GoogleOAuthStateInitial;
//   bool get isLoading => this is GoogleOAuthStateLoading;
//   bool get isAuthenticated => this is GoogleOAuthStateAuthenticated;
//   bool get isError => this is GoogleOAuthStateError;
//
//   GoogleUserInfo? get userInfo => switch (this) {
//     GoogleOAuthStateAuthenticated(:final userInfo) => userInfo,
//     _ => null,
//   };
//
//   OAuthError? get oAuthError => switch (this) {
//     GoogleOAuthStateError(:final error) => error,
//     _ => null,
//   };
// }
//
// /// 상태 구현 클래스들
// final class GoogleOAuthStateInitial extends GoogleOAuthState {
//   const GoogleOAuthStateInitial();
// }
//
// final class GoogleOAuthStateLoading extends GoogleOAuthState {
//   const GoogleOAuthStateLoading();
// }
//
// final class GoogleOAuthStateAuthenticated extends GoogleOAuthState {
//   final GoogleUserInfo userInfo;
//   const GoogleOAuthStateAuthenticated(this.userInfo);
// }
//
// final class GoogleOAuthStateError extends GoogleOAuthState {
//   final OAuthError error;
//   const GoogleOAuthStateError(this.error);
// }
//
// /// 🎯 간단한 인증 상태 Provider (UI용)
// @riverpod
// bool isAuthenticated(IsAuthenticatedRef ref) {
//   final oauthState = ref.watch(googleOAuthControllerProvider);
//   return oauthState.isAuthenticated;
// }
//
// /// 🔑 현재 ID Token Provider (API 호출용)
// @riverpod
// String? currentIdToken(CurrentIdTokenRef ref) {
//   final oauthState = ref.watch(googleOAuthControllerProvider);
//   return oauthState.userInfo?.idToken;
// }
//
// /// 👤 현재 사용자 정보 Provider
// @riverpod
// GoogleUserInfo? currentUser(CurrentUserRef ref) {
//   final oauthState = ref.watch(googleOAuthControllerProvider);
//   return oauthState.userInfo;
// }
