import 'package:flutter/material.dart';
import 'app/main_screen.dart';

void main() {
  // 📊 임시로 메모리 최적화 비활성화 (디버깅용)
  // PaintingBinding.instance.imageCache.maximumSize = 50;
  // PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;
  
  print('🚷 메모리 최적화 비활성화 - 디버깅 모드');
  
  runApp(const MindCanvasApp());
}

/// Mind Canvas 메인 애플리케이션
/// 
/// 메모리 최적화:
/// - const 생성자 사용
/// - 정적 테마 설정
/// - 불필요한 상태 관리 제거
class MindCanvasApp extends StatelessWidget {
  const MindCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
