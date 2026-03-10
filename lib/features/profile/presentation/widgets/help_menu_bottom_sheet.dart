import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/l10n.dart';
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).profile_help_support,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_center_outlined),
            title:  Text(S.of(context).profile_help_faq),
            onTap: () {
              Navigator.pop(context);
              _launchUrl('https://your-notion-support-page.com');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: Text(S.of(context).profile_help_report),
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
            title:  Text(S.of(context).profile_help_tac),
            onTap: () {
              Navigator.pop(context);
              _launchUrl('https://your-notion-terms-page.com');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(S.of(context).profile_help_license),
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