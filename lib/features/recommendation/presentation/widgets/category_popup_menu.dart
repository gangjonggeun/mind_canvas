// =============================================================================
// 🔽 [Widget] 카테고리 선택 팝업 메뉴 (Dropdown Style)
// =============================================================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CategoryPopupMenu extends StatelessWidget {
  final String? currentCategory;
  final Function(String?) onCategoryChanged;

  const CategoryPopupMenu({
    super.key,
    required this.currentCategory,
    required this.onCategoryChanged,
  });

  String _getLabel(String? code) {
    switch (code) {
      case 'CHAT': return '잡담';
      case 'QUESTION': return '질문';
      case 'REVIEW': return '후기';
      default: return '전체';
    }
  }

  IconData _getIcon(String? code) {
    switch (code) {
      case 'CHAT': return Icons.chat_bubble_outline;
      case 'QUESTION': return Icons.help_outline;
      case 'REVIEW': return Icons.rate_review_outlined;
      default: return Icons.grid_view;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      onSelected: onCategoryChanged,
      elevation: 3,
      // 메뉴 창도 버튼 스타일에 맞춰 조금 더 각지게 (16 -> 12)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      surfaceTintColor: Colors.white,

      // ✅ 1. 버튼 모양 수정 (작고 네모나게)
      child: Container(
        // 패딩을 줄여서 전체 높이를 낮춤
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          // 둥글기(Radius)를 줄여서 '네모' 느낌 추가 (20 -> 8)
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘 크기 축소 (16 -> 14)
            Icon(_getIcon(currentCategory), size: 14, color: Colors.indigo),
            const SizedBox(width: 4),
            // 텍스트 크기 축소 (13 -> 12)
            Text(
              _getLabel(currentCategory),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 2),
            // 화살표 크기 축소
            const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
          ],
        ),
      ),

      // 2. 펼쳐질 메뉴 아이템들 (기존 유지)
      itemBuilder: (context) => [
        _buildPopupItem(null, "전체", Icons.grid_view),
        _buildPopupItem("CHAT", "잡담", Icons.chat_bubble_outline),
        _buildPopupItem("QUESTION", "질문", Icons.help_outline),
        _buildPopupItem("REVIEW", "후기", Icons.rate_review_outlined),
      ],
    );
  }

  PopupMenuItem<String?> _buildPopupItem(String? value, String label, IconData icon) {
    final isSelected = currentCategory == value;
    return PopupMenuItem<String?>(
      value: value,
      height: 40, // 메뉴 아이템 높이도 살짝 컴팩트하게
      child: Row(
        children: [
          Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.indigo : Colors.grey.shade600
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.indigo : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}