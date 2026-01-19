import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final int userId;
  final double radius;

  const UserProfileAvatar({
    super.key,
    this.imageUrl,
    required this.userId,
    this.radius = 18,
  });

  // userId를 기반으로 고유한 파스텔 색상 결정 (랜덤이지만 고정됨)
  Color _getBackgroundColor(int id) {
    final colors = [
      const Color(0xFFEF9A9A), // Red
      const Color(0xFFF48FB1), // Pink
      const Color(0xFFCE93D8), // Purple
      const Color(0xFFB39DDB), // Deep Purple
      const Color(0xFF9FA8DA), // Indigo
      const Color(0xFF90CAF9), // Blue
      const Color(0xFF80CBC4), // Teal
      const Color(0xFFA5D6A7), // Green
      const Color(0xFFE6EE9C), // Lime
      const Color(0xFFFFCC80), // Orange
      const Color(0xFFBCAAA4), // Brown
      const Color(0xFFB0BEC5), // Blue Grey
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // ✅ null 이거나, 빈 문자열이거나, 공백만 있는 경우 체크
    bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(imageUrl!),
        // 로딩 에러 시 아이콘으로 대체하는 방어 코드 추가
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    // 이미지 없으면 랜덤 컬러 + 아이콘
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getBackgroundColor(userId),
      child: Icon(Icons.person, size: radius * 1.2, color: Colors.white),
    );
  }
}
