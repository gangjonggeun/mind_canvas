import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mind_canvas/features/auth/presentation/screens/splash_screen.dart';

// ✅ 추가: GoRouter 관련 import
import 'app/main_screen.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env 파일 로드 성공");
  } catch (e) {
    print("❌ .env 파일 로드 실패: $e");
  }

  runApp(const ProviderScope(child: MindCanvasApp()));

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
