import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/user_profile.dart';

/// 프로필 헤더 위젯
/// 
/// 표시 내용:
/// - 프로필 이미지
/// - 접두어 + 닉네임
/// - 레벨 정보
/// - 프로필 편집 버튼
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
              // 프로필 이미지
              _buildProfileImage(colorScheme),
              
              const SizedBox(width: 16),
              
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 접두어 + 닉네임
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: userProfile.prefix,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: theme.textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: userProfile.nickname,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 레벨 정보
                    _buildLevelInfo(theme, colorScheme),
                  ],
                ),
              ),
              
              // 레벨 뱃지
              _buildLevelBadge(theme, colorScheme),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 활동 요약
          _buildActivitySummary(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onProfileImageTap?.call();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
          ),
          border: Border.all(
            color: colorScheme.surface,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: userProfile.profileImageUrl != null
            ? ClipOval(
                child: Image.network(
                  userProfile.profileImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultAvatar(colorScheme),
                ),
              )
            : _buildDefaultAvatar(colorScheme),
      ),
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Icon(
      Icons.person_rounded,
      size: 40,
      color: colorScheme.onPrimary,
    );
  }

  Widget _buildLevelInfo(ThemeData theme, ColorScheme colorScheme) {
    final progress = (userProfile.level % 10) / 10.0; // Mock 진행률
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level ${userProfile.level}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: colorScheme.surfaceVariant,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiary,
            colorScheme.tertiary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.tertiary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Lv.${userProfile.level}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onTertiary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildActivitySummary(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildActivityItem(
          icon: Icons.edit_note_rounded,
          label: '작성글',
          value: '${userProfile.totalPosts}',
          theme: theme,
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 24),
        _buildActivityItem(
          icon: Icons.chat_bubble_outline_rounded,
          label: '댓글',
          value: '${userProfile.totalComments}',
          theme: theme,
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 24),
        _buildActivityItem(
          icon: Icons.bookmark_outline_rounded,
          label: '북마크',
          value: '${userProfile.bookmarksCount}',
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
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
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
