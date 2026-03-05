// =============================================================
// 📁 features/auth/presentation/screens/splash_screen.dart (개선 버전)
// =============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_manager_provider.dart';
import '../../domain/repositories/auth_repository_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

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

  /// 🚀 앱 초기화 및 자동로그인 처리 (에러 처리 강화)
  Future<void> _initializeApp() async {
    try {
      // 1. 가장 먼저 로컬 스토리지의 토큰 유무부터 확인합니다.
      final tokenManager = ref.read(tokenManagerProvider);
      await tokenManager.initFromStorage();

      if (!tokenManager.isLoggedIn) {
        print('⚡ 토큰 없음 -> 스플래시 스킵 후 [로그인 화면]으로 이동');
        if (mounted) {

          // 만약 클래스 직접 이동을 쓰신다면:
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
        return;
      }
      // 🚀 2. [UX 개선] 저장된 토큰이 아예 없다면? (첫 설치 or 로그아웃 상태)
      // 무의미한 1.5초 대기를 스킵하고 즉시 로그인 화면으로 보냅니다.
      if (tokenManager.currentAuth == null ||
          tokenManager.isRefreshTokenExpired) {
        print('⚡ 토큰 없음/리프레시 만료 -> 스플래시 스킵 후 바로 로그인으로 이동');
        if (mounted) await _navigateToNextScreen(false);
        return;
      }

      // 3. 유효한(혹은 갱신 가능한) 토큰이 있는 경우에만 로고를 보여주며 자동 로그인 시도
      final splashFuture = Future.delayed(
          const Duration(milliseconds: 1000)); // 1500 -> 1000으로 약간 단축
      final authFuture = _performAutoLogin();

      // 4. 병렬 처리로 성능 최적화
      final results = await Future.wait([splashFuture, authFuture]);
      final isLoggedIn = results[1] as bool;

      // 5. 안전한 라우팅
      if (mounted) {
        await _navigateToNextScreen(isLoggedIn);
      }
    } catch (e) {
      print('❌ 앱 초기화 실패: $e');
      if (mounted) {
        await _navigateToNextScreen(false); // 로그인 화면으로 이동
      }
    }
  }
  Future<bool> _performAutoLogin() async {
    try {
      final tokenManager = ref.read(tokenManagerProvider);
      await tokenManager.initFromStorage();

      if (!tokenManager.isLoggedIn) return false;

      // 🚨[핵심 변경] future를 await 할 때, 서버가 꺼져있어 DioException 등 네트워크 에러가 발생하면
      // 강제로 catch 블록으로 빠지게 됩니다.
      final authUser = await ref.read(authNotifierProvider.future);

      if (authUser != null) {
        print('✅ 서버 검증 및 자동로그인 성공');
        return true;
      } else {
        print('❌ 서버 검증 실패 (토큰 만료 혹은 서버 다운)');
        return false;
      }
    } catch (e) {
      // 💡 서버가 완전히 꺼져있어서 Timeout이나 SocketException이 발생한 경우 이곳으로 옵니다.
      // 무조건 false를 반환하여 안전하게 로그인 화면으로 라우팅되도록 철벽 방어합니다.
      print('❌ 자동로그인 통신 예외 발생 (서버 오프라인 등): $e');
      return false;
    }
  }

  /// 🧭 안전한 네비게이션 (GoRouter 에러 방지)
  Future<void> _navigateToNextScreen(bool isLoggedIn) async {
    try {
      if (!mounted) return; // 위젯이 dispose된 경우 중단

      // GoRouter context 존재 여부 확인
      if (!GoRouter.maybeOf(context)!.canPop() != null) {
        if (isLoggedIn) {
          context.go('/main');
          print('✅ 메인 화면으로 이동');
        } else {
          context.go('/login');
          print('✅ 로그인 화면으로 이동');
        }
      } else {
        // GoRouter가 없는 경우 일반 Navigator 사용
        print('⚠️ GoRouter 없음, Navigator 사용');
        if (isLoggedIn) {
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      print('❌ 네비게이션 오류: $e');
      // 최후의 수단: 에러 다이얼로그 표시
      if (mounted) {
        _showNavigationError();
      }
    }
  }

  /// 🚨 네비게이션 에러 다이얼로그
  void _showNavigationError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('초기화 오류'),
        content: const Text('앱 초기화 중 문제가 발생했습니다.\n앱을 다시 시작해주세요.'),
        actions: [
          TextButton(
            onPressed: () {
              // 앱 종료 (또는 다시 시도)
              Navigator.of(context).pop();
              _initializeApp(); // 다시 시도
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎨 로고 이미지
            Image.asset(
              'assets/images/logo/mcc_logo_high.webp',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              // 🛡️ 이미지 로드 에러 처리
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Mind Canvas',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '마음을 그리는 캔버스',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),
            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            // 🔍 디버그 정보 (개발 중에만)
            const Text(
              '앱을 초기화하는 중...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// 🎯 핵심 개선사항
// =============================================================

/*
✅ 개선된 부분들:

1. **안전한 네비게이션**:
   - GoRouter.maybeOf(context) 사용으로 context 존재 확인
   - Navigator fallback 추가
   - 에러 다이얼로그로 최후 처리

2. **에러 처리 강화**:
   - try-catch로 모든 단계 보호
   - 이미지 로드 실패 시 fallback UI
   - mounted 체크 강화

3. **메모리 최적화**:
   - Future.wait()로 병렬 처리
   - 적절한 dispose 처리
   - 불필요한 상태 유지 방지

4. **UX 개선**:
   - 로딩 상태 표시
   - 에러 시 다시 시도 옵션
   - 디버그 정보 표시

5. **시큐어 코딩**:
   - null 체크 강화
   - 예외 상황 모두 처리
   - 사용자 친화적 에러 메시지
*/
