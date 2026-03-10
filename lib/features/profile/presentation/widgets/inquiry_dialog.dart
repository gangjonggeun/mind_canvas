import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../generated/l10n.dart';
import '../../data/models/request/inquiry_request.dart';
import '../providers/profile_notifier.dart';

class InquiryDialog extends ConsumerStatefulWidget {
  const InquiryDialog({super.key});

  @override
  ConsumerState<InquiryDialog> createState() => _InquiryDialogState();
}

// 2. State 클래스는 ConsumerState<위젯이름> 을 상속받습니다.
class _InquiryDialogState extends ConsumerState<InquiryDialog> {

  int _selectedIndex = 0;

  // 카테고리 인덱스 상수 정의 (가독성을 위해)
  static const int INDEX_ERROR = 0;
  static const int INDEX_PAYMENT = 1; // 환불/결제
  static const int INDEX_ORDER = 2;

  // 상태 관리
  String get _selectedCategory => S.of(context).profile_inquiry_report;
   List<String> get _categories => [S.of(context).profile_inquiry_error, S.of(context).profile_inquiry_payment, S.of(context).profile_inquiry_order];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;


  Future<void> _submitToServer() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).profile_inquiry_submit_error)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 📱 앱 버전 가져오기
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';

      // 📱 OS 및 기기 정보 가져오기
      final deviceInfo = DeviceInfoPlugin();
      String osInfo = 'Unknown OS';

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        osInfo = 'iOS ${iosInfo.systemVersion} (${iosInfo.model})'; // 예: iOS 17.1 (iPhone 14 Pro)
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        osInfo = 'Android ${androidInfo.version.release} (${androidInfo.model})'; // 예: Android 14 (SM-S918N)
      }

      final categories = [
        S.of(context).profile_inquiry_error,
        S.of(context).profile_inquiry_payment,
        S.of(context).profile_inquiry_order
      ];

      final selectedCategoryText = categories[_selectedIndex];

      // 📦 Request 객체 생성 (기존에 정의한 InquiryRequest)
      final request = InquiryRequest(
        category: selectedCategoryText,
        title: _titleController.text,
        content: _contentController.text,
        osInfo: osInfo,
        appVersion: appVersion,
      );

      // 🚀 Notifier를 통해 서버로 전송
      final isSuccess = await ref.read(profileNotifierProvider.notifier).submitInquiry(request);

      if (!mounted) return;
      if (isSuccess) {
        Navigator.pop(context); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).profile_inquiry_sucess)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).profile_inquiry_fail)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).profile_inquiry_error_message(e))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(S.of(context).profile_inquiry_title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 카테고리 선택 드롭다운
            DropdownButtonFormField<int>(
              value: _selectedIndex,
              decoration: InputDecoration(
                labelText: S.of(context).profile_inquiry_category,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: List.generate(_categories.length, (index) {
                return DropdownMenuItem<int>( // 여기서도 <int> 명시
                  value: index,              // 여기가 int여야 합니다.
                  child: Text(_categories[index]),
                );
              }),
              onChanged: (int? value) {      // 이제 여기로 들어오는 value는 int입니다.
                if (value != null) {
                  setState(() => _selectedIndex = value);
                }
              },
            ),

            // 환불 선택 시 주의사항 표시
            if (_selectedIndex == INDEX_PAYMENT)  ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Icon(Icons.info_outline, color: Colors.red.shade400, size: 20),
                    const SizedBox(width: 8),
                     Expanded(
                      child: Text(
                        S.of(context).profile_inquiry_report_guide,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: S.of(context).profile_inquiry_title,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: S.of(context).profile_inquiry_content,
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
      actions:[
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child:  Text(S.of(context).profile_inquiry_cancel, style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitToServer,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isLoading
              ? const SizedBox(

              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
          )
              : Text(S.of(context).profile_inquiry_send),
        ),
      ],
    );
  }
}