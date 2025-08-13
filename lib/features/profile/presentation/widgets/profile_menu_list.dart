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
        // 주요 기능 섹션
        Text(
          '내 활동',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuSection([
          _MenuItem(
            id: 'bookmarks',
            icon: Icons.bookmark_rounded,
            title: '북마크',
            subtitle: '저장한 콘텐츠 보기',
            color: colorScheme.primary,
          ),
          _MenuItem(
            id: 'my_records',
            icon: Icons.history_edu_rounded,
            title: '내 기록',
            subtitle: '작성한 글과 댓글',
            color: colorScheme.secondary,
          ),
          _MenuItem(
            id: 'ink_history',
            icon: Icons.receipt_long_rounded,
            title: '잉크 사용 내역',
            subtitle: '충전 및 사용 기록',
            color: colorScheme.tertiary,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // 설정 섹션
        Text(
          '설정',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuSection([
          _MenuItem(
            id: 'theme',
            icon: Icons.palette_rounded,
            title: '테마 설정',
            subtitle: '다크/라이트 모드',
            color: Colors.indigo,
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) => onMenuTap('theme'),
            ),
          ),
          _MenuItem(
            id: 'language',
            icon: Icons.language_rounded,
            title: '언어 설정',
            subtitle: '한국어, English',
            color: Colors.green,
          ),
          _MenuItem(
            id: 'notifications',
            icon: Icons.notifications_rounded,
            title: '알림 설정',
            subtitle: '푸시 알림 관리',
            color: Colors.orange,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // 기타 섹션
        Text(
          '기타',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuSection([
          _MenuItem(
            id: 'help',
            icon: Icons.help_outline_rounded,
            title: '도움말',
            subtitle: '사용법 및 FAQ',
            color: Colors.blue,
          ),
          _MenuItem(
            id: 'settings',
            icon: Icons.settings_rounded,
            title: '고급 설정',
            subtitle: '계정 및 개인정보',
            color: Colors.grey,
          ),
        ], theme, colorScheme),

        const SizedBox(height: 24),

        // 로그아웃
        _buildLogoutButton(theme, colorScheme),
      ],
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

  Widget _buildLogoutButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.logout_rounded,
            color: colorScheme.error,
            size: 24,
          ),
        ),
        title: Text(
          '로그아웃',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '계정에서 로그아웃',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.error.withOpacity(0.7),
          ),
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          onMenuTap('logout');
        },
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
