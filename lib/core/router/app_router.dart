// =============================================================
// 📁 core/router/app_router.dart (완전한 버전)
// =============================================================
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/app/main_screen.dart';

// 화면 imports
import '../../features/analysis/presentation/analysis_screen.dart';
import '../../features/analysis/presentation/widgets/comprehensive_analysis_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/consulting/presentation/consulting_screen.dart';
import '../../features/consulting/presentation/pages/ai_chat_page.dart';
import '../../features/consulting/presentation/pages/anger_vent_page.dart';
import '../../features/consulting/presentation/pages/emotion_diary_page.dart';
import '../../features/home/home_screen.dart';

// Provider imports
import '../../features/home/presentation/screen/popular_test_ranking_screen.dart';
import '../../features/htp/htp_dashboard_premium_screen.dart';
import '../../features/htp/htp_dashboard_screen.dart';
import '../../features/htp/htp_drawing_screen_v2.dart';
import '../../features/htp/presentation/enum/single_test_type.dart';
import '../../features/htp/single_test_dashboard_screen.dart';
import '../../features/info/data/models/response/test_detail_response.dart';
import '../../features/info/info_screen.dart';
import '../../features/profile/presentation/pages/my_activity_page.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/psy_result/presentation/screen/psy_result_screen2.dart';
import '../../features/recommendation/presentation/pages/community_page.dart';
import '../../features/recommendation/presentation/pages/create_post_page.dart';
import '../../features/recommendation/presentation/recommendation_screen.dart';
import '../../features/taro/domain/models/TaroResultEntity.dart';
import '../../features/taro/presentation/pages/taro_card_selection_page.dart';
import '../../features/taro/presentation/pages/taro_consultation_setup_page.dart';
import '../../features/taro/presentation/pages/taro_result_page.dart';
import '../auth/token_manager_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshNotifier(ref),

    // 🛡️ [핵심] 완벽한 라우트 가드
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      // 1. 🎯 [핵심] 스플래시 화면에 있을 때는 라우터가 아무것도 하지 마!
      // 스플래시 위젯이 1초 대기 후 알아서 화면을 넘길 수 있도록 권한을 넘겨줍니다.
      if (isSplash) return null;

      // --- (아래부터는 기존과 동일하게 유지) ---

      if (authState.isLoading) return null;

      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final hasNickname = user?.nickname != null;

      // 2. 비로그인 유저의 앱 내부 접근 차단
      if (!isLoggedIn && !isLogin) {
        return '/login';
      }

      // 3. 이미 로그인한 유저가 뒤로가기 등으로 로그인 화면에 가는 것 방지
      if (isLoggedIn && isLogin) {
        if (!hasNickname) return null;
        return '/main';
      }

      return null;
    },
    // 📋 라우트 정의
    routes: [
      // 1. 인증/시작 경로
      GoRoute(path: '/splash', name: 'splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/main', name: 'main', builder: (context, state) => const MainScreen()),

      // 2. 정보 및 테스트 관련 (매개변수 필요)
      GoRoute(
        path: '/info/:testId',
        name: 'info',
        builder: (context, state) {
          final testId = int.parse(state.pathParameters['testId']!);
          final testDetail = state.extra as TestDetailResponse?;
          return InfoScreen(testId: testId, testDetail: testDetail);
        },
      ),

      // 3. 그림 테스트 (매개변수: drawingType, title)
      GoRoute(
        path: '/htp_drawing',
        name: 'htp_drawing',
        builder: (context, state) {
          final query = state.uri.queryParameters;
          return HtpDrawingScreenV2(
            drawingType: query['drawingType'] ?? '',
            title: query['title'] ?? '',
            existingSketchJson: query['existingSketchJson'],
          );
        },
      ),

      // 4. 대시보드 및 상세 페이지
      GoRoute(
        path: '/dashboard/:testType',
        name: 'dashboard',
        builder: (context, state) {
          final typeString = state.pathParameters['testType']!;
          return SingleTestDashboardScreen(testType: SingleTestType.values.byName(typeString));
        },
      ),
      GoRoute(path: '/htp_dashboard', name: 'htp_dashboard', builder: (context, state) => const HtpDashboardScreen()),
      GoRoute(path: '/htp_dashboard_premium', name: 'htp_dashboard_premium', builder: (context, state) => const HtpDashboardPremiumScreen()),
      GoRoute(path: '/popular_test', name: 'popular_test', builder: (context, state) => const PopularTestRankingScreen()),
      // GoRoute(path: '/psy_result2', name: 'psy_result2', builder: (context, state) => const PsyResultScreen2()),

      // 5. 타로 관련
      GoRoute(path: '/taro_selection', name: 'taro_selection', builder: (context, state) => const TaroCardSelectionPage()),
      GoRoute(path: '/taro_setup', name: 'taro_setup', builder: (context, state) => const TaroConsultationSetupPage()),
      GoRoute(
        path: '/taro_result',
        name: 'taro_result',
        builder: (context, state) => TaroResultPage(result: state.extra as TaroResultEntity),
      ),

      // 6. 커뮤니티 및 게시글
      GoRoute(path: '/community', name: 'community', builder: (context, state) => const CommunityPage()),
      GoRoute(path: '/create_post', name: 'create_post', builder: (context, state) => const CreatePostPage()),

      // 7. 프로필 및 활동
      GoRoute(path: '/profile', name: 'profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/my_activity', name: 'my_activity', builder: (context, state) => const MyActivityPage()),
      GoRoute(path: '/emotion_diary', name: 'emotion_diary', builder: (context, state) => const EmotionDiaryPage()),
      GoRoute(path: '/ai_chat', name: 'ai_chat', builder: (context, state) => const AiChatPage()),
      GoRoute(path: '/anger_vent', name: 'anger_vent', builder: (context, state) => const AngerVentPage()),

      // 8. 분석 및 상담
      GoRoute(path: '/analysis', name: 'analysis', builder: (context, state) => const AnalysisScreen()),
      GoRoute(path: '/comprehensive_analysis', name: 'comprehensive_analysis', builder: (context, state) => const ComprehensiveAnalysisScreen()),
      GoRoute(path: '/consulting', name: 'consulting', builder: (context, state) => const ConsultingScreen()),
      GoRoute(path: '/recommendation', name: 'recommendation', builder: (context, state) => const RecommendationScreen()),
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

// 💡 Stream 연동 Helper (아래 코드를 파일 하단에 추가)
class GoRouterRefreshNotifier extends ChangeNotifier {
  final Ref ref;

  GoRouterRefreshNotifier(this.ref) {
    // AuthNotifier의 변화를 감지
    ref.listen(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}
