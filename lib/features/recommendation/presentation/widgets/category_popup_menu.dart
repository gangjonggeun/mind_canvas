// =============================================================================
// 🔽 [Widget] 카테고리 선택 팝업 메뉴 (Dropdown Style)
// =============================================================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
class CategoryPopupMenu extends StatelessWidget {
  final String? currentCategory;
  final Function(String?) onCategoryChanged;

  const CategoryPopupMenu({
    super.key,
    required this.currentCategory,
    required this.onCategoryChanged,
  });

  String _getLabel(BuildContext context, String? code) {
    switch (code) {
      case 'CHAT': return S.of(context).post_category_chat;
      case 'QUESTION': return S.of(context).post_category_q;
      case 'REVIEW': return S.of(context).post_category_review;
      default: return S.of(context).category_all;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      surfaceTintColor: Colors.white,

      // ✅ 1. 버튼 모양 수정 (Container로 감싸기)
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        // ⭐ 여기에 child: 를 명시해야 합니다!
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          primary: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getIcon(currentCategory), size: 14, color: Colors.indigo),
              const SizedBox(width: 4),
              Text(
                _getLabel(context, currentCategory),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ), // Container 닫기

      // 2. 펼쳐질 메뉴 아이템들
      itemBuilder: (context) => [
        _buildPopupItem(null, S.of(context).post_category_all, Icons.grid_view),
        _buildPopupItem("CHAT", S.of(context).post_category_chat, Icons.chat_bubble_outline),
        _buildPopupItem("QUESTION", S.of(context).post_category_q, Icons.help_outline),
        _buildPopupItem("REVIEW", S.of(context).post_category_review, Icons.rate_review_outlined),
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