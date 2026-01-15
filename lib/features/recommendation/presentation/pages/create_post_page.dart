// 간단한 글쓰기 페이지 구현
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: const Text(
          "새 게시글",
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
                : const Text(
                    "게시",
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
                    hint: const Text("게시판을 선택하세요"),
                    isExpanded: true,
                    items: myChannels.map((channel) {
                      return DropdownMenuItem(
                        value: channel.channel,
                        child: Text(
                          channel.name, // "자유 광장" 등
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
            const Text(
              "카테고리",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCategoryChip("💬 잡담", "CHAT"),
                const SizedBox(width: 8),
                _buildCategoryChip("❓ 질문", "QUESTION"),
                const SizedBox(width: 8),
                _buildCategoryChip("📝 리뷰", "REVIEW"),
              ],
            ),
            const SizedBox(height: 24),

            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "제목을 입력하세요",
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
              decoration: const InputDecoration(
                hintText: "나누고 싶은 이야기를 적어보세요...",
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
          // 선택되면 하얀색, 아니면 약간 진한 색
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedCategory = value);
      },

      // ✅ 선택되었을 때 배경색 (진한 파스텔)
      selectedColor: baseColor,

      // ✅ 선택 안 되었을 때 배경색 (아주 연한 파스텔 or 회색)
      backgroundColor: Colors.grey.shade100,

      // ✅ 체크 아이콘 색상 (하얀색)
      checkmarkColor: Colors.white,

      // 테두리 없애기 (깔끔하게)
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      // 터치 시 물결 효과 색상
      // splashColor: baseColor.withOpacity(0.3),
    );
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (_selectedChannel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("게시글을 작성할 채널을 선택해주세요.")));
      return;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("제목과 내용을 모두 입력해주세요.")));
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
