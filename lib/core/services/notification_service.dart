import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../features/psy_result/presentation/screen/psy_result_screen2.dart';
import '../../features/home/data/repositories/test_repository_provider.dart';
import '../../features/psy_result/data/mapper/test_result_mapper.dart';
import '../../features/taro/data/repositories/taro_repository_impl.dart';
import '../../features/taro/presentation/pages/taro_result_page.dart';

class NotificationHandler {
  static void initialize(BuildContext context, WidgetRef ref) {
    // 1. 앱이 켜져 있을 때 (Foreground)에만 다이얼로그 및 팝업 작동
    FirebaseMessaging.onMessage.listen((message) {
      final type = message.data['type'];
      final resultId = int.tryParse(message.data['resultId']?.toString() ?? '0') ?? 0;
      final errorMessage = message.notification?.body ?? "일시적인 오류로 분석에 실패했습니다.";

      if (type != null) {
        // 🚨 실패 알림인 경우 바로 에러 팝업 띄움
        if (type == 'TEST_FAILED') {
          _handleNavigation(context, ref, resultId, type, errorMessage: errorMessage);
        }
        // ✅ 성공 알림인 경우 resultId가 0이 아닐 때만 "결과 확인" 다이얼로그 띄움
        else if (resultId != 0) {
          _showResultDialog(context, ref, resultId, type);
        }
      }
    });

  }

  // ✅ 상세 조회 및 이동 로직 (포그라운드 다이얼로그에서 '확인하기' 눌렀을 때만 실행됨)
  static Future<void> _handleNavigation(BuildContext parentContext, WidgetRef ref, int resultId, String type, {String? errorMessage}) async {
    if (!kReleaseMode) {
      print("🚀 알림 클릭 이동 시작 - Type: $type, ID: $resultId");
    }

    // 🚨 실패 팝업
    if (type == 'TEST_FAILED') {
      if (!parentContext.mounted) return;
      showDialog(
          context: parentContext,
          builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children:[
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "분석 실패",
                      style: TextStyle(color: Colors.red),
                      overflow: TextOverflow.ellipsis,
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
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("확인")
                )
              ]
          )
      );
      return;
    }

    // ✅ 성공 시 이동 (포그라운드 다이얼로그에서만 호출됨)
    if (type == 'TAROT_RESULT') {
      final result = await ref.read(taroRepositoryProvider).getTarotResultDetail(resultId);

      if (!parentContext.mounted) return; // 💡 비동기 통신 후 Context 생존 확인

      result.fold(
        onSuccess: (entity) {
          Navigator.push(parentContext, MaterialPageRoute(builder: (_) => TaroResultPage(result: entity)));
        },
        onFailure: (code, msg) {
          if (!kReleaseMode) print("❌ 타로 결과 조회 실패: $msg");
        },
      );
    } else if (type == 'TEST_RESULT') {
      final result = await ref.read(testRepositoryProvider).getTestResultDetail(resultId);

      if (!parentContext.mounted) return; // 💡 비동기 통신 후 Context 생존 확인

      result.fold(
        onSuccess: (data) {
          final psyResult = TestResultMapper.toEntity(data);
          Navigator.push(parentContext, MaterialPageRoute(builder: (_) => PsyResultScreen2(result: psyResult)));
        },
        onFailure: (code, msg) {
          if (!kReleaseMode) print("❌ 테스트 결과 조회 실패: $msg");
        },
      );
    }
  }

  // ✅ 다이얼로그 표시 (앱이 켜져 있을 때만 호출됨)
  static void _showResultDialog(BuildContext parentContext, WidgetRef ref, int resultId, String type) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children:[
            Icon(Icons.auto_awesome, color: Color(0xFF667EEA)),
            SizedBox(width: 8),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("나중에", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // 다이얼로그 닫기
              _handleNavigation(parentContext, ref, resultId, type); // 살아있는 parentContext로 이동
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