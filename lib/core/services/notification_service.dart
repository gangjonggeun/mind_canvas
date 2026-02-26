import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/psy_result/presentation/screen/psy_result_screen2.dart';
import '../../features/home/data/repositories/test_repository_provider.dart';
import '../../features/psy_result/data/mapper/test_result_mapper.dart';
import '../../features/taro/data/repositories/taro_repository_impl.dart';
import '../../features/taro/presentation/pages/taro_result_page.dart';

class NotificationHandler {
  static void initialize(BuildContext context, WidgetRef ref) async {
    // 1. 앱이 켜져 있을 때 (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      final type = message.data['type'];
      final resultId = int.tryParse(message.data['resultId']?.toString() ?? '0') ?? 0;

      final errorMessage = message.notification?.body ?? "일시적인 오류로 분석에 실패했습니다.";

      if (type != null) {
        // 🚨 실패 알림인 경우: resultId가 0이어도 바로 에러 팝업 띄움
        if (type == 'TEST_FAILED') {
          _handleNavigation(context, ref, resultId, type, errorMessage: errorMessage);
        }
        // ✅ 성공 알림인 경우: resultId가 0이 아닐 때만 "결과 확인" 다이얼로그 띄움
        else if (resultId != 0) {
          _showResultDialog(context, ref, resultId, type);
        }
      }
    });

    // 2. 앱이 백그라운드에 있다가 알림 클릭으로 열릴 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final type = message.data['type'];
      final resultId = int.tryParse(message.data['resultId']?.toString() ?? '0') ?? 0;

      // 💡 TEST_FAILED 처리를 위해 resultId != 0 조건 삭제
      if (type != null) {
        _handleNavigation(context, ref, resultId, type);
      }
    });

    // 3. 앱이 완전히 종료되었다가 알림 클릭으로 켜질 때
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final type = initialMessage.data['type'];
      final resultId = int.tryParse(initialMessage.data['resultId']?.toString() ?? '0') ?? 0;

      if (type != null) {
        _handleNavigation(context, ref, resultId, type);
      }
    }
  }

  // ✅ 상세 조회 및 이동 로직 (서버 type 기준 분기)
  static void _handleNavigation(BuildContext context, WidgetRef ref, int resultId, String type, {String? errorMessage}) async {
    print("🚀 알림 클릭 이동 시작 - Type: $type, ID: $resultId");

    // 🚨 실패 팝업
    if (type == 'TEST_FAILED') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row( // 💡 const 제거 (Expanded 사용을 위해)
                children:[
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  // 🚀 [핵심] Text를 Expanded로 감싸서 우측 오버플로우 완벽 방지!
                  const Expanded(
                    child: Text(
                      "분석 실패",
                      style: TextStyle(color: Colors.red),
                      overflow: TextOverflow.ellipsis, // 혹시라도 넘치면 ... 처리
                    ),
                  ),
                ],
              ),
              content: Text(
                errorMessage ?? "일시적인 오류로 분석에 실패했습니다.\n사용하신 포인트는 반환되었습니다.",
                style: const TextStyle(height: 1.5),
              ),
              actions:[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("확인")
                )
              ]
          )
      );
      return;
    }
    // ✅ 성공 시 이동
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

  // ✅ 다이얼로그 표시 (성공했을 때만 호출됨)
  static void _showResultDialog(BuildContext context, WidgetRef ref, int resultId, String type) {
    final String title = type == 'TAROT_RESULT' ? "타로 상담" : "심리 테스트";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children:[
            const Icon(Icons.auto_awesome, color: Color(0xFF667EEA)),
            const SizedBox(width: 8),
            // 🚀 [핵심] Text를 Expanded로 감싸서 우측 오버플로우 완벽 방지!
            Expanded(
              child: Text(
                "분석 완료!",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text("분석 결과가 도착했습니다. 지금 확인하시겠어요?"),
        actions:[
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("나중에", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
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