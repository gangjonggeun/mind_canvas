// 간단한 글쓰기 페이지 구현
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../provider/channel_notifier.dart';
import '../provider/post_notifier.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'CHAT'; // 기본값 (Enum String과 일치해야 함)
  bool _isSubmitting = false;
  String? _selectedChannel;

  @override
  Widget build(BuildContext context) {
    // 내 채널 목록 가져오기
    final channelState = ref.watch(channelNotifierProvider);
    final myChannels = channelState.myChannels;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).post_add_new_post,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                :  Text(
                    S.of(context).post_add_post_btn,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // value가 null이면 '힌트'가 보임
                    value: _selectedChannel,
                    hint:  Text(S.of(context).post_add_select_post),
                    isExpanded: true,
                    items: myChannels.map((channel) {
                      String displayName = channel.name;
                      if (channel.channel == 'FREE') {
                        displayName = S.of(context).post_add_all_chanel; // 'Free 채널' 대신 이걸로 표시
                      }
                      return DropdownMenuItem(
                        value: channel.channel,
                        child: Text(
                          displayName, // "자유 광장" 등
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedChannel = value;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 카테고리 선택 (Chip)
             Text(
              S.of(context).post_add_category,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCategoryChip(S.of(context).post_add_chat, "CHAT"),
                const SizedBox(width: 8),
                _buildCategoryChip(S.of(context).post_add_q, "QUESTION"),
                const SizedBox(width: 8),
                _buildCategoryChip(S.of(context).post_add_review, "REVIEW"),
              ],
            ),
            const SizedBox(height: 24),

            // 제목 입력
            TextField(
              controller: _titleController,
              decoration:  InputDecoration(
                hintText: S.of(context).post_add_enter_title,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // 내용 입력
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 8,
              decoration:  InputDecoration(
                hintText: S.of(context).post_add_enter_content,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;

    // 🎨 카테고리별 파스텔 색상 정의
    Color getBaseColor() {
      switch (value) {
        case 'CHAT':
          return const Color(0xFF81C784); // 파스텔 그린 (잡담)
        case 'QUESTION':
          return const Color(0xFFFFB74D); // 파스텔 오렌지 (질문)
        case 'REVIEW':
          return const Color(0xFF64B5F6); // 파스텔 블루 (리뷰)
        default:
          return Colors.black;
      }
    }

    final baseColor = getBaseColor();

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      selectedColor: baseColor,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCategory = value;

            // 💡 다국어(S.of) 처리를 위해 상수를 빼지 않고 내부에 선언
            // 필요에 따라 '제목', '장르' 부분을 S.of(context).xxx 로 치환하시면 됩니다.
            final String reviewTemplate = S.of(context).post_add_review_templete;

            // 1. 리뷰 카테고리를 눌렀고, 현재 내용이 비어있다면 템플릿 삽입
            if (value == 'REVIEW') {
              if (_contentController.text.trim().isEmpty) {
                _contentController.text = reviewTemplate;
              }
            }
            // 2. 다른 카테고리로 바꿨는데, 내용이 '템플릿 그대로'라면 지워줌 (UX 디테일)
            else {
              if (_contentController.text == reviewTemplate) {
                _contentController.text = '';
              }
            }
          });
        }
      },
    );
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (_selectedChannel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text(S.of(context).post_add_select_chanal_info)));
      return;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text(S.of(context).post_add_enter_content_info)));
      return;
    }

    setState(() => _isSubmitting = true);

    // ✅ [수정] createPost 호출 시 selectedChannel 전달
    final success = await ref
        .read(postNotifierProvider.notifier)
        .createPost(
          channel: _selectedChannel!, // 선택된 채널 (String? 타입)
          title: title,
          content: content,
          category: _selectedCategory,
        );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context); // 성공 시 닫기
    } else if (mounted) {
      // 에러 메시지는 Notifier 상태를 통해 보여주거나, 여기서 간단히 처리
      final errorMsg = ref.read(postNotifierProvider).errorMessage;
      if (errorMsg != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }
}
