import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'token_manager.dart';
import '../../features/auth/data/models/response/auth_response_dto.dart';

part 'token_manager_provider.g.dart';

/// 🏭 TokenManager 싱글톤 Provider
///
/// 앱 전체에서 하나의 TokenManager 인스턴스를 공유
/// 메모리 효율성을 위해 keepAlive 사용
@Riverpod(keepAlive: true)
TokenManager tokenManager(TokenManagerRef ref) {
  final manager = TokenManager();

  // Provider가 dispose될 때 TokenManager도 정리
  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
}

/// 🔐 로그인 상태 Provider (reactive)
///
/// TokenManager의 로그인 상태를 실시간으로 감시
/// UI에서 로그인 상태 변경 시 자동으로 rebuild됨
@riverpod
bool isLoggedIn(IsLoggedInRef ref) {
  final manager = ref.watch(tokenManagerProvider);
  return manager.isLoggedIn;
}

/// 🚀 API 호출 가능 상태 Provider
///
/// 액세스 토큰이 유효하여 즉시 API 호출이 가능한지 확인
@riverpod
bool canMakeApiCall(CanMakeApiCallRef ref) {
  final manager = ref.watch(tokenManagerProvider);
  return manager.canMakeApiCall;
}

/// 📊 토큰 상태 요약 Provider (디버깅용)
///
/// 개발 중 토큰 상태를 모니터링하기 위한 Provider
// @riverpod
// Map<String, dynamic> tokenStatus(TokenStatusRef ref) {
//   final manager = ref.watch(tokenManagerProvider);
//   return manager.statusSummary;
// }

/// 🎫 현재 AuthResponse Provider (nullable)
///
/// UI에서 사용자 정보나 토큰 정보가 필요할 때 사용
// @riverpod
// AuthResponse? currentAuth(CurrentAuthRef ref) {
//   final manager = ref.watch(tokenManagerProvider);
//   return manager.currentAuth;
// }

/// ⏰ 액세스 토큰 남은 시간 Provider
///
/// UI에서 토큰 만료 카운트다운 등에 사용
// @riverpod
// int accessTokenRemainingSeconds(AccessTokenRemainingSecondsRef ref) {
//   final manager = ref.watch(tokenManagerProvider);
//   return manager.accessTokenRemainingSeconds;
// }

// =============================================================
// 🎯 사용 예시 (주석)
// =============================================================

/*
// 1. 위젯에서 로그인 상태 감시
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) {
      return LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          // 토큰 상태 표시
          Consumer(
            builder: (context, ref, child) {
              final remaining = ref.watch(accessTokenRemainingSecondsProvider);
              return Text('토큰 만료까지: ${remaining}초');
            },
          ),
        ],
      ),
    );
  }
}

// 2. API 호출 전 상태 체크
class UserService {
  static Future<User?> getProfile(WidgetRef ref) async {
    final canCall = ref.read(canMakeApiCallProvider);
    if (!canCall) {
      print('❌ API 호출 불가 - 토큰 갱신 필요');
      return null;
    }

    final manager = ref.read(tokenManagerProvider);
    final token = await manager.getValidAccessToken();

    // API 호출...
  }
}

// 3. 로그아웃 처리
class LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final manager = ref.read(tokenManagerProvider);
        await manager.clearTokens();
        // isLoggedInProvider가 자동으로 false로 변경됨
      },
      child: Text('로그아웃'),
    );
  }
}

// 4. 앱 초기화 시 토큰 복원
class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _initializeAuth(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }

        final isLoggedIn = ref.watch(isLoggedInProvider);
        return MaterialApp(
          home: isLoggedIn ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }

  Future<void> _initializeAuth(WidgetRef ref) async {
    final manager = ref.read(tokenManagerProvider);
    await manager.initFromStorage();
  }
}
*/