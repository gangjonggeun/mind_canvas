import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 프로필 메뉴 리스트 위젯
/// 
/// 기능:
/// - 북마크, 내 기록 등 주요 기능 접근
/// - 설정 메뉴들
/// - 다크모드, 언어 설정 등
/// - 로그아웃 기능
class ProfileMenuList extends StatelessWidget {
  final Function(String) onMenuTap;

  const ProfileMenuList({
    super.key,
    required this.onMenuTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 내 활동 섹션 ---
        _buildSectionTitle(context, 'profile.menu.section_activity'),
        const SizedBox(height: 12),
        _buildMenuSection([
          // _MenuItem(
          //   id: 'likes',
          //   icon: Icons.favorite_rounded,
          //   title: 'profile.menu.likes'.tr(),
          //   subtitle: 'profile.menu.likes_sub'.tr(),
          //   color: Colors.pinkAccent,
          // ),
          _MenuItem(
            id: 'my_records',
            icon: Icons.history_edu_rounded,
            title: 'profile.menu.my_records'.tr(),
            subtitle: 'profile.menu.my_records_sub'.tr(),
            color: colorScheme.secondary,
          ),
          _MenuItem(
            id: 'ink_history',
            icon: Icons.receipt_long_rounded,
            title: 'profile.menu.ink_history'.tr(),
            subtitle: 'profile.menu.ink_history_sub'.tr(),
            color: colorScheme.tertiary,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // --- 설정 섹션 ---
        _buildSectionTitle(context, 'profile.menu.section_settings'),
        const SizedBox(height: 12),
        _buildMenuSection([
          // 테마 설정은 일단 숨김 처리 (기획 반영)
          _MenuItem(
            id: 'language',
            icon: Icons.language_rounded,
            title: 'profile.menu.language'.tr(),
            subtitle: 'profile.menu.language_sub'.tr(),
            color: Colors.green,
          ),
          _MenuItem(
            id: 'notifications',
            icon: Icons.notifications_rounded,
            title: 'profile.menu.notifications'.tr(),
            subtitle: 'profile.menu.notifications_sub'.tr(),
            color: Colors.orange,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // --- 기타 섹션 ---
        _buildSectionTitle(context, 'profile.menu.section_etc'),
        const SizedBox(height: 12),
        _buildMenuSection([
          _MenuItem(
            id: 'help',
            icon: Icons.help_outline_rounded,
            title: 'profile.menu.help'.tr(),
            subtitle: 'profile.menu.help_sub'.tr(),
            color: Colors.blue,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // 로그아웃 버튼 (다국어 처리)
        _buildLogoutButton(context, theme, colorScheme),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String key) {
    return Text(
      key.tr(),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }


  Widget _buildMenuSection(
    List<_MenuItem> items,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return _buildMenuItem(item, theme, colorScheme, !isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    _MenuItem item,
    ThemeData theme,
    ColorScheme colorScheme,
    bool showDivider,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 24,
            ),
          ),
          title: Text(
            item.title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            item.subtitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: item.trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
          onTap: () {
            HapticFeedback.selectionClick();
            onMenuTap(item.id);
          },
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.1),
            indent: 56,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => onMenuTap('logout'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.error.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.error.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.logout_rounded, color: colorScheme.error),
            const SizedBox(width: 12),
            Text(
              'profile.menu.logout'.tr(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;

  const _MenuItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
  });
}
