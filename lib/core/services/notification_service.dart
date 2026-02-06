import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/data/repositories/test_repository_provider.dart';
import '../../features/psy_result/data/mapper/test_result_mapper.dart';
import '../../features/psy_result/presentation/psy_result_screen.dart';
import '../../features/taro/data/repositories/taro_repository_impl.dart';
import '../../features/taro/presentation/pages/taro_result_page.dart';


class NotificationHandler {
  static void initialize(BuildContext context, WidgetRef ref) async {
    // 1. 앱이 켜져 있을 때 (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      final type = message.data['type'];
      final resultId = message.data['resultId'];
      if (resultId == null) return;

      if (type == 'TEST_RESULT') {
        _showResultDialog(context, ref, resultId, "심리 테스트");
      } else if (type == 'TAROT_RESULT') {
        _showResultDialog(context, ref, resultId, "타로 상담");
      }
    });

    // 2. 앱이 백그라운드에 있다가 알림 클릭으로 열릴 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final type = message.data['type'];
      final resultId = message.data['resultId'];
      if (resultId != null && type != null) {
        _handleNavigation(context, ref, resultId, type); // ✅ type 전달
      }
    });

    // 3. 앱이 완전히 종료되었다가 알림 클릭으로 켜질 때
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final type = initialMessage.data['type'];
      final resultId = initialMessage.data['resultId'];
      if (resultId != null && type != null) {
        _handleNavigation(context, ref, resultId, type); // ✅ type 전달
      }
    }
  }


  // ✅ 상세 조회 및 이동 로직 (분기 처리)
  static void _handleNavigation(BuildContext context, WidgetRef ref, String resultId, String type) async {
    if (type == 'TEST_RESULT') {
      final result = await ref.read(testRepositoryProvider).getTestResultDetail(resultId);
      result.fold(
        onSuccess: (data) {
          final psyResult = TestResultMapper.toEntity(data);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PsyResultScreen(result: psyResult)));
        },
        onFailure: (code, msg) => print("심리테스트 조회 실패: $msg"),
      );
    }
    else if (type == 'TAROT_RESULT') {
      // ✅ 타로 결과 조회 로직 호출
      final result = await ref.read(taroRepositoryProvider).getTarotResultDetail(resultId);
      result.fold(
        onSuccess: (entity) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaroResultPage(result: entity)));
        },
        onFailure: (code, msg) => print("타로 조회 실패: $msg"),
      );
    }
  }


  static void _showResultDialog(BuildContext context, WidgetRef ref, String resultId, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("$title 분석 완료!"),
        content: const Text("해석 결과가 도착했습니다. 지금 확인하시겠어요?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("나중에")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기

              // ✅ 중요: title이나 message의 data['type']을 보고 타입을 정함
              final type = title.contains("타로") ? "TAROT_RESULT" : "TEST_RESULT";

              // 공통 네비게이션 로직 호출
              _handleNavigation(context, ref, resultId, type);
            },
            child: const Text("확인하기"),
          ),
        ],
      ),
    );
  }
}