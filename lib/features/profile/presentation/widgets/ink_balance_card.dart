import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InkBalanceCard extends StatelessWidget {
  final int inkBalance;
  final VoidCallback? onRecharge;

  const InkBalanceCard({
    super.key,
    required this.inkBalance,
    this.onRecharge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
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
              // 커스텀 WebP 아이콘 적용
              Container(
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon/coin_palette_128.webp',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              // 잉크 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile.ink_balance'.tr(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${inkBalance.toString()} INK',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              // 충전 버튼 (디자인 유지)
              _buildRechargeButton(theme, colorScheme, primaryColor),
            ],
          ),
          const SizedBox(height: 20),
          // 퀵 액션 버튼 (상태 메시지 삭제됨)
          _buildQuickActions(context, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildRechargeButton(ThemeData theme, ColorScheme colorScheme, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onRecharge?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Text(
          'profile.recharge'.tr(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.history_rounded,
            label: 'profile.usage_history'.tr(),
            onTap: () => Navigator.pushNamed(context, '/ink-history'),
            theme: theme,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.ads_click_rounded,
            label: 'profile.watch_ad'.tr(), // 텍스트 변경
            onTap: () {
              HapticFeedback.selectionClick();
              // 광고 로직
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}