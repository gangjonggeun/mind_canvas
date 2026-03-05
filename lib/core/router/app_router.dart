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
import '../../features/home/presentation/screen/popular_test_ranking_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../auth/token_manager_provider.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',

    // 🛡️ [핵심] 라우트 가드: 토큰 상태를 감시하고 진입을 통제합니다.
    redirect: (context, state) {
      final tokenManager = ref.read(tokenManagerProvider);
      final isLoggedIn = tokenManager.isLoggedIn;

      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      // 1. 로그인 안 되어 있는데 홈이나 메인으로 가려고 하면 -> 로그인 화면으로 튕김
      if (!isLoggedIn && !isSplash && !isLogin) {
        return '/login';
      }

      // 2. 로그인 되어 있는데 로그인/스플래시 화면으로 가려고 하면 -> 홈으로 보내줌
      if (isLoggedIn && (isLogin || isSplash)) {
        return '/main';
      }

      return null; // 통과
    },
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

      // 📄 기타 화면들...
      GoRoute(
        path: '/popular_test',
        name: 'popular_test',
        builder: (context, state) => const PopularTestRankingScreen(),
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

  );
});