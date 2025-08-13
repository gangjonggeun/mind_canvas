// =============================================================
// 📁 features/auth/presentation/screens/splash_screen.dart
// =============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_manager_provider.dart';
import '../../domain/repositories/auth_repository_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// 🚀 앱 초기화 및 자동로그인 처리
  Future<void> _initializeApp() async {
    try {
      // 1. 최소 스플래시 시간 보장 (UX)
      final splashFuture = Future.delayed(const Duration(milliseconds: 1500));

      // 2. 토큰 복원 및 검증
      final authFuture = _performAutoLogin();

      // 3. 병렬 처리로 성능 최적화
      final results = await Future.wait([splashFuture, authFuture]);
      final isLoggedIn = results[1] as bool;

      // 4. 라우팅 결정
      if (mounted) {
        if (isLoggedIn) {
          context.go('/main');
        } else {
          context.go('/login');
        }
      }
    } catch (e) {
      print('❌ 앱 초기화 실패: $e');
      if (mounted) {
        context.go('/login'); // 안전한 fallback
      }
    }
  }
  /// 🔐 자동로그인 수행 (최종 버전)
  Future<bool> _performAutoLogin() async {
    final authRepository = ref.read(authRepositoryProvider);
    final tokenManager = ref.read(tokenManagerProvider);

    try {
      // 1. 저장된 토큰 복원
      await tokenManager.initFromStorage();

      // 2. 토큰이 없으면 로그인 필요
      if (!tokenManager.isLoggedIn) {
        print('ℹ️ 저장된 유효한 토큰 없음');
        return false;
      }

      // 3. Repository를 통한 서버 토큰 검증
      final validationResult = await authRepository.refreshTokens();

      return validationResult.fold(
        onSuccess: (_) {
          print('✅ 토큰 검증 성공 (자동로그인 성공)');
          return true; // ✅ 성공시 true 반환
        },
        onFailure: (message, errorCode) {
          print('❌ 토큰 검증 실패: $message ($errorCode)');
          tokenManager.clearTokens();
          return false; // ✅ 실패시 false 반환
        },
      );
    } catch (e) {
      print('❌ 자동로그인 오류: $e');
      await tokenManager.clearTokens();
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 변경: 하얀 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎨 로고 이미지
            Image.asset(
              'assets/images/logo/mcc_logo_high.webp',
              width: 300, // ✅ 변경: 120 → 300
              height: 300, // ✅ 변경: 120 → 300
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text(
              'Mind Canvas',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // ✅ 변경: 흰색 → 검은색 (하얀 배경용)
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '마음을 그리는 캔버스',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // ✅ 변경: 회색 (하얀 배경용)
              ),
            ),
            const SizedBox(height: 48),
            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // ✅ 변경: 파란색 (하얀 배경용)
            ),
          ],
        ),
      ),
    );
  }
}