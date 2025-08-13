import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_canvas/features/profile/domain/usecases/profile_usecase.dart';

import '../../../../app/main_screen.dart';
import '../../../../core/theme/app_colors.dart';
// 🎯 Profile 관련 import 추가
import '../../../profile/domain/usecases/profile_usecase_provider.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/enums/login_type.dart'; // ✅ LoginType용
import '../providers/auth_provider.dart';
/// 🎨 Mind Canvas 미니멀 로그인 스크린
///
/// **미니멀 디자인 특징:**
/// - 카드 없는 깔끔한 인터페이스
/// - 메모리 효율적인 Widget 구조
/// - CPU 최적화된 애니메이션
/// - 네트워크 최적화된 이미지 로딩
/// - 보안 강화된 인증 플로우
/// - 다국어 지원 준비
/// - 다크모드 호환성
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const String _logTag = 'LoginScreen';


  bool _isProcessing = false;


  // 🎮 단일 애니메이션 컨트롤러로 최적화
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 🌐 현재 언어 상태
  String _currentLanguage = 'KO';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🎬 메모리 효율적인 애니메이션 초기화
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  /// 🚀 애니메이션 시작
  void _startAnimations() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 인증 상태 리스너
    ref.listen<AsyncValue<AuthUser?>>(authNotifierProvider, (previous, next) {


      print("🔍 listen 호출됨!");
      print("🔍 previous: $previous");
      print("🔍 next: $next");
      print("🔍 next.value?.nickname: ${next.value?.nickname}");

      next.whenData((user) {
        print("🔍 whenData 진입 - user: $user");
        if (user != null) {
          print("🔍 user.nickname: ${user.nickname}");
          if (user.nickname == null) {
            print("🔍 닉네임 다이얼로그 표시 예정");
            _showNicknameDialog(context);
          } else {
            print("🔍 메인 화면으로 이동 예정");
            _handleLoginSuccess(user);
          }
        }
      });

      next.whenOrNull(
        error: (error, stackTrace) {
          print("❌ listen에서 에러: $error");
          _showErrorSnackBar(error.toString());
        },
      );
    });

    return Scaffold(
      // backgroundColor: AppColors.backgroundPrimary,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildMinimalContent(),
      ),
    );
  }

  /// 📱 미니멀한 메인 콘텐츠 (카드 없음)
  Widget _buildMinimalContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            // 🌐 언어 변경 버튼
            SliverToBoxAdapter(
              child: _buildLanguageButton(),
            ),

            // 🎨 로고 섹션
            SliverToBoxAdapter(
              child: _buildLogoSection(),
            ),

            // 📝 타이틀 섹션
            SliverToBoxAdapter(
              child: _buildTitleSection(),
            ),

            // 🔑 로그인 버튼들 (카드 없이 직접 배치)
            SliverToBoxAdapter(
              child: _buildDirectLoginButtons(),
            ),

            // 📝 하단 약관 텍스트
            SliverToBoxAdapter(
              child: _buildFooterSection(),
            ),

            // 🚀 추가 여백
            SliverToBoxAdapter(
              child: SizedBox(height: 40.h),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌐 언어 변경 버튼 (우상단 고정)
  Widget _buildLanguageButton() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, right: 20.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: _LanguageButton(
          currentLanguage: _currentLanguage,
          onLanguageChanged: _handleLanguageChange,
        ),
      ),
    );
  }

  /// 🎨 로고 섹션 (메모리 최적화)
  Widget _buildLogoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Center(
        child: _LogoWidget(),
      ),
    );
  }

  /// 📝 타이틀 섹션
  Widget _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
      child: Column(
        children: [
          Text(
            '마음색 캔버스에서',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Text(
            '당신의 마음색을 그려보세요',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🔑 카드 없는 직접 로그인 버튼들
  Widget _buildDirectLoginButtons() {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading; // AsyncValue는

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w), // 좌우 여백 유지
      child: Column(
        children: [
          // 2. '다양한 플랫폼으로~' 텍스트는 그대로 두거나, 디자인에 맞춰 제거/수정 가능
          Text(
            '다양한 플랫폼으로 간편하게 로그인하세요',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(24.h),

          // 3. 색상이 추가될 로그인 버튼들 (아래에서 스타일 수정)
          _LoginButton(
            icon: Icons.g_mobiledata,
            // 실제로는 Google 로고 아이콘 사용 권장
            label: 'Google로 로그인',
            onPressed: isLoading ? null : _handleGoogleLogin,
            isLoading: isLoading,
            // 여기에 새로운 색상 스타일을 적용할 예정
            backgroundColor: const Color(0xFF4285F4),
            // Google Blue
            foregroundColor: Colors.white,
          ),
          Gap(12.h),
          _LoginButton(
            icon: Icons.apple,
            label: 'Apple로 로그인',
            onPressed: isLoading ? null : _handleAppleLogin,
            isLoading: isLoading,
            backgroundColor: Colors.black,
            // Apple Black
            foregroundColor: Colors.white,
          ),

          // 구분선 (단순 텍스트로 변경)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 35.h),
            child: Text(
              '또는',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 익명 로그인 (새로운 위젯으로 교체)
          _MinimalAnonymousLoginButton(
            onPressed: isLoading ? null : _handleAnonymousLogin,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  /// 🎯 구분선
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
      ],
    );
  }

  /// 📝 하단 약관 섹션
  Widget _buildFooterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Text(
        '계속을 클릭하면 당사의 서비스 이용 약관 및 개인정보 처리방침에 동의하는 것으로 간주됩니다.', // 텍스트 변경
        style: TextStyle(
          fontSize: 11.sp,
          color: AppColors.textTertiary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ===== 🎯 이벤트 핸들러들 =====

  /// 🌐 언어 변경 핸들러
  void _handleLanguageChange() {
    setState(() {
      _currentLanguage = _currentLanguage == 'KO' ? 'EN' : 'KO';
    });

    // 햅틱 피드백
    HapticFeedback.lightImpact();

    // 성공 메시지
    _showSuccessSnackBar('언어가 $_currentLanguage로 변경되었습니다');
  }

  /// 🌐 Google 로그인 핸들러 (AuthNotifier를 통해 실행)
  Future<void> _handleGoogleLogin() async {
    debugPrint('[$_logTag] Google 로그인 시도');
    HapticFeedback.selectionClick();


    await ref.read(authNotifierProvider.notifier).googleLogin();
  }


  /// 🍎 Apple 로그인 핸들러
  Future<void> _handleAppleLogin() async {
    // debugPrint('[$_logTag] Apple 로그인 시도');
    // HapticFeedback.selectionClick();
    //
    // try {
    //   final result = await ref.read(authNotifierProvider.notifier).appleLogin(
    //     identityToken: 'mock_identity_token',
    //     authorizationCode: 'mock_auth_code',
    //   );
    //
    //   if (result.isFailure) {
    //     _showErrorSnackBar(result.errorMessage ?? 'Apple 로그인에 실패했습니다');
    //   }
    // } catch (e) {
    //   debugPrint('[$_logTag] Apple 로그인 오류: $e');
    //   _showErrorSnackBar('네트워크 오류가 발생했습니다');
    // }
  }

  /// 🔍 익명 로그인 핸들러
  Future<void> _handleAnonymousLogin() async {
    // debugPrint('[$_logTag] 익명 로그인 시도');
    // HapticFeedback.selectionClick();
    //
    // try {
    //   final result = await ref.read(authNotifierProvider.notifier).anonymousLogin();
    //
    //   if (result.isFailure) {
    //     _showErrorSnackBar(result.errorMessage ?? '익명 로그인에 실패했습니다');
    //   }
    // } catch (e) {
    //   debugPrint('[$_logTag] 익명 로그인 오류: $e');
    //   _showErrorSnackBar('네트워크 오류가 발생했습니다');
    // }
  }

  // 📍 LoginScreen의 _showNicknameDialog 메서드 수정

  /// 📝 닉네임 설정 다이얼로그 (UseCase 연동)
  Future<void> _showNicknameDialog(BuildContext context) async {
    final TextEditingController nicknameController = TextEditingController();

    final String? nickname = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          StatefulBuilder(
            builder: (context, setState) {
              // 유효성 검사 로직 (기존과 동일)
              String? validationError;
              Widget? feedbackIcon;
              Color borderColor = AppColors.primaryBlueDark;

              void validateNickname(String nickname) {
                final bool wasValid = validationError == null;
                final RegExp validPattern = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]*$');

                if (nickname.isNotEmpty && nickname.length < 3) {
                  validationError = '3글자 이상 입력해주세요.';
                } else if (nickname.length > 12) {
                  validationError = '12자 이하로 입력해주세요.';
                } else
                if (nickname.isNotEmpty && !validPattern.hasMatch(nickname)) {
                  validationError = '특수문자는 사용할 수 없습니다.';
                } else {
                  validationError = null;
                }

                if (nickname.isEmpty) {
                  feedbackIcon = null;
                } else if (validationError == null) {
                  feedbackIcon = Icon(Icons.check_circle_outline,
                      color: AppColors.statusSuccess);
                } else {
                  feedbackIcon =
                      Icon(Icons.error_outline, color: AppColors.statusError);
                }

                if (wasValid && validationError != null) {
                  setState(() => borderColor = AppColors.statusError);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      setState(() => borderColor = AppColors.primaryBlueDark);
                    }
                  });
                }
              }

              validateNickname(nicknameController.text);

              return AlertDialog(
                backgroundColor: AppColors.backgroundCard,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                title: Center(
                  child: Text('닉네임 설정', style: TextStyle(fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('사용할 닉네임을 설정해주세요', textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.textPrimary)),
                    SizedBox(height: 4.h),
                    Text('3~12자, 특수문자 제외', style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: nicknameController,
                      onChanged: (nickname) =>
                          setState(() => validateNickname(nickname)),
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력해주세요',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: borderColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: validationError == null
                              ? AppColors.primary
                              : AppColors.statusError, width: 2.0),
                        ),
                        suffixIcon: feedbackIcon,
                        counterText: '',
                      ),
                      maxLength: 12,
                      autofocus: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣]')),
                      ],
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    onPressed: (validationError == null &&
                        nicknameController.text.isNotEmpty)
                        ? () =>
                        Navigator.of(dialogContext).pop(
                            nicknameController.text.trim()) // ✅ 닉네임 반환
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Text('확인', style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ),
                ],
              );
            },
          ),
    );

    // 🎯 여기서 닉네임 처리!
    if (nickname != null && nickname.isNotEmpty) {
      await _handleNicknameUpdate(nickname);
    }
  }

  /// 🎯 닉네임 업데이트 핸들러 (개선된 버전)
  Future<void> _handleNicknameUpdate(String nickname) async {
    // 🔒 중복 요청 방지
    if (_isProcessing) {
      print('⚠️ 이미 처리 중입니다. 중복 요청을 무시합니다.');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // 🔄 로딩 상태 표시
      _showLoadingSnackBar('닉네임을 설정하는 중...');

      // 🎯 AuthNotifier를 통한 통합 처리 (권장 방식)
      final result = await ref.read(authNotifierProvider.notifier).setupProfile(
        nickname: nickname,
      );

      // 📊 결과 처리
      result.fold(
        onSuccess: (_) {
          // ✅ 성공 처리
          _hideLoadingSnackBar(); // 로딩 스낵바 먼저 숨김
          _showSuccessSnackBar('닉네임이 "$nickname"로 설정되었습니다');

          print('✅ 닉네임 설정 성공: $nickname');
        },
        onFailure: (error, errorCode) {
          // ❌ 실패 처리
          _hideLoadingSnackBar(); // 로딩 스낵바 먼저 숨김

          // HTTP 405 오류 특별 처리
          if (error.contains('405') || error.contains('Method Not Allowed')) {
            _showErrorSnackBar('서버 설정 오류가 발생했습니다. 관리자에게 문의해주세요.');
            print('❌ HTTP 405 오류 - 서버에서 허용하지 않는 메서드: $error');
          } else {
            _showErrorSnackBar(error);
          }

          print('❌ 닉네임 설정 실패: $error (코드: $errorCode)');
        },
      );
    } catch (e) {
      // 🚨 예상치 못한 예외 처리
      _hideLoadingSnackBar(); // 로딩 스낵바 먼저 숨김

      print('❌ 닉네임 설정 중 예외 발생: $e');

      // DioException 특별 처리
      if (e.toString().contains('405')) {
        _showErrorSnackBar('서버 연결 방식에 문제가 있습니다. 잠시 후 다시 시도해주세요.');
      } else {
        _showErrorSnackBar('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
      }

      // 예외 발생 시 다시 시도 가능하도록
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _showNicknameDialog(context);
      });
    } finally {
      // 🧹 항상 상태 정리
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // =============================================================
  // 🎭 스낵바 관리 메서드들 (개선된 버전)
  // =============================================================

  /// 🔄 로딩 스낵바 (태그 기반 관리)
  void _showLoadingSnackBar(String message) {
    // 기존 스낵바가 있다면 먼저 숨김
    _hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('loading_snackbar'),
        // 식별용 키
        content: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(child: Text(message)), // Expanded로 오버플로우 방지
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(minutes: 5), // 충분히 긴 시간 (수동으로 제어)
      ),
    );
  }

  /// 🚫 로딩 스낵바 숨기기 (핵심!)
  void _hideLoadingSnackBar() {
    _hideCurrentSnackBar();
  }

  /// 🧹 현재 스낵바 숨기기 (통합 메서드)
  void _hideCurrentSnackBar() {
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e) {
      print('⚠️ 스낵바 숨기기 실패: $e');
    }
  }

  /// ✅ 성공 스낵바 (개선된 버전)
  void _showSuccessSnackBar(String message) {
    _hideCurrentSnackBar(); // 기존 스낵바 숨기기

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('success_snackbar'),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 12.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// ❌ 에러 스낵바 (개선된 버전)
  void _showErrorSnackBar(String message) {
    _hideCurrentSnackBar(); // 기존 스낵바 숨기기

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('error_snackbar'),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 12.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '닫기',
          textColor: Colors.white,
          onPressed: _hideCurrentSnackBar,
        ),
      ),
    );
  }

  /// ✅ 로그인 성공 처리 (개선된 버전)
  void _handleLoginSuccess(AuthUser user) {
    debugPrint('[$_logTag] 로그인 성공');

    _showSuccessSnackBar('${user.nickname ?? '사용자'}님, 환영합니다!');

    // 즉시 메인 화면으로 이동
    if (mounted) {
      context.go('/main');
    }
  }
}

// ===== 🎨 재사용 가능한 위젯들 =====

/// 🌐 언어 변경 버튼 위젯
class _LanguageButton extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onLanguageChanged;

  const _LanguageButton({
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity10(AppColors.textPrimary),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onLanguageChanged,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 16.sp,
                  color: AppColors.textSecondary,
                ),
                Gap(4.w),
                Text(
                  currentLanguage,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎨 로고 위젯 (메모리 최적화)
class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Image.asset( // <-- Container와 ClipRRect 없이 이미지만 바로 사용
        'assets/images/logo/mcc_logo_high.webp',
        width: 300.w,
        height: 300.w,
        // fit: BoxFit.contain, // 로고가 잘리지 않게 하려면 .contain을 권장합니다.
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) {
          // fallback 로고도 카드 스타일이 필요 없다면 함께 수정하는 것이 좋습니다.
          return _buildFallbackLogo();
        },
      ),
    );
  }

  /// 🎨 폴백 로고
  Widget _buildFallbackLogo() {
    return Container(
      width: 180.w,
      height: 180.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientBlue,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 50.sp,
              color: Colors.white,
            ),
            Gap(8.h),
            Text(
              'Mind Canvas',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// 🔑 로그인 버튼 위젯 (스타일 수정)
class _LoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final Color backgroundColor; // <-- 색상을 받을 필드 추가
  final Color foregroundColor; // <-- 색상을 받을 필드 추가

  const _LoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = false,
    required this.backgroundColor, // <-- required로 변경
    required this.foregroundColor, // <-- required로 변경
  });

  @override
  Widget build(BuildContext context) {
    // isPrimary가 false일 때의 스타일 (원하는 디자인)
    final secondaryStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF5F5F5), // 연한 회색 배경
      foregroundColor: AppColors.textPrimary,    // 검은색 텍스트
      elevation: 0, // 그림자 없음
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h),
    );

    // isPrimary가 true일 때의 스타일 (기존 디자인)
    final primaryStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: AppColors.withOpacity20(AppColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor), // 전경색 사용
          ),
        )
            : Icon(icon, size: 24.sp),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // <-- 전달받은 배경색 사용
          foregroundColor: foregroundColor, // <-- 전달받은 전경색 사용
          elevation: 0, // 플랫 디자인이므로 그림자 제거
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}


/// 🔍 익명 로그인 버튼 (원하는 디자인)
class _MinimalAnonymousLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _MinimalAnonymousLoginButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: isLoading
          ? SizedBox(
        width: 18.w,
        height: 18.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary),
        ),
      )
          : Icon(Icons.edit_outlined, size: 20.sp), // 아이콘 변경
      label: Text(
        '익명으로 로그인', // 텍스트 변경
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        backgroundColor: Colors.transparent, // 배경 없음
      ),
    );
  }
}

/// 🔍 익명 로그인 버튼 위젯 (미니멀 스타일)
class _AnonymousLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _AnonymousLoginButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary),
          ),
        )
            : Icon(Icons.visibility_off_outlined, size: 24.sp),
        label: Text(
          '익명으로 둘러보기',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          backgroundColor: AppColors.withOpacity10(AppColors.textSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}