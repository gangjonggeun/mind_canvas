// =============================================================
// 📁 core/router/app_router.dart (완전한 버전)
// =============================================================
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/app/main_screen.dart';

// 화면 imports
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/home_screen.dart';

// Provider imports
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../auth/token_manager_provider.dart';

/// 🧭 앱 라우터 Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // 🚀 초기 경로를 스플래시로 설정
    initialLocation: '/splash',

    // 🔍 디버그 로깅 (개발 시에만)
    debugLogDiagnostics: true,

    // 📋 라우트 정의
    routes: [
      // 🌟 스플래시 화면 (앱 시작점)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // 🔐 로그인 화면
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // 🏠 홈 화면 (인증 필요)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // 📄 기타 화면들...
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),

      // 📄 기타 화면들...
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),


    ],

    // 🚨 에러 페이지
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/splash'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),

    // 🛡️ 라우트 가드 (추후 확장 가능)
    redirect: (context, state) {
      // 현재는 스플래시에서 모든 검증을 처리하므로 null 반환
      // 추후 필요시 인증 체크 로직 추가 가능
      return null;
    },
  );
});