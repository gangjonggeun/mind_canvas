import 'package:flutter/material.dart';

/// 컨텐츠 타입 열거형
enum ContentType { movie, drama, music }

/// 📱 컨텐츠 카테고리 탭 위젯
/// 
/// 성능 최적화:
/// - StatefulWidget으로 내부 상태 관리
/// - 불필요한 상위 위젯 rebuild 방지
class ContentTabs extends StatefulWidget {
  final ContentType selectedType;
  final Function(ContentType) onTypeChanged;

  const ContentTabs({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  State<ContentTabs> createState() => _ContentTabsState();
}

class _ContentTabsState extends State<ContentTabs> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildContentTab('🎬 영화', ContentType.movie),
          const SizedBox(width: 12),
          _buildContentTab('📺 드라마', ContentType.drama),
          const SizedBox(width: 12),
          _buildContentTab('🎵 음악', ContentType.music),
        ],
      ),
    );
  }

  /// 컨텐츠 카테고리 탭 빌더
  Widget _buildContentTab(String title, ContentType type) {
    final bool isSelected = widget.selectedType == type;
    return GestureDetector(
      onTap: () => widget.onTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4ECDC4) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
