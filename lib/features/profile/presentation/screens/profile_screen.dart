import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:mind_canvas/features/profile/presentation/pages/liked_posts_page.dart';
import 'package:mind_canvas/features/profile/presentation/pages/my_activity_page.dart';
import 'package:mind_canvas/features/profile/presentation/screens/InkRechargeScreen.dart';
import 'package:portone_flutter/iamport_payment.dart';
import 'package:portone_flutter/model/payment_data.dart';

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
        _showDeleteAccountDialog(context, ref);
        break;
      case 'my_records':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyActivityPage()));
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
      // launchUrl(Uri.parse('https://your-notion-support-page.com'));
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
                                isCharge
                                    ? Icons.add
                                    : Icons.remove,
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
  void _showLogoutDialog() {
    // 현재 유저 정보 가져오기 (예: UserNotifierProvider 등에서)

    final currentUser = ref.read(userNotifierProvider);
    final isGuest = currentUser == null || (currentUser.email.isEmpty);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGuest ? '게스트 로그아웃' : '로그아웃'),
        content: Text(
          isGuest
              ? '게스트 상태에서 로그아웃하시면\n지금까지의 분석 기록과 잉크가 모두 초기화됩니다.\n\n정말 로그아웃하시겠습니까?'
              : '정말 로그아웃하시겠습니까?',
          style: TextStyle(
            color: isGuest ? Colors.red.shade700 : null, // 게스트면 빨간색 경고
            fontWeight: isGuest ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('취소')),
          FilledButton(
            style: isGuest
                ? FilledButton.styleFrom(backgroundColor: Colors.red)
                : null,
            onPressed: () async {
              // 1. 다이얼로그 닫기
              Navigator.pop(context);

              // 2. [핵심] 성공 여부와 상관없이 무조건 로컬 토큰 삭제부터 진행
              // 이래야 서버 에러로 무한로딩 걸릴 일이 없음
              await AuthStorage.clearAll();

              // 3. 로딩 인디케이터 표시
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              // 4. 서버 로그아웃 API 호출 (성공/실패 따지지 않음)
              try {
                await ref.read(authNotifierProvider.notifier).logout();
              } catch (e) {
                print("서버 로그아웃 API 호출 에러 (무시함): $e");
              }

              // 5. 로딩창 닫기
              if (context.mounted) Navigator.pop(context);

              // 6. 무조건 로그인 화면으로 이동
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: Text(isGuest ? '기록 지우고 나가기' : '로그아웃'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 탈퇴', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('정말 탈퇴하시겠습니까?\n\n탈퇴 시 모든 정보가 삭제되며, 게시글은 "알 수 없는 사용자"로 남게 됩니다. 이 작업은 되돌릴 수 없습니다.'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('탈퇴하기', style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 로딩 인디케이터 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // 🎯 [수정됨] UseCase 대신 AuthNotifier의 deleteAccount 호출
    final result = await ref.read(authNotifierProvider.notifier).deleteAccount();

    // 로딩 다이얼로그 닫기
    if (context.mounted) Navigator.pop(context);

    result.fold(
      onSuccess: (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('계정이 성공적으로 삭제되었습니다.')));
          // 성공 시 모든 스택 지우고 로그인 창으로!
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      onFailure: (msg, _) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('탈퇴 실패: $msg')));
        }
      },
    );
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

        // 1. EasyLocalization 로컬 언어 즉시 변경 (UI 텍스트 변경)
        await context.setLocale(Locale(code));

        // 2. 서버 통신 및 Hive 저장 (ProfileNotifier에서 알아서 다 해줌!)
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
                dailyAdCount: profileState.summary?.dailyAdCount ?? 0, // ✅ 데이터 전달
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
            children:[
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
                icon: Icons.play_circle_fill,
                iconColor: Colors.purple,
                onTap: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  _watchAdForReward(context, ref); // 광고 로직 호출
                },
              ),
              const Divider(height: 24),

              // 💳 2. 유료 충전 옵션들
              _buildRechargeOption(
                context: context, ref: ref,
                title: '잉크 한 줌 (100개)', subtitle: '가볍게 시작하기', priceText: '₩ 1,000',
                icon: Icons.water_drop, iconColor: Colors.blue,
                onTap: () => _startPayment(context, ref, 1000, '잉크 100개'),
              ),
              const SizedBox(height: 8),
              _buildRechargeOption(
                context: context, ref: ref,
                title: '잉크 보따리 (500개)', subtitle: '가장 많이 선택해요', priceText: '₩ 4,500',
                icon: Icons.water_drop, iconColor: Colors.blue, isBest: true,
                onTap: () => _startPayment(context, ref, 4500, '잉크 500개'),
              ),
              const SizedBox(height: 8),
              _buildRechargeOption(
                context: context, ref: ref,
                title: '잉크 드럼통 (1000개)', subtitle: '마음껏 분석하기', priceText: '₩ 8,000',
                icon: Icons.water_drop, iconColor: Colors.blue,
                onTap: () => _startPayment(context, ref, 8000, '잉크 1000개'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRechargeOption({
    required BuildContext context, required WidgetRef ref, required String title,
    required String subtitle, required String priceText, required IconData icon,
    required Color iconColor, required VoidCallback onTap, bool isBest = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isBest ? Colors.blue : Colors.grey.shade300, width: isBest ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
          color: isBest ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children:[
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isBest ? Colors.blue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(priceText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

// 💳 결제 로직 (다이얼로그 닫힌 후 실행됨)
  void _startPayment(BuildContext context, WidgetRef ref, int price, String itemName) {
    Navigator.pop(context); // 충전 다이얼로그 닫기

    final userCode = dotenv.env['PORTONE_USER_CODE'] ?? 'imp00000000';
    final merchantUid = 'mid_${DateTime.now().millisecondsSinceEpoch}';
    final user = ref.read(userNotifierProvider);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IamportPayment(
          appBar: AppBar(title: const Text('결제하기')),
          userCode: userCode,
          data: PaymentData(
            pg: 'html5_inicis', payMethod: 'card', name: itemName, merchantUid: merchantUid, amount: price,
            buyerName: user?.nickname ?? 'Guest', buyerEmail: user?.email ?? '', appScheme: 'mindcanvas', buyerTel: '',
          ),
          callback: (Map<String, String> result) {
            Navigator.pop(context); // 결제창 닫기
            if (result['success'] == 'true') {
              _verifyOnServer(context, ref, merchantUid, result['imp_uid'] ?? '');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('결제 취소: ${result['error_msg']}')));
            }
          },
        ),
      ),
    );
  }


  // 서버 검증 (기존 로직 유지)
  Future<void> _verifyOnServer(
      BuildContext context, WidgetRef ref, String merchantUid, String portoneId) async {

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final result = await ref.read(profileUseCaseProvider).verifyPayment(merchantUid, portoneId);

    if (context.mounted) Navigator.pop(context);

    result.fold(
      onSuccess: (_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('충전 완료!'), backgroundColor: Colors.blue),
        );
        await ref.read(userNotifierProvider.notifier).refreshProfile();
        if (context.mounted) Navigator.pop(context);
      },
      onFailure: (msg, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $msg'), backgroundColor: Colors.red),
        );
      },
    );
  }



  void _watchAdForReward(BuildContext context, WidgetRef ref) {
    // 1. 로딩 표시
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    // 2. 보상형 광고 로드 (실제 출시는 애드몹에서 발급받은 ID 사용, 아래는 구글 테스트 ID)
    final adUnitId = 'ca-app-pub-3940256099942544/5224354917';

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          Navigator.pop(context); // 로딩 닫기

          // 3. 광고 재생
          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
            // 💡 유저가 광고를 끝까지 봤을 때 실행되는 곳! (여기서 서버로 보상 요청을 보냅니다)

            showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

            // TODO: 서버의 '광고 보상 API' 호출
            final result = await ref.read(profileUseCaseProvider).claimAdReward();

            Navigator.pop(context); // 로딩 닫기
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('광고 시청 완료! 잉크 20개가 지급되었습니다.')));
            ref.read(userNotifierProvider.notifier).refreshProfile(); // 잔액 갱신
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          Navigator.pop(context); // 로딩 닫기
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('광고를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.')));
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
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
            Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade400, size: 48),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
