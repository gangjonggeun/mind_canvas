import 'package:flutter/material.dart';

/// 🏷️ 성격 태그 위젯
/// 
/// 성격 특성과 점수를 시각적으로 표시하는 위젯
/// - 메모리 효율적인 구조
/// - 다크모드 지원
/// - 다양한 스타일 지원
class PersonalityTag extends StatelessWidget {
  final String label;
  final double? score;
  final Color? color;
  final PersonalityTagStyle style;
  final VoidCallback? onTap;

  const PersonalityTag({
    super.key,
    required this.label,
    this.score,
    this.color,
    this.style = PersonalityTagStyle.compact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagColor = color ?? Theme.of(context).primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: _getBackgroundColor(tagColor, isDark),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: _getBorder(tagColor, isDark),
        ),
        child: _buildContent(tagColor, isDark),
      ),
    );
  }

  /// 스타일별 패딩
  EdgeInsets _getPadding() {
    switch (style) {
      case PersonalityTagStyle.compact:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case PersonalityTagStyle.normal:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case PersonalityTagStyle.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case PersonalityTagStyle.pill:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  /// 스타일별 테두리 반지름
  double _getBorderRadius() {
    switch (style) {
      case PersonalityTagStyle.compact:
        return 8;
      case PersonalityTagStyle.normal:
        return 12;
      case PersonalityTagStyle.large:
        return 16;
      case PersonalityTagStyle.pill:
        return 20;
    }
  }

  /// 배경색 계산
  Color _getBackgroundColor(Color tagColor, bool isDark) {
    switch (style) {
      case PersonalityTagStyle.compact:
      case PersonalityTagStyle.normal:
      case PersonalityTagStyle.large:
        return tagColor.withOpacity(isDark ? 0.2 : 0.1);
      case PersonalityTagStyle.pill:
        return Colors.white.withOpacity(isDark ? 0.1 : 0.2);
    }
  }

  /// 테두리 계산
  Border? _getBorder(Color tagColor, bool isDark) {
    switch (style) {
      case PersonalityTagStyle.pill:
        return Border.all(
          color: Colors.white.withOpacity(isDark ? 0.2 : 0.3),
        );
      default:
        return null;
    }
  }

  /// 콘텐츠 구성
  Widget _buildContent(Color tagColor, bool isDark) {
    final textColor = style == PersonalityTagStyle.pill 
        ? Colors.white 
        : tagColor;

    switch (style) {
      case PersonalityTagStyle.compact:
        return _buildCompactContent(textColor);
      case PersonalityTagStyle.normal:
        return _buildNormalContent(textColor);
      case PersonalityTagStyle.large:
        return _buildLargeContent(textColor, isDark);
      case PersonalityTagStyle.pill:
        return _buildPillContent(textColor);
    }
  }

  /// 컴팩트 스타일 콘텐츠
  Widget _buildCompactContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        if (score != null) ...[
          const SizedBox(width: 4),
          Text(
            '${(score! * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }

  /// 일반 스타일 콘텐츠
  Widget _buildNormalContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        if (score != null) ...[
          const SizedBox(width: 6),
          Text(
            '${(score! * 100).toInt()}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }

  /// 큰 스타일 콘텐츠
  Widget _buildLargeContent(Color textColor, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        if (score != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: score!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(score! * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 알약 스타일 콘텐츠 (프로필에서 사용)
  Widget _buildPillContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        if (score != null) ...[
          const SizedBox(width: 6),
          Text(
            '${(score! * 100).toInt()}%',
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }
}

/// 성격 태그 여러 개를 보여주는 위젯
class PersonalityTagGroup extends StatelessWidget {
  final List<PersonalityTagData> tags;
  final PersonalityTagStyle style;
  final double spacing;
  final double runSpacing;
  final int? maxLines;

  const PersonalityTagGroup({
    super.key,
    required this.tags,
    this.style = PersonalityTagStyle.normal,
    this.spacing = 8,
    this.runSpacing = 8,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: tags.map((tag) {
        return PersonalityTag(
          label: tag.label,
          score: tag.score,
          color: tag.color,
          style: style,
          onTap: tag.onTap,
        );
      }).toList(),
    );
  }
}

/// 성격 태그 스타일 열거형
enum PersonalityTagStyle {
  compact,  // 작은 크기
  normal,   // 일반 크기
  large,    // 큰 크기 (진행바 포함)
  pill,     // 알약 모양 (프로필용)
}

/// 성격 태그 데이터 모델
class PersonalityTagData {
  final String label;
  final double? score;
  final Color? color;
  final VoidCallback? onTap;

  const PersonalityTagData({
    required this.label,
    this.score,
    this.color,
    this.onTap,
  });
}
