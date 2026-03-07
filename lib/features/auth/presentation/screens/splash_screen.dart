// 📁 features/auth/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/auth_user_entity.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _minTimePassed = false; // 1초가 지났는지 여부
  bool _isNavigated = false; // 중복 이동 방지용

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // 1초 타이머 시작
  Future<void> _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    setState(() {
      _minTimePassed = true;
    });

    // 1초가 지났을 때, 만약 서버 검증이 이미 끝나있다면 즉시 이동!
    _checkAndNavigate(ref.read(authNotifierProvider));
  }

  // 🚀 이동 로직 (조건이 모두 맞을 때만 이동)
  void _checkAndNavigate(AsyncValue<AuthUser?> authState) {
    // 1. 최소 1초의 스플래시(로고) 시간이 지나지 않았다면 대기
    if (!_minTimePassed) return;

    // 2. 아직 서버와 통신 중(로딩)이라면 대기
    if (authState.isLoading) return;

    // 3. 이미 다른 화면으로 넘어갔다면 중복 실행 방지
    if (_isNavigated) return;

    _isNavigated = true; // 이동 플래그 켜기

    // 4. 로그인 여부에 따라 확실하게 이동!
    final user = authState.valueOrNull;
    if (user == null) {
      print('⚡ 토큰 없음/만료 -> [로그인 화면]으로 이동');
      context.go('/login');
    } else {
      // 닉네임이 없으면 로그인 화면으로 보내서 다이얼로그가 뜨게 함
      if (user.nickname == null) {
        print('⚡ 닉네임 미설정 ->[로그인 화면(다이얼로그)]으로 이동');
        context.go('/login');
      } else {
        print('✅ 자동 로그인 성공 -> [메인 화면]으로 이동');
        context.go('/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 만약 서버 통신이 1초보다 오래 걸렸을 경우, 통신이 끝나는 순간을 감지하는 리스너!
    ref.listen<AsyncValue<AuthUser?>>(authNotifierProvider, (prev, next) {
      _checkAndNavigate(next);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset(
              'assets/images/logo/mcc_logo_high.webp',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 300, height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.psychology, size: 100, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Mind Canvas', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            const Text('마음을 그리는 캔버스', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 48),

            // 계속 로딩 바 표시 (서버 통신 중이거나 1초 대기 중)
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
          ],
        ),
      ),
    );
  }
}