import 'package:flutter/material.dart';

/// 📊 유사도 표시 위젯
/// 
/// 성격 유사도나 컨텐츠 일치도를 시각적으로 표시하는 위젯
/// - 다양한 표시 스타일 지원
/// - 애니메이션 효과
/// - 다크모드 지원
class SimilarityIndicator extends StatefulWidget {
  final double percentage;
  final String? label;
  final SimilarityStyle style;
  final Color? color;
  final bool showAnimation;
  final VoidCallback? onTap;

  const SimilarityIndicator({
    super.key,
    required this.percentage,
    this.label,
    this.style = SimilarityStyle.badge,
    this.color,
    this.showAnimation = true,
    this.onTap,
  });

  @override
  State<SimilarityIndicator> createState() => _SimilarityIndicatorState();
}

class _SimilarityIndicatorState extends State<SimilarityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    if (widget.showAnimation) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );

      _animation = Tween<double>(
        begin: 0.0,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      // 약간의 지연 후 애니메이션 시작
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indicatorColor = widget.color ?? _getColorByPercentage(widget.percentage);

    return GestureDetector(
      onTap: widget.onTap,
      child: _buildIndicator(isDark, indicatorColor),
    );
  }

  /// 스타일별 위젯 구성
  Widget _buildIndicator(bool isDark, Color indicatorColor) {
    switch (widget.style) {
      case SimilarityStyle.badge:
        return _buildBadgeStyle(indicatorColor);
      case SimilarityStyle.progress:
        return _buildProgressStyle(isDark, indicatorColor);
      case SimilarityStyle.circular:
        return _buildCircularStyle(isDark, indicatorColor);
      case SimilarityStyle.heart:
        return _buildHeartStyle(indicatorColor);
      case SimilarityStyle.compact:
        return _buildCompactStyle(indicatorColor);
    }
  }

  /// 배지 스타일
  Widget _buildBadgeStyle(Color indicatorColor) {
    final displayPercentage = widget.showAnimation 
        ? _animation.value 
        : widget.percentage;

    return AnimatedBuilder(
      animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: indicatorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: indicatorColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 14,
                color: indicatorColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${(displayPercentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: indicatorColor,
                ),
              ),
              if (widget.label != null) ...[
                const SizedBox(width: 4),
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontSize: 11,
                    color: indicatorColor.withOpacity(0.8),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 진행바 스타일
  Widget _buildProgressStyle(bool isDark, Color indicatorColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                ),
                child: AnimatedBuilder(
                  animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
                  builder: (context, child) {
                    final displayPercentage = widget.showAnimation 
                        ? _animation.value 
                        : widget.percentage;
                    
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: displayPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: indicatorColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
              builder: (context, child) {
                final displayPercentage = widget.showAnimation 
                    ? _animation.value 
                    : widget.percentage;
                
                return Text(
                  '${(displayPercentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: indicatorColor,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 원형 진행바 스타일
  Widget _buildCircularStyle(bool isDark, Color indicatorColor) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
            ),
          ),
          // 진행 원
          AnimatedBuilder(
            animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
            builder: (context, child) {
              final displayPercentage = widget.showAnimation 
                  ? _animation.value 
                  : widget.percentage;
              
              return SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: displayPercentage,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                  backgroundColor: Colors.transparent,
                ),
              );
            },
          ),
          // 중앙 텍스트
          AnimatedBuilder(
            animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
            builder: (context, child) {
              final displayPercentage = widget.showAnimation 
                  ? _animation.value 
                  : widget.percentage;
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(displayPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                    ),
                  ),
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: 8,
                        color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// 하트 스타일
  Widget _buildHeartStyle(Color indicatorColor) {
    return AnimatedBuilder(
      animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
      builder: (context, child) {
        final displayPercentage = widget.showAnimation 
            ? _animation.value 
            : widget.percentage;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(5, (index) {
              final heartValue = (index + 1) * 0.2;
              final isFilled = displayPercentage >= heartValue;
              final isPartial = displayPercentage > (index * 0.2) && 
                              displayPercentage < heartValue;
              
              return Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  isFilled || isPartial ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: isFilled 
                      ? indicatorColor 
                      : isPartial 
                          ? indicatorColor.withOpacity(0.5)
                          : indicatorColor.withOpacity(0.2),
                ),
              );
            }),
            if (widget.label != null) ...[
              const SizedBox(width: 8),
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 12,
                  color: indicatorColor,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  /// 컴팩트 스타일
  Widget _buildCompactStyle(Color indicatorColor) {
    return AnimatedBuilder(
      animation: widget.showAnimation ? _animation : kAlwaysCompleteAnimation,
      builder: (context, child) {
        final displayPercentage = widget.showAnimation 
            ? _animation.value 
            : widget.percentage;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: indicatorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${(displayPercentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: indicatorColor,
            ),
          ),
        );
      },
    );
  }

  /// 퍼센티지에 따른 색상 계산
  Color _getColorByPercentage(double percentage) {
    if (percentage >= 0.8) return const Color(0xFF38A169); // 초록
    if (percentage >= 0.6) return const Color(0xFFD69E2E); // 노랑
    if (percentage >= 0.4) return const Color(0xFFED8936); // 주황
    return const Color(0xFFE53E3E); // 빨강
  }
}

/// 여러 유사도를 비교해서 보여주는 위젯
class SimilarityComparison extends StatelessWidget {
  final List<SimilarityData> similarities;
  final String? title;

  const SimilarityComparison({
    super.key,
    required this.similarities,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...similarities.map((similarity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SimilarityIndicator(
                percentage: similarity.percentage,
                label: similarity.label,
                style: SimilarityStyle.progress,
                color: similarity.color,
                showAnimation: true,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// 유사도 스타일 열거형
enum SimilarityStyle {
  badge,    // 배지 형태
  progress, // 진행바 형태
  circular, // 원형 진행바
  heart,    // 하트 형태
  compact,  // 컴팩트 형태
}

/// 유사도 데이터 모델
class SimilarityData {
  final String label;
  final double percentage;
  final Color? color;

  const SimilarityData({
    required this.label,
    required this.percentage,
    this.color,
  });
}
