import 'package:flutter/material.dart';

/// 🎭 카테고리 카드 위젯
/// 
/// 다양한 컨텐츠 카테고리를 표시하는 재사용 가능한 카드 위젯
/// - 여러 스타일 지원
/// - 터치 피드백
/// - 다크모드 지원
class CategoryCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String emoji;
  final Color accentColor;
  final CategoryCardStyle style;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? badge;
  final String? imageUrl;

  const CategoryCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.emoji,
    required this.accentColor,
    this.style = CategoryCardStyle.normal,
    this.onTap,
    this.isSelected = false,
    this.badge,
    this.imageUrl,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildCard(isDark),
      ),
    );
  }

  /// 터치 이벤트 처리
  void _onTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  /// 스타일별 카드 구성
  Widget _buildCard(bool isDark) {
    switch (widget.style) {
      case CategoryCardStyle.normal:
        return _buildNormalCard(isDark);
      case CategoryCardStyle.compact:
        return _buildCompactCard(isDark);
      case CategoryCardStyle.large:
        return _buildLargeCard(isDark);
      case CategoryCardStyle.minimal:
        return _buildMinimalCard(isDark);
      case CategoryCardStyle.gradient:
        return _buildGradientCard(isDark);
    }
  }

  /// 일반 카드 스타일
  Widget _buildNormalCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.accentColor.withOpacity(0.1)
            : (isDark ? const Color(0xFF2D3748) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: widget.isSelected
            ? Border.all(color: widget.accentColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: _isPressed
                ? widget.accentColor.withOpacity(0.2)
                : (isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: _isPressed ? 20 : 10,
            offset: Offset(0, _isPressed ? 8 : 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const Spacer(),
              if (widget.badge != null) widget.badge!,
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.isSelected
                  ? widget.accentColor
                  : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 컴팩트 카드 스타일
  Widget _buildCompactCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.accentColor.withOpacity(0.1)
            : (isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(12),
        border: widget.isSelected
            ? Border.all(color: widget.accentColor)
            : Border.all(
                color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
              ),
      ),
      child: Row(
        children: [
          Text(
            widget.emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected
                        ? widget.accentColor
                        : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
                  ),
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (widget.badge != null) widget.badge!,
        ],
      ),
    );
  }

  /// 큰 카드 스타일
  Widget _buildLargeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.accentColor.withOpacity(0.1)
            : (isDark ? const Color(0xFF2D3748) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: widget.isSelected
            ? Border.all(color: widget.accentColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: _isPressed
                ? widget.accentColor.withOpacity(0.3)
                : (isDark ? Colors.black : Colors.black).withOpacity(0.1),
            blurRadius: _isPressed ? 25 : 15,
            offset: Offset(0, _isPressed ? 10 : 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const Spacer(),
              if (widget.badge != null) widget.badge!,
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.isSelected
                  ? widget.accentColor
                  : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 미니멀 카드 스타일
  Widget _buildMinimalCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.accentColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSelected
              ? widget.accentColor
              : (isDark ? const Color(0xFF4A5568) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          Text(
            widget.emoji,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 12),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? widget.accentColor
                  : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
            ),
          ),
          if (widget.badge != null) ...[
            const Spacer(),
            widget.badge!,
          ],
        ],
      ),
    );
  }

  /// 그라데이션 카드 스타일
  Widget _buildGradientCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.accentColor,
            widget.accentColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withOpacity(0.3),
            blurRadius: _isPressed ? 25 : 15,
            offset: Offset(0, _isPressed ? 10 : 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const Spacer(),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.badge!,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 카테고리 그리드 위젯
class CategoryGrid extends StatelessWidget {
  final List<CategoryData> categories;
  final CategoryCardStyle style;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double? childAspectRatio;
  final String? selectedCategoryId;
  final ValueChanged<String>? onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.style = CategoryCardStyle.normal,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio ?? _getDefaultAspectRatio(),
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          title: category.title,
          subtitle: category.subtitle,
          emoji: category.emoji,
          accentColor: category.accentColor,
          style: style,
          isSelected: selectedCategoryId == category.id,
          badge: category.badge,
          onTap: () => onCategorySelected?.call(category.id),
        );
      },
    );
  }

  /// 스타일별 기본 비율
  double _getDefaultAspectRatio() {
    switch (style) {
      case CategoryCardStyle.compact:
        return 3.0;
      case CategoryCardStyle.large:
        return 1.0;
      case CategoryCardStyle.minimal:
        return 4.0;
      case CategoryCardStyle.gradient:
        return 1.2;
      case CategoryCardStyle.normal:
      default:
        return 1.4;
    }
  }
}

/// 카테고리 카드 스타일 열거형
enum CategoryCardStyle {
  normal,   // 일반 크기
  compact,  // 컴팩트 (가로로 긴)
  large,    // 큰 크기
  minimal,  // 미니멀
  gradient, // 그라데이션
}

/// 카테고리 데이터 모델
class CategoryData {
  final String id;
  final String title;
  final String? subtitle;
  final String emoji;
  final Color accentColor;
  final Widget? badge;
  final String? imageUrl;

  const CategoryData({
    required this.id,
    required this.title,
    this.subtitle,
    required this.emoji,
    required this.accentColor,
    this.badge,
    this.imageUrl,
  });
}
