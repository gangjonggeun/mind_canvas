import 'dart:io'; // File 사용을 위해 필요
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/l10n.dart';
import '../providers/profile_notifier.dart'; // 패키지 import

class ProfileEditDialog extends ConsumerStatefulWidget {
  final String initialNickname;
  final String? initialImageUrl;

  const ProfileEditDialog({
    required this.initialNickname,
    this.initialImageUrl,
  });

  @override
  ConsumerState<ProfileEditDialog> createState() => ProfileEditDialogState();
}

class ProfileEditDialogState extends ConsumerState<ProfileEditDialog> {
  late TextEditingController _nicknameController;
  final ImagePicker _picker = ImagePicker();

  File? _pickedImage; // 갤러리에서 선택한 로컬 파일
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 📸 갤러리에서 이미지 선택
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      print('이미지 선택 실패: $e');
    }
  }

  /// 💾 저장 버튼 클릭 시
  Future<void> _onSave() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    setState(() => _isUploading = true);

    String? finalImageUrl = widget.initialImageUrl;

    // 1. 이미지를 새로 선택했다면 서버에 업로드하여 URL을 받아와야 함
    if (_pickedImage != null) {
      // ⚠️ 중요: 현재 Repository에는 파일 업로드 기능이 없습니다.
      // 실제로는 여기서 `uploadProfileImage(_pickedImage!)` API를 호출해야 합니다.
      // 예: finalImageUrl = await ref.read(uploadUseCaseProvider).uploadImage(_pickedImage!);

      // (임시) UI 동작 확인을 위해 로컬 패스가 아닌, 업로드가 필요하다는 로그만 남김
      print('⚠️ [TODO] 서버 업로드 API 연동 필요: ${_pickedImage!.path}');

      // 만약 서버가 Base64를 받는다면 변환해서 보낼 수도 있지만, 보통은 URL을 받습니다.
      // 일단은 기존 URL을 유지하거나, 업로드 로직 구현 후 교체해야 합니다.
    }

    // 2. 프로필 정보 업데이트 (닉네임 + 이미지URL)
    final success = await ref.read(profileNotifierProvider.notifier).updateProfile(
      nickname: nickname,
      imageFile: _pickedImage, // 갤러리에서 선택한 파일 (없으면 null)
    );

    setState(() => _isUploading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profile_edit_sucess),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profile_edit_fail )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).profile_edit_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🖼️ 이미지 미리보기 및 변경 버튼
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade300),
                    image: _getDecorationImage(),
                  ),
                  child: (_pickedImage == null && widget.initialImageUrl == null)
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                // 카메라 아이콘
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 📝 닉네임 입력
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: S.of(context).profile_edit_nickname,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            maxLength: 15,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).profile_edit_cancel, style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isUploading ? null : _onSave,
          child: _isUploading
              ? const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2)
          )
              : Text(S.of(context).profile_edit_save),
        ),
      ],
    );
  }

  /// 이미지 소스 결정 (로컬 파일 vs 네트워크 URL)
  DecorationImage? _getDecorationImage() {
    if (_pickedImage != null) {
      return DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover);
    }
    if (widget.initialImageUrl != null) {
      return DecorationImage(image: NetworkImage(widget.initialImageUrl!), fit: BoxFit.cover);
    }
    return null;
  }
}