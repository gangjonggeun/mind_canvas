import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/user_profile.dart';
import '../widgets/profile_header.dart';
import '../widgets/ink_balance_card.dart';
import '../widgets/profile_menu_list.dart';
import '../widgets/stats_section.dart';

/// 프로필 메인 화면
///
/// 기능:
/// - 사용자 프로필 정보 표시
/// - 잉크 잔액 및 충전 기능
/// - 설정 메뉴 접근
/// - 통계 정보 표시
/// - 북마크 및 내 기록 접근
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock 데이터 - 실제로는 Provider/BLoC에서 가져옴
  final UserProfile _userProfile = const UserProfile(
    id: 'user_001',
    nickname: '창의적인 몽상가',
    prefix: '자신감있는',
    profileImageUrl: null,
    inkBalance: 1250,
    level: 7,
    totalPosts: 42,
    totalComments: 156,
    bookmarksCount: 23,
    isDarkMode: false,
    language: 'ko',
    notificationsEnabled: true,
    lastLoginAt: null,      // ✅ 추가
    createdAt: null,        // ✅ 추가
  );

  final UserStats _userStats = const UserStats(
    postsThisMonth: 12,
    commentsThisMonth: 48,
    inkEarnedThisMonth: 350,
    streakDays: 7,
    totalActiveDays: 89,
  );

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // 햅틱 피드백
    HapticFeedback.lightImpact();

    // 실제로는 데이터 새로고침 로직
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('프로필이 업데이트되었습니다'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onInkRecharge() {
    HapticFeedback.selectionClick();
    // 잉크 충전 화면으로 이동
    Navigator.pushNamed(context, '/ink-recharge');
  }

  void _onMenuTap(String menuId) {
    HapticFeedback.selectionClick();

    switch (menuId) {
      case 'bookmarks':
        Navigator.pushNamed(context, '/bookmarks');
        break;
      case 'my_records':
        Navigator.pushNamed(context, '/my-records');
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'theme':
        _toggleTheme();
        break;
      case 'language':
        Navigator.pushNamed(context, '/language-settings');
        break;
      case 'notifications':
        Navigator.pushNamed(context, '/notification-settings');
        break;
      case 'ink_history':
        Navigator.pushNamed(context, '/ink-history');
        break;
      case 'help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _toggleTheme() {
    // 실제로는 ThemeProvider를 통해 테마 변경
    setState(() {
      // _userProfile = _userProfile.copyWith(isDarkMode: !_userProfile.isDarkMode);
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // 로그아웃 로직
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          '프로필',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/profile-edit');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 프로필 헤더
                  ProfileHeader(
                    userProfile: _userProfile,
                    onProfileImageTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, '/profile-image');
                    },
                  ),

                  const SizedBox(height: 24),

                  // 잉크 잔액 카드
                  InkBalanceCard(
                    inkBalance: _userProfile.inkBalance,
                    onRecharge: _onInkRecharge,
                  ),

                  const SizedBox(height: 24),

                  // 통계 섹션
                  StatsSection(
                    userStats: _userStats,
                    userProfile: _userProfile,
                  ),

                  const SizedBox(height: 24),

                  // 메뉴 리스트
                  ProfileMenuList(
                    onMenuTap: _onMenuTap,
                  ),

                  const SizedBox(height: 32),

                  // 앱 정보
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Mind Canvas',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v1.0.0',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
