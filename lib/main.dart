import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_canvas/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';
// ✅ 추가: GoRouter 관련 import
import 'app/main_screen.dart';
import 'core/auth/token_manager.dart';
import 'core/auth/token_manager_provider.dart';
import 'core/providers/app_language_provider.dart';
import 'core/router/app_router.dart';
import 'core/utils/cover_image_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'generated/l10n.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CoverImageHelper.init();
  await Firebase.initializeApp(); // 파이어베이스 초기화
  // await EasyLocalization.ensureInitialized(); // 추가
  await MobileAds.instance.initialize();

  try {
    await dotenv.load(fileName: ".env");
    if (kDebugMode) print("✅ .env 파일 로드 성공");
  } catch (e) {
    if (kDebugMode) print("❌ .env 파일 로드 실패: $e");
  }

  // 로그인 정보가 없으므로 API 키만 넣고 초기화
  await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
  final revenueCatKey = Platform.isIOS
      ? dotenv.env['REVENUECAT_APPLE_KEY']!
      : dotenv.env['REVENUECAT_GOOGLE_KEY']!;
  await Purchases.configure(PurchasesConfiguration(revenueCatKey));

  // // 🔔 권한 요청 (iOS/Android 13+)
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  if (kDebugMode) {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("🔥[디버깅] 현재 기기 FCM Token: $token");
    } catch (e) {
      print("❌ [디버깅] 토큰 가져오기 실패: $e");
    }
  }
  // Hive 초기화
  await Hive.initFlutter();
  await Hive.openBox<String>('recommendation_cache');
  await Hive.openBox('settings');
  await Hive.openBox('analysis_cache');
  await Hive.openBox<String>('chat_cache_box');
  await Hive.openBox<String>('htp_premium_current_session');

  // 4. 🖼️ 단일 검사(별바다, PITR, 어항) 세션 박스 열기
  // Enum의 .name 속성을 사용했으므로 아래 이름과 정확히 일치해야 합니다.
  await Hive.openBox<String>('session_box_starrySea');
  await Hive.openBox<String>('session_box_pitr');
  await Hive.openBox<String>('session_box_fishbowl');

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // (선택사항) 화면 방향을 세로로 고정하고 싶다면
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final tokenManager = TokenManager();
  await tokenManager.initFromStorage();

  runApp(
    ProviderScope(
      overrides: [
        tokenManagerProvider.overrideWithValue(tokenManager),
      ],
      child: MindCanvasApp(),
    ),
  );

  // runApp(const ProviderScope(child: TestMindCanvasApp()));
}

class MindCanvasApp extends ConsumerWidget {
  const MindCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // 🌐 1. Riverpod에서 현재 언어 상태 감시
    final languageCode = ref.watch(appLanguageProvider);
    final authState = ref.watch(authNotifierProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,
          // 🌐 2. Flutter Intl용 Delegate 설정
          localizationsDelegates: const [
            S.delegate, // 👈 생성된 S 클래스
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // 🌐 3. S.delegate에서 지원하는 로케일 자동 연동
          supportedLocales: S.delegate.supportedLocales,

          // 🌐 4. Riverpod 상태에 따라 앱 언어 결정
          locale: Locale(languageCode),

          title: '마음색 캔버스',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF667EEA),
              brightness: Brightness.light,
            ),
            fontFamily: 'Pretendard',
          ),
          routerConfig: router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
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
