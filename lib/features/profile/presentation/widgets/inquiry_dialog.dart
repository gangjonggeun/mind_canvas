import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/models/request/inquiry_request.dart';
import '../providers/profile_notifier.dart';

class InquiryDialog extends ConsumerStatefulWidget {
  const InquiryDialog({super.key});

  @override
  ConsumerState<InquiryDialog> createState() => _InquiryDialogState();
}

// 2. State 클래스는 ConsumerState<위젯이름> 을 상속받습니다.
class _InquiryDialogState extends ConsumerState<InquiryDialog> {
  // 상태 관리
  String _selectedCategory = '버그 제보';
  final List<String> _categories =['버그 제보', '환불 문의', '기타'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;
  //
  // // 디스코드 웹훅 전송 로직
  // Future<void> _sendToDiscord() async {
  //   if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
  //     );
  //     return;
  //   }
  //
  //   setState(() => _isLoading = true);
  //
  //   // TODO: 디스코드 채널 설정 -> 연동 -> 웹훅 URL 만들기에서 발급받은 URL 넣기
  //   // 보안을 원한다면 Flutter -> Spring Boot Server -> Discord 로 넘기는 것이 가장 좋습니다.
  //   const String webhookUrl = 'https://discord.com/api/webhooks/YOUR/WEBHOOK_URL';
  //
  //   try {
  //     final dio = Dio();
  //
  //     // 디스코드 Embed 메세지 포맷으로 예쁘게 쏘기
  //     await dio.post(webhookUrl, data: {
  //       "content": "🚨 **새로운 고객 문의가 접수되었습니다!**",
  //       "embeds":[
  //         {
  //           "title": _titleController.text,
  //           "description": _contentController.text,
  //           "color": 16711680, // 빨간색 계열
  //           "fields":[
  //             {
  //               "name": "카테고리",
  //               "value": _selectedCategory,
  //               "inline": true
  //             },
  //             {
  //               "name": "OS / App Version",
  //               "value": "iOS / 1.0.0", // 나중에 device_info_plus 패키지로 동적 할당
  //               "inline": true
  //             }
  //           ],
  //           "timestamp": DateTime.now().toUtc().toIso8601String(),
  //         }
  //       ]
  //     });
  //
  //     if (!mounted) return;
  //     Navigator.pop(context); // 다이얼로그 닫기
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('문의가 성공적으로 접수되었습니다.')),
  //     );
  //
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('전송에 실패했습니다: $e')),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _submitToServer() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('제목과 내용을 입력해주세요.')));
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

      // 📦 Request 객체 생성 (기존에 정의한 InquiryRequest)
      final request = InquiryRequest(
        category: _selectedCategory,
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('문의가 성공적으로 접수되었습니다.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('접수에 실패했습니다. 다시 시도해주세요.')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
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
      title: const Text('문의하기', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 카테고리 선택 드롭다운
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: '문의 유형',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),

            // 환불 선택 시 주의사항 표시
            if (_selectedCategory == '환불 문의') ...[
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
                    const Expanded(
                      child: Text(
                        '앱스토어 정책상 인앱 결제 환불은 개발자가 직접 처리할 수 없습니다.\n기기의 스토어 결제 내역에서 환불을 요청해 주세요.',
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
                labelText: '제목',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: '내용을 자세히 적어주세요.',
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
          child: const Text('취소', style: TextStyle(color: Colors.grey)),
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
              : const Text('보내기'),
        ),
      ],
    );
  }
}