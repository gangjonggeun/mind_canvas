import 'package:flutter/material.dart';




class AiAnalysisHelper {
  static void showPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫기 금지
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.mark_email_read_rounded, size: 50, color: Color(0xFF3182CE)),
            SizedBox(height: 16),
            Text('분석 시작!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'AI가 답변을 정밀 분석하고 있습니다.\n(약 20초~1분 소요)\n\n분석이 완료되면 알림으로 알려드릴게요!',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {

              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3182CE),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('확인', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}





