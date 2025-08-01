import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 안전하게 .env 로드
    await dotenv.load(fileName: ".env");
    print("✅ .env 파일 로드 성공");
  } catch (e) {
    print("❌ .env 파일 로드 실패: $e");
    // .env 로드 실패해도 앱은 실행
  }

  runApp(
    const ProviderScope(
      child: MindCanvasApp(),
    ),
  );
}

/// Mind Canvas 메인 애플리케이션
/// 
/// 메모리 최적화:
/// - const 생성자 사용
/// - 정적 테마 설정
/// - 불필요한 상태 관리 제거
/// - Riverpod으로 효율적인 상태 관리
class MindCanvasApp extends StatelessWidget {
  const MindCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 mini 기준
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Mind Canvas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          // 🔑 로그인 화면을 메인으로 설정 (테스트용)
          home: const LoginScreen(),
        );
      },
    );
  }
}
