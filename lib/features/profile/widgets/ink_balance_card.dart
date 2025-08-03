import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 잉크 잔액 카드 위젯
/// 
/// 기능:
/// - 현재 잉크 잔액 표시
/// - 잉크 충전 버튼
/// - 최근 잉크 사용/충전 내역 미리보기
/// - 애니메이션 효과
///
///  // 🎨 아기자기한 파스텔 색상 팔레트
//   static const Map<String, Color> _pastelColors = {
//     'background': Color(0xFFFBF8F5),      // 따뜻한 크림
//     'cardBackground': Color(0xFFF5F2F0),   // 부드러운 베이지
//     'primary': Color(0xFFD4B5A0),          // 따뜻한 라떼 브라운
//     'secondary': Color(0xFFC8B5D1),        // 연보라
//     'accent': Color(0xFFB8D4C8),           // 민트 그린
//     'inkCard': Color(0xFFE8D5C4),          // 연한 피치
//     'statsCard': Color(0xFFD1E2DB),        // 연한 세이지
//     'menuCard': Color(0xFFE6D7E3),         // 연한 라벤더
//     'textPrimary': Color(0xFF5D4E75),      // 부드러운 보라 그레이
//     'textSecondary': Color(0xFF8B7D6B),    // 따뜻한 브라운 그레이
//     'textLight': Color(0xFFA69C94),        // 연한 그레이
//     'shadow': Color(0x1A5D4E75),          // 부드러운 그림자
//     'buttonPrimary': Color(0xFFCDB4DB),    // 연한 라벤더 핑크
//     'buttonSecondary': Color(0xFFA2C5AC),  // 부드러운 세이지
//   };
///
class InkBalanceCard extends StatefulWidget {
  final int inkBalance;
  final VoidCallback? onRecharge;

  const InkBalanceCard({
    super.key,
    required this.inkBalance,
    this.onRecharge,
  });

  @override
  State<InkBalanceCard> createState() => _InkBalanceCardState();
}

class _InkBalanceCardState extends State<InkBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    
    // 주기적으로 shimmer 효과 실행
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _animationController.reset();
            _animationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatInkBalance(int balance) {
    if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(1)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    }
    return balance.toString();
  }

  Color _getInkStatusColor(int balance, ColorScheme colorScheme) {
    if (balance <= 100) {
      return colorScheme.error;
    } else if (balance <= 500) {
      return Colors.orange;
    }
    return colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inkStatusColor = _getInkStatusColor(widget.inkBalance, colorScheme);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              inkStatusColor.withOpacity(0.1),
              inkStatusColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: inkStatusColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: inkStatusColor.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 잉크 아이콘
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        inkStatusColor,
                        inkStatusColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment(-1.0 + _shimmerAnimation.value * 2, 0),
                            end: Alignment(1.0 + _shimmerAnimation.value * 2, 0),
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.colorize_rounded,
                          color: colorScheme.onPrimary,
                          size: 28,
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 잉크 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '잉크 잔액',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _formatInkBalance(widget.inkBalance),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: inkStatusColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'INK',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: inkStatusColor.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 충전 버튼
                _buildRechargeButton(theme, colorScheme, inkStatusColor),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 잉크 상태 메시지
            _buildStatusMessage(theme, colorScheme, inkStatusColor),
            
            const SizedBox(height: 12),
            
            // 빠른 액션 버튼들
            _buildQuickActions(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildRechargeButton(
    ThemeData theme,
    ColorScheme colorScheme,
    Color inkStatusColor,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onRecharge?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              inkStatusColor,
              inkStatusColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: inkStatusColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              color: colorScheme.onPrimary,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '충전',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(
    ThemeData theme,
    ColorScheme colorScheme,
    Color inkStatusColor,
  ) {
    String message;
    IconData icon;
    
    if (widget.inkBalance <= 100) {
      message = '잉크가 부족합니다. 충전을 권장합니다.';
      icon = Icons.warning_rounded;
    } else if (widget.inkBalance <= 500) {
      message = '잉크가 얼마 남지 않았습니다.';
      icon = Icons.info_outline_rounded;
    } else {
      message = '충분한 잉크를 보유하고 있습니다.';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inkStatusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: inkStatusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: inkStatusColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.labelMedium?.copyWith(
                color: inkStatusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.history_rounded,
            label: '사용내역',
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/ink-history');
            },
            theme: theme,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.card_giftcard_rounded,
            label: '보너스',
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/ink-rewards');
            },
            theme: theme,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
