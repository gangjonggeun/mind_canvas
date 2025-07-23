import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/main_screen.dart';
// import 'core/utils/app_logger.dart';
import 'package:mind_canvas/core/home/domain/entities/recommended_content_entity.dart';
void main() {
  // 🚀 Logger 초기화 (최우선)
  // AppLogger.initialize();
  
  // 📊 임시로 메모리 최적화 비활성화 (디버깅용)
  // PaintingBinding.instance.imageCache.maximumSize = 50;
  // PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;
  
  // logger.i('Mind Canvas 앱 시작! 🎨');
  
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
          title: '마음색 캔버스',
          debugShowCheckedModeBanner: false, // 디버그 배너 제거
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF667EEA),
              brightness: Brightness.light,
            ),
            fontFamily: 'Pretendard', // 한글 폰트 (없으면 시스템 기본)
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
