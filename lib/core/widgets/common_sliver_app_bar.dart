import 'package:flutter/material.dart';

class CommonSliverAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor; // 아이콘 색상 (지정 안 하면 기본 색상)
  final double expandedHeight;

  const CommonSliverAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.expandedHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 배경 및 텍스트 색상 정의
    final bgColorStart = isDark ? const Color(0xFF2D3748) : const Color(0xFFF8FAFC);
    final bgColorEnd = isDark ? const Color(0xFF1A202C) : const Color(0xFFF1F5F9);
    final titleColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subtitleColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    // 아이콘 기본 색상은 브랜드 컬러(보라/블루 계열) 사용
    final effectiveIconColor = iconColor ?? const Color(0xFF667EEA);

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: bgColorStart, // 스크롤 시 상단 고정 색상
      scrolledUnderElevation: 0,     // 스크롤 시 색상 변경 방지
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero, // 기본 타이틀 패딩 제거
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgColorStart, bgColorEnd],
            ),
          ),
          child: Padding(
            // ✅ [핵심] 왼쪽 여백을 24px로 넉넉하게 주어 안정감 확보
            padding: const EdgeInsets.only(left: 24, right: 20, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ [디자인] 박스 없이 아이콘만 깔끔하게
                    Icon(
                      icon,
                      color: effectiveIconColor,
                      size: 30, // 텍스트 크기에 맞춰 적절히 조절
                    ),
                    const SizedBox(width: 12), // 아이콘과 텍스트 간격

                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0), // 서브텍스트 살짝 들여쓰기
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}