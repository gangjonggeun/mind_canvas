import 'package:flutter/material.dart';
import '../../domain/enums/rec_category.dart';

extension RecCategoryExtension on RecCategory {
  /// 🎨 카테고리별 테마 색상
  Color get themeColor {
    switch (this) {
      case RecCategory.MOVIE:
        return const Color(0xFF3182CE); // Blue
      case RecCategory.DRAMA:
        return const Color(0xFFE53E3E); // Red
      case RecCategory.GAME:
        return const Color(0xFF00B5D8); // Cyan
      case RecCategory.BOOK:
        return const Color(0xFF805AD5); // Purple
    }
  }

  /// 🖼️ 카테고리별 아이콘
  IconData get icon {
    switch (this) {
      case RecCategory.MOVIE:
        return Icons.movie_rounded;
      case RecCategory.DRAMA:
        return Icons.tv_rounded;
      case RecCategory.GAME:
        return Icons.sports_esports_rounded;
      case RecCategory.BOOK:
        return Icons.menu_book_rounded;
    }
  }
}