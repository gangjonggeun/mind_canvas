
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/response/profile_dto.dart';
import '../providers/profile_notifier.dart';
import 'profile_edit_dialog.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 프로필 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfileSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final summary = state.summary;
    final isLoading = state.isLoading;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 데이터가 로딩 중이고 기존 데이터도 없는 경우
    if (isLoading && summary == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 데이터 로드 실패 혹은 없음
    if (summary == null) {
      return  SizedBox(
        height: 200,
        child: Center(child: Text(S.of(context).profile_header_fail)),
      );
    }

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
              _buildProfileImage(colorScheme, summary),
              const SizedBox(width: 16),
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.nickname,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   'profile.welcome_msg'.tr(),
                    //   style: theme.textTheme.labelMedium?.copyWith(
                    //     color: colorScheme.onSurfaceVariant,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 활동 요약 (작성글, 좋아요 중심)
          _buildActivitySummary(theme, colorScheme, summary),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ColorScheme colorScheme, ProfileSummaryResponse summary) {
    return GestureDetector(
      onTap: () => _showEditDialog(summary.nickname, summary.profileImageUrl),
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
        child: summary.profileImageUrl != null
            ? ClipOval(
                child:
                    Image.network(summary.profileImageUrl!, fit: BoxFit.cover))
            : Icon(Icons.person_rounded,
                size: 40, color: colorScheme.onPrimary),
      ),
    );
  }

  void _showEditDialog(String currentNickname, String? currentImage) {
    showDialog(
      context: context,
      // 다이얼로그 내부에서 상태(이미지 변경 등)를 관리하기 위해 별도 위젯 사용
      builder: (context) => ProfileEditDialog(
        initialNickname: currentNickname,
        initialImageUrl: currentImage,
      ),
    );
  }

  Widget _buildActivitySummary(ThemeData theme, ColorScheme colorScheme,
      ProfileSummaryResponse summary) {
    return Row(
      children: [
        // 2. 심리테스트 (🔥 추가된 부분)
        _buildActivityItem(
          icon: Icons.description_rounded,
          // 적절한 아이콘 추천
          label: S.of(context).profile_header_tested,
          // json 키 사용
          value: '${summary.testCount}',
          // 👈 데이터 연결
          theme: theme,
          colorScheme: colorScheme,
        ),

        _buildActivityItem(
          icon: Icons.edit_note_rounded,
          label: S.of(context).profile_header_post_count,
          value: '${summary.postCount}',
          theme: theme,
          colorScheme: colorScheme,
        ),
        _buildActivityItem(
          icon: Icons.favorite_border_rounded,
          // 북마크 대신 좋아요
          label: S.of(context).profile_header_likes,
          value: '${summary.receivedLikeCount}',
          // Mock
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
