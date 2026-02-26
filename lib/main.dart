import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_canvas/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/services.dart';
// ✅ 추가: GoRouter 관련 import
import 'app/main_screen.dart';
import 'core/router/app_router.dart';
import 'core/utils/cover_image_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CoverImageHelper.init();
  await Firebase.initializeApp(); // 파이어베이스 초기화
  await EasyLocalization.ensureInitialized(); // 추가


  // 🔔 권한 요청 (iOS/Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 [디버깅] 현재 기기 FCM Token: $token");
  } catch (e) {
    print("❌ [디버깅] 토큰 가져오기 실패: $e");
    // iOS의 경우 APNs 설정이 안 되어있으면 여기서 에러가 나거나 영원히 대기합니다.
  }

  // Hive 초기화
  await Hive.initFlutter();
  await Hive.openBox<String>('recommendation_cache');
  await Hive.openBox('settings');
  await Hive.openBox('analysis_cache');

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env 파일 로드 성공");
  } catch (e) {
    print("❌ .env 파일 로드 실패: $e");
  }
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // (선택사항) 화면 방향을 세로로 고정하고 싶다면
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
      EasyLocalization(
        supportedLocales: [Locale('ko'), Locale('en'), Locale('ja')],
        path: 'assets/translations', // 경로 확인
        fallbackLocale: Locale('ko'),
        child:  ProviderScope(child: MindCanvasApp())),
  );


  // runApp(const ProviderScope(child: TestMindCanvasApp()));

}

/// Mind Canvas 메인 애플리케이션
class MindCanvasApp extends ConsumerWidget {
  // ✅ 변경: StatelessWidget → ConsumerWidget
  const MindCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 변경: WidgetRef 추가
    // ✅ 추가: GoRouter 인스턴스 가져오기
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // ✅ 변경: MaterialApp → MaterialApp.router
          title: '마음색 캔버스',
          debugShowCheckedModeBanner: false,

          // 🎨 테마 설정
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF667EEA),
              brightness: Brightness.light,
            ),
            fontFamily: 'Pretendard',
          ),

          // 🧭 라우터 설정 (home 대신 routerConfig 사용)
          routerConfig: router,
          // ✅ 변경: home → routerConfig

          // 📱 ScreenUtil 적용
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling, // 시스템 폰트 크기 무시
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}

class TestMindCanvasApp extends ConsumerWidget {
  const TestMindCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // ✅ 임시: MaterialApp.router → MaterialApp
          title: '마음색 캔버스',
          debugShowCheckedModeBanner: false,

          // 🎨 테마 설정
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF667EEA),
              brightness: Brightness.light,
            ),
            fontFamily: 'Pretendard',
          ),

          // ✅ 임시: 바로 메인 화면으로 이동
          home: const SplashScreen(),
          // 임시 메인 화면

          // 📱 ScreenUtil 적용
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
