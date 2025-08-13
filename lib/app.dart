import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MindCanvasApp extends ConsumerWidget {
  const MindCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GoRouter 인스턴스 가져오기
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Mind Canvas',

      // 🎨 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // 시스템 설정 따라가기

      // 🧭 라우터 설정
      routerConfig: router,

      // 🌐 다국어 지원 (추후 확장)
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,

      // 🚫 디버그 배너 숨김
      debugShowCheckedModeBanner: false,

      // 📱 앱 메타데이터
      builder: (context, child) {
        return MediaQuery(
          // 시스템 폰트 크기 무시 (일관된 UI 유지)
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}