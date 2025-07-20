import 'package:flutter/material.dart';

/// 🎭 재사용 가능한 추천 카드 위젯
/// 
/// 다양한 컨텐츠 추천에 공통으로 사용할 수 있는 카드 위젯
/// - 메모리 효율적인 구조
/// - 다크모드 지원
/// - 커스터마이징 가능한 액션 버튼
class RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String? imageUrl;
  final String emoji;
  final Color accentColor;
  final double? similarity;
  final List<String> tags;
  final String? reason;
  final VoidCallback? onTap;
  final List<Widget>? actionButtons;
  final Widget? header;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.imageUrl,
    required this.emoji,
    required this.accentColor,
    this.similarity,
    this.tags = const [],
    this.reason,
    this.onTap,
    this.actionButtons,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3748) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 커스텀 헤더 또는 기본 헤더
            header ?? _buildDefaultHeader(isDark),
            const SizedBox(height: 16),
            
            // 설명
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? const Color(0xFFCBD5E0) : const Color(0xFF4A5568),
                height: 1.4,
              ),
            ),
            
            // 추천 이유 (있는 경우)
            if (reason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reason!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // 태그들 (있는 경우)
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            // 액션 버튼들 (있는 경우)
            if (actionButtons != null) ...[
              const SizedBox(height: 16),
              Row(
                children: actionButtons!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 기본 헤더 구성
  Widget _buildDefaultHeader(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (similarity != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  size: 14,
                  color: accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${(similarity! * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
