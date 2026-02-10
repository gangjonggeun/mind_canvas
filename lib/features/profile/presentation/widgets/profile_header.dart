import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback? onProfileImageTap;

  const ProfileHeader({
    super.key,
    required this.userProfile,
    this.onProfileImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 프로필 이미지 (디자인 유지)
              _buildProfileImage(colorScheme),
              const SizedBox(width: 16),
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.nickname,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'profile.welcome_msg'.tr(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 활동 요약 (작성글, 좋아요 중심)
          _buildActivitySummary(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onProfileImageTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
          border: Border.all(color: colorScheme.surface, width: 3),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: userProfile.profileImageUrl != null
            ? ClipOval(child: Image.network(userProfile.profileImageUrl!, fit: BoxFit.cover))
            : Icon(Icons.person_rounded, size: 40, color: colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildActivitySummary(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildActivityItem(
          icon: Icons.edit_note_rounded,
          label: 'profile.posts'.tr(),
          value: '${userProfile.totalPosts}',
          theme: theme,
          colorScheme: colorScheme,
        ),
        _buildActivityItem(
          icon: Icons.favorite_border_rounded, // 북마크 대신 좋아요
          label: 'profile.likes'.tr(),
          value: '128', // Mock
          theme: theme,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}