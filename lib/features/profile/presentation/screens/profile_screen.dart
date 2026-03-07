import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:mind_canvas/features/profile/presentation/pages/liked_posts_page.dart';
import 'package:mind_canvas/features/profile/presentation/pages/my_activity_page.dart';

import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ✅ Provider 임포트 (경로는 실제 프로젝트에 맞게 확인해주세요)
// import '../../../../core/providers/app_language_provider.dart';
// import '../providers/profile_notifier.dart';

import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../../../core/auth/auth_storage.dart';
import '../../../../core/providers/app_language_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../data/models/user_profile.dart';
import '../../domain/usecases/profile_usecase_provider.dart';
import '../providers/ink_history_provider.dart';
import '../providers/profile_notifier.dart';
import '../widgets/help_menu_bottom_sheet.dart';
import '../widgets/profile_header.dart';
import '../widgets/ink_balance_card.dart';
import '../widgets/profile_menu_list.dart';
import '../widgets/stats_section.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // ✅ 화면이 처음 열릴 때 서버에서 프로필 정보(잉크 잔액 등) 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfileSummary();
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();

    // ✅ 당겨서 새로고침 시 서버에서 데이터 다시 불러오기
    await ref.read(profileNotifierProvider.notifier).loadProfileSummary();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('프로필이 업데이트되었습니다').tr(), // 다국어 적용
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onInkRecharge() {
    HapticFeedback.selectionClick();
    _showInkRechargeDialog(context, ref);
  }

  void _onMenuTap(String menuId) {
    HapticFeedback.selectionClick();
    switch (menuId) {
      case 'delete_account':
        _showDeleteAccountDialog();
        break;
      case 'my_records':
        context.pushNamed('my_activity');
        break;
      case 'ink_history':
        _showInkHistoryBottomSheet();
        break;
      case 'language':
        _showLanguageDialog(); // ✅ 언어 설정 다이얼로그 호출
        break;
      case 'notifications':
        _showNotificationDialog();
        break;
      case 'help':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const HelpMenuBottomSheet(), // 아까 만든 그 위젯
        );
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showInkHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        // ✅ 높이를 화면의 70%로 강제 지정
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // 핸들 바
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('잉크 사용 내역',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // ✅ Expanded가 없으면 리스트가 0픽셀이 되어 안 보일 수 있음!
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final historyState = ref.watch(inkHistoryNotifierProvider);

                  return historyState.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),

                    // 에러 발생 시 UI에 에러 메시지 표시
                    error: (err, stack) => Center(child: Text('오류 발생: $err')),

                    data: (historyList) {
                      if (historyList.isEmpty) {
                        return const Center(
                            child: Text('잉크 사용 내역이 없습니다.',
                                style: TextStyle(color: Colors.grey)));
                      }

                      return ListView.separated(
                        itemCount: historyList.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = historyList[index];
                          // CHARGE(충전) 또는 AD_REWARD(광고 보상) 이면 파란색(+)
                          final isCharge =
                              item.type == 'CHARGE' || item.type == 'AD_REWARD';

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            leading: CircleAvatar(
                              backgroundColor: isCharge
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              child: Icon(
                                isCharge ? Icons.add : Icons.remove,
                                color: isCharge ? Colors.blue : Colors.red,
                              ),
                            ),
                            title: Text(item.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              // 서버에서 오는 LocalDateTime을 예쁘게 포맷팅
                              DateFormat('yyyy.MM.dd HH:mm')
                                  .format(item.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isCharge ? '+' : ''}${item.amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isCharge ? Colors.blue : Colors.red,
                                  ),
                                ),
                                Text('잔액: ${item.balanceAfter}',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // 🚪 업그레이드된 로그아웃 로직 (게스트 체크)
  // ==============================================================
  void _showLogoutDialog() async {
    print("🛑[LOGOUT FLOW] 1. 다이얼로그 띄우기 시작");

    final currentUser = ref.read(userNotifierProvider);
    final isGuest = currentUser == null || (currentUser.email.isEmpty);

    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: true, // 🛡️ [핵심 방어 1] 다이얼로그를 최상단에 띄움
      builder: (dialogContext) => AlertDialog(
        title: const Text('로그아웃'),
        content: Text(
          '정말 로그아웃하시겠습니까?',
          style: TextStyle(
            color: isGuest ? Colors.red.shade700 : null,
            fontWeight: isGuest ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
              onPressed: () {
                print("🛑 [LOGOUT FLOW] 2-1. 취소 버튼 클릭");
                // 🛡️[핵심 방어 2] 오직 다이얼로그만 확실히 닫음
                Navigator.of(dialogContext, rootNavigator: true).pop(false);
              },
              child: const Text('취소')),
          FilledButton(
            style: isGuest
                ? FilledButton.styleFrom(backgroundColor: Colors.red)
                : null,
            onPressed: () {
              print("🛑 [LOGOUT FLOW] 2-2. 로그아웃 버튼 클릭");
              Navigator.of(dialogContext, rootNavigator: true).pop(true);
            },
            child: Text(isGuest ? '기록 지우고 나가기' : '로그아웃'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      print("🛑 [LOGOUT FLOW] 3. 로그아웃 취소됨 (종료)");
      return;
    }

    print("🛑 [LOGOUT FLOW] 4. 다이얼로그 닫히는 애니메이션 대기 (300ms)");
    await Future.delayed(const Duration(milliseconds: 300));

    print("🛑 [LOGOUT FLOW] 5. AuthNotifier.logout() 호출 직전");
    if (context.mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
    }
    print("🛑 [LOGOUT FLOW] 6. UI 쪽 함수 완전 종료! (이제 라우터가 알아서 함)");
  }

  //  계정 삭제
  void _showDeleteAccountDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('계정 탈퇴', style: TextStyle(color: Colors.red)),
        content: const Text('정말 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('탈퇴하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // 취소했으면 종료
    if (confirm != true) return;

    // 1. (선택사항) 다이얼로그가 완전히 닫힐 애니메이션 시간 0.2초 여유 주기
    await Future.delayed(const Duration(milliseconds: 200));

    // 2. 탈퇴 로직 실행
    // 🚨 주의: AuthNotifier의 deleteAccount() 내부에는 state = AsyncLoading(); 이 절대 없어야 합니다!
    final result =
        await ref.read(authNotifierProvider.notifier).deleteAccount();

    // 3. 🎯 Result 클래스의 fold 메서드 사용!
    result.fold(onSuccess: (_) {
      // 성공 시: 이미 AuthNotifier에서 state=null 이 되어 GoRouter가 /login으로 보냈음.
      // 따라서 화면 이동 코드를 적을 필요가 전혀 없음!
      print("✅ 탈퇴 성공");
    }, onFailure: (msg, code) {
      // 실패 시: 화면 이동이 없으므로 스낵바를 띄워줌
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('탈퇴 실패: $msg')));
      }
    });
  }

  // ==============================================================
  // 🌐 언어 설정 로직 (UI + Riverpod )
  // ==============================================================
  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '언어 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildLanguageTile('한국어', 'ko'),
            _buildLanguageTile('English', 'en'),
            // _buildLanguageTile('日本語', 'ja'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String title, String code) {
    // 현재 선택된 언어 확인
    final currentLang = ref.watch(appLanguageProvider);
    final isSelected = currentLang == code;
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: () async {
        Navigator.pop(context); // 바텀시트 닫기

        // ✅ 1. 가장 먼저 Provider 상태를 업데이트 (UI 상태와 Hive 저장소 업데이트)
        // 이 코드가 없어서 현재 UI가 갱신되지 않았던 것입니다.
        await ref.read(appLanguageProvider.notifier).setLanguage(code);

        // 2. EasyLocalization 로컬 언어 즉시 변경 (UI 텍스트 변경)
        await context.setLocale(Locale(code));

        // 3. 서버 통신 (필요 시)
        // 만약 ProfileNotifier 내부에서 다시 appLanguageProvider를 참조하고 있다면
        // 굳이 순서가 꼬이지 않도록 주의해야 합니다.
        await ref.read(profileNotifierProvider.notifier).changeLanguage(code);
      },
    );
  }

  // ==============================================================
  // 기타 다이얼로그 (알림, 로그아웃)
  // ==============================================================
  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('profile.menu.notifications'.tr()),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SwitchListTile(
              title: const Text('푸시 알림 수신'),
              value: true,
              onChanged: (val) {
                setDialogState(() {});
              },
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('확인')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ 프로필 상태 구독 (데이터 및 로딩 상태)
    final profileState = ref.watch(profileNotifierProvider);

    // ✅ 에러 발생 시 스낵바 띄우기 (listen 사용)
    ref.listen(profileNotifierProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // 🚨 뒤로가기(백버튼) 완벽히 제거
        title: Text(
          '프로필', // 나중에 'profile.title'.tr() 로 변경 가능
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        // 탭바의 루트 화면이므로 좌측 정렬이 트렌디함
        actions: [
          // 🚨 편집 버튼 대신 알림(종) 아이콘으로 변경
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                color: colorScheme.onSurface),
            onPressed: () {
              HapticFeedback.lightImpact();
              // Navigator.pushNamed(context, '/notifications');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 프로필 헤더 (닉네임, 프사 등)
              ProfileHeader(),

              const SizedBox(height: 24),

              //잉크 잔액
              InkBalanceCard(
                inkBalance: profileState.summary?.inkBalance ?? 0,
                dailyAdCount: profileState.summary?.dailyAdCount ?? 0,
                // ✅ 데이터 전달
                onRecharge: () => _showInkRechargeDialog(context, ref),
                onWatchAd: _onWatchAdTap, // ✅ 광고 버튼 핸들러 연결
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
                      'Mind-Color Canvas',
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
    );
  }

// 프로필 화면에서 호출할 때: _showInkRechargeDialog(context, ref);
  void _showInkRechargeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎨 팔레트 이미지 적용
              Image.asset(
                'assets/images/icon/coin_palette_256.webp',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                '잉크가 부족하신가요?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '마인드 캔버스의 모든 심리테스트를\n자유롭게 즐겨보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // 🎁 1. 무료 충전 (광고 보기)
              _buildRechargeOption(
                context: context,
                ref: ref,
                title: '무료 잉크 받기',
                subtitle: '동영상 광고 시청',
                priceText: '무료',
                iconColor: Colors.purple,
                onTap: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  _watchAdForReward(context, ref); // 광고 로직 호출
                }, assetPath: 'assets/images/icon/coin_palette_128.webp',
              ),
              const Divider(height: 24),

              // 💳 2. 유료 충전 옵션들
              _buildRechargeOption(
                context: context,
                ref: ref,
                title: '잉크 한 줌 (100개)',
                subtitle: '가볍게 시작하기',
                priceText: '₩ 1,000',
                iconColor: Colors.blue,
                onTap: () => _startPayment(context, ref, "ink_100"),
                assetPath: 'assets/images/icon/coin_palette_128.webp',
              ),
              const SizedBox(height: 8),
              _buildRechargeOption(
                context: context,
                ref: ref,
                title: '잉크 보따리 (500개)',
                subtitle: '가장 많이 선택해요',
                priceText: '₩ 4,500',
                iconColor: Colors.blue,
                isBest: true,
                onTap: () => _startPayment(context, ref, "ink_500"),
                assetPath: 'assets/images/icon/coin_palette_128.webp',
              ),
              const SizedBox(height: 8),
              _buildRechargeOption(
                context: context,
                ref: ref,
                title: '잉크 드럼통 (1000개)',
                subtitle: '마음껏 분석하기',
                priceText: '₩ 8,000',
                iconColor: Colors.blue,
                onTap: () => _startPayment(context, ref, "ink_1000"),
                assetPath: 'assets/images/icon/coin_palette_128.webp',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRechargeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required String priceText,
    required String assetPath,
    required Color iconColor,
    required VoidCallback onTap,
    bool isBest = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isBest ? Colors.blue : Colors.grey.shade300,
              width: isBest ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
          color: isBest ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Image.asset(assetPath, width: 32, height: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isBest ? Colors.blue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(priceText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

// 💳 결제 로직 (UI에서 아이템 클릭 시 실행)
  Future<void> _startPayment(
      BuildContext context, WidgetRef ref, String packageIdentifier) async {
    // 1. 사용자에게 결제 대기 중임을 알리는 로딩 인디케이터 띄우기
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 2. RevenueCat 서버에서 현재 활성화된 상품(Offerings) 목록 가져오기
    Offerings offerings = await Purchases.getOfferings();

    if (offerings.current != null) {
      // 3. 내가 구매하려는 식별자(예: "100_coins")와 일치하는 상품 찾기
      Package? packageToBuy;
      try {
        packageToBuy = offerings.current!.availablePackages.firstWhere(
          (pkg) => pkg.identifier == packageIdentifier,
        );
      } catch (e) {
        packageToBuy = null; // 매칭되는 상품이 없을 경우
      }

      // ✨ 4. 상품이 null이 아닐 때만 안전하게 네이티브 결제창 호출
      if (packageToBuy != null) {
        try {
          // 1. 네이티브 결제창 호출! (FaceID / 지문 인식)
          // (사용하시는 패키지 버전에 맞춰 result.customerInfo 형태로 꺼내시면 됩니다)
          PurchaseResult result = await Purchases.purchasePackage(packageToBuy);
          CustomerInfo customerInfo = result.customerInfo;

          if (!context.mounted) return;
          Navigator.pop(context); // 로딩창 닫기

          // 💡 2. CustomerInfo 검증 (핵심)
          // 잉크(소모품)의 경우 nonSubscriptionTransactions(구독이 아닌 일반 결제 내역) 배열에
          // 방금 결제한 상품의 identifier가 추가되었는지 확인합니다.

          final hasPurchased = customerInfo.nonSubscriptionTransactions.any(
              (transaction) =>
                  transaction.productIdentifier ==
                  packageToBuy?.storeProduct.identifier);

          if (hasPurchased) {
            // 3. 결제 내역이 확인되었을 때만 서버에 핑 날리기!
            await ref
                .read(inkHistoryNotifierProvider.notifier)
                .syncPurchaseWithServer();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('결제 성공! 잉크가 충전되었습니다.')),
            );
          } else {
            // 결제는 진행됐으나 아직 RevenueCat 서버에 반영 안 된 상태 (결제 지연 등)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('결제가 처리 중입니다. 잠시 후 확인해주세요.')),
            );
          }
        } on PlatformException catch (e) {
          if (!context.mounted) return;
          Navigator.pop(context); // 로딩창 닫기

          // 유저가 결제를 스스로 취소한 경우 (에러 아님)
          if (PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError) {
            print('사용자가 결제를 취소했습니다.');
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('결제 실패: ${e.message}')));
          }
        }
      }
    }
  }

  void _watchAdForReward(BuildContext context, WidgetRef ref) {
    // 1. 로딩 표시
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    // 2. 보상형 광고 로드 (실제 출시는 애드몹에서 발급받은 ID 사용, 아래는 구글 테스트 ID)
    final adUnitId = 'ca-app-pub-3940256099942544/5224354917';

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          Navigator.pop(context); // 로딩 닫기

          // 3. 광고 재생
          ad.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
            // 💡 유저가 광고를 끝까지 봤을 때 실행되는 곳! (여기서 서버로 보상 요청을 보냅니다)

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()));

            // TODO: 서버의 '광고 보상 API' 호출
            final result =
                await ref.read(profileUseCaseProvider).claimAdReward();

            Navigator.pop(context); // 로딩 닫기
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('광고 시청 완료! 잉크 20개가 지급되었습니다.')));
            ref.read(userNotifierProvider.notifier).refreshProfile(); // 잔액 갱신
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          Navigator.pop(context); // 로딩 닫기
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('광고를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.')));
        },
      ),
    );
  }

  void _onWatchAdTap() {
    final summary = ref.read(profileNotifierProvider).summary;
    final int currentAds = summary?.dailyAdCount ?? 0;

    if (currentAds >= 5) {
      _showMaxAdDialog(); // "오늘 치 다 봤어요" 알림 다이얼로그
      return;
    }

    // ✅ 확인 다이얼로그 (여기서 취소/광고보기 결정)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('무료 잉크 충전'),
        content: Text('광고를 시청하고 20 잉크를 받으시겠습니까?\n(오늘 시청 횟수: $currentAds/5)'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫고
              _watchAdForReward(context, ref); // ✅ 실제 광고 로드 및 시청
            },
            child: const Text('광고 보기'),
          ),
        ],
      ),
    );
  }

  void _showMaxAdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            // ✅ 체크 아이콘으로 "완료됨"을 시각적으로 표시
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.green.shade400, size: 48),
            const SizedBox(height: 16),
            const Text(
              '오늘의 충전 완료',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          '오늘 제공되는 5번의 무료 잉크를\n모두 받으셨습니다!\n\n내일 자정에 다시 충전됩니다.',
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('확인'),
            ),
          ),
        ],
      ),
    );
  }
}
