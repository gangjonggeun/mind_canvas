import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inquiry_dialog.dart';

class HelpMenuBottomSheet extends StatelessWidget {
  const HelpMenuBottomSheet({super.key});

  // 노션 링크 띄우는 함수
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '고객 지원',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_center_outlined),
            title: const Text('FAQ 및 고객지원 (Notion)'),
            onTap: () {
              Navigator.pop(context);
              _launchUrl('https://your-notion-support-page.com');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('버그 제보 및 환불 문의'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => const InquiryDialog(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('이용약관 및 개인정보처리방침'),
            onTap: () {
              Navigator.pop(context);
              _launchUrl('https://your-notion-terms-page.com');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('오픈소스 라이선스'),
            onTap: () {
              Navigator.pop(context);
              showLicensePage(
                context: context,
                applicationName: 'MindCanvas',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.psychology, size: 64),
              );
            },
          ),
        ],
      ),
    );
  }
}