import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/psy_result/presentation/screen/psy_result_screen2.dart';

import '../../features/home/data/repositories/test_repository_provider.dart';
import '../../features/psy_result/data/mapper/test_result_mapper.dart';
import '../../features/taro/data/repositories/taro_repository_impl.dart';
import '../../features/taro/presentation/pages/taro_result_page.dart';

class NotificationHandler {
  static void initialize(BuildContext context, WidgetRef ref) async {
    // 1. 앱이 켜져 있을 때 (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      final type = message.data['type'];
      final resultId = message.data['resultId'];
      if (type != null && resultId != null) {
        // ✅ title 대신 type을 넘깁니다.
        _showResultDialog(context, ref, resultId, type);
      }
    });

    // 2. 앱이 백그라운드에 있다가 알림 클릭으로 열릴 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final type = message.data['type'];
      final resultId = message.data['resultId'];
      if (type != null && resultId != null) {
        _handleNavigation(context, ref, resultId, type);
      }
    });

    // 3. 앱이 완전히 종료되었다가 알림 클릭으로 켜질 때
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final type = initialMessage.data['type'];
      final resultId = initialMessage.data['resultId'];
      if (type != null && resultId != null) {
        _handleNavigation(context, ref, resultId, type);
      }
    }
  }

  // ✅ 상세 조회 및 이동 로직 (서버 type 기준 분기)
  static void _handleNavigation(BuildContext context, WidgetRef ref, int resultId, String type) async {
    print("🚀 알림 클릭 이동 시작 - Type: $type, ID: $resultId");

    if (type == 'TAROT_RESULT') {
      final result = await ref.read(taroRepositoryProvider).getTarotResultDetail(resultId);
      result.fold(
        onSuccess: (entity) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaroResultPage(result: entity)));
        },
        onFailure: (code, msg) => print("❌ 타로 결과 조회 실패: $msg"),
      );
    } else if (type == 'TEST_RESULT') {
      final result = await ref.read(testRepositoryProvider).getTestResultDetail(resultId);
      result.fold(
        onSuccess: (data) {
          final psyResult = TestResultMapper.toEntity(data);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PsyResultScreen2(result: psyResult)));
        },
        onFailure: (code, msg) => print("❌ 테스트 결과 조회 실패: $msg"),
      );
    }
  }

  // ✅ 다이얼로그 표시 (type에 따라 제목 자동 결정)
  static void _showResultDialog(BuildContext context, WidgetRef ref, int resultId, String type) {
    // type에 따른 UI 텍스트 결정
    final String title = type == 'TAROT_RESULT' ? "타로 상담" : "심리 테스트";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("$title 분석 완료!"),
        content: const Text("분석 결과가 도착했습니다. 지금 확인하시겠어요?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("나중에", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              // ✅ 받은 type을 그대로 다음 단계로 전달
              _handleNavigation(context, ref, resultId, type);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
            ),
            child: const Text("확인하기"),
          ),
        ],
      ),
    );
  }
}