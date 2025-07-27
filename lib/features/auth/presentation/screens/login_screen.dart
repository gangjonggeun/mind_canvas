import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_widgets.dart';

/// 🔑 Mind Canvas 로그인 화면 (Riverpod 버전)
///
/// **특징:**
/// - 새로운 Riverpod Provider 사용
/// - 메모리 최적화된 UI
/// - 다양한 로그인 방식 지원
/// - 에러 처리 및 로딩 상태
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  // 🎮 애니메이션 컨트롤러
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // 🎯 애니메이션
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;


  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 초기화
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 🚀 애니메이션 시작
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 인증 상태 리스너
    ref.listen<AsyncValue<AuthUser?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            _handleLoginSuccess(user);
          }
        },
        error: (error, stackTrace) {
          _showErrorMessage(error.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        
                        // 🎨 로고 섹션
                        _buildLogoSection(),
                        
                        SizedBox(height: 32.h),
                        
                        // 📝 안내 텍스트
                        _buildWelcomeText(),
                        
                        SizedBox(height: 32.h),
                        
                        // // 🔑 로그인 폼
                        // _buildLoginForm(),
                        
                        SizedBox(height: 24.h),
                        
                        // 🌐 소셜 로그인 섹션
                        _buildSocialLoginSection(),
                        
                        const Spacer(),
                        
                        // 📝 하단 텍스트
                        _buildFooterText(),
                        
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 로고 섹션
  Widget _buildLogoSection() {
    return Center(
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(60.r),
        ),
        child: Icon(
          Icons.palette_outlined,
          size: 60.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// 📝 환영 텍스트
  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Mind Canvas에 오신 것을 환영합니다',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          '당신의 마음색을 그려보세요',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 🔑 로그인 폼
  Widget _buildLoginForm() {
    final formNotifier = ref.watch(loginFormNotifierProvider.notifier);
    final formState = ref.watch(loginFormNotifierProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 📧 이메일 입력
          TextFormField(
            controller: _emailController,
            onChanged: formNotifier.updateEmail,
            decoration: InputDecoration(
              labelText: '이메일',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 16.h),

          // 🔒 비밀번호 입력
          TextFormField(
            controller: _passwordController,
            onChanged: formNotifier.updatePassword,
            obscureText: !formState.isPasswordVisible,
            decoration: InputDecoration(
              labelText: '비밀번호',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                onPressed: formNotifier.togglePasswordVisibility,
                icon: Icon(
                  formState.isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // 💾 로그인 상태 유지
          Row(
            children: [
              Checkbox(
                value: formState.rememberMe,
                onChanged: (_) => formNotifier.toggleRememberMe(),
              ),
              Text(
                '로그인 상태 유지',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // 🚀 로그인 버튼
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading || !formNotifier.isValid
                  ? null
                  : _handleEmailLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          // ❌ 에러 메시지
          if (formState.error != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.statusError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.statusError.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.statusError,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      formState.error!,
                      style: TextStyle(
                        color: AppColors.statusError,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 🌐 소셜 로그인 섹션
  Widget _buildSocialLoginSection() {
    final isLoading = ref.watch(isLoadingProvider);

    return Column(
      children: [
        // 구분선
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.borderLight)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                '또는',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.borderLight)),
          ],
        ),

        SizedBox(height: 20.h),

        // 🌐 Google 로그인
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : _handleGoogleLogin,
            icon: Icon(Icons.g_mobiledata, size: 24.sp),
            label: Text(
              'Google로 로그인',
              style: TextStyle(fontSize: 16.sp),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // 🍎 Apple 로그인
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : _handleAppleLogin,
            icon: Icon(Icons.apple, size: 24.sp),
            label: Text(
              'Apple로 로그인',
              style: TextStyle(fontSize: 16.sp),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 📝 하단 텍스트
  Widget _buildFooterText() {
    return Text(
      '계속 진행하면 서비스 이용약관 및 개인정보처리방침에 동의하게 됩니다',
      style: TextStyle(
        fontSize: 12.sp,
        color: AppColors.textTertiary,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }


  /// 🌐 Google 로그인 처리
  Future<void> _handleGoogleLogin() async {
    final result = await ref.read(authNotifierProvider.notifier).googleLogin(
      idToken: 'mock_id_token',
      accessToken: 'mock_access_token',
    );

    result.when(
      success: (_) {
        // 성공 처리는 리스너에서 처리됨
      },
      failure: (error, code) {  // ← 2개 인자 필요!
        _showErrorMessage(error);
      },
      loading: () {  // ← loading도 필요!
        // 로딩 처리 (보통 아무것도 안함)
      },
    );
  }

  /// 🍎 Apple 로그인 처리
  Future<void> _handleAppleLogin() async {
    final result = await ref.read(authNotifierProvider.notifier).appleLogin(
          identityToken: 'mock_identity_token',
          authorizationCode: 'mock_auth_code',
        );

    result.when(
      success: (_) {
        // 성공 처리는 리스너에서 처리됨
      },
      failure: (error, code) {  // ← 2개 인자 필요!
        _showErrorMessage(error);
      },
      loading: () {  // ← loading도 필요!
        // 로딩 처리 (보통 아무것도 안함)
      },
    );
  }

  /// ✅ 로그인 성공 처리
  void _handleLoginSuccess(UserEntity user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.displayName}님, 환영합니다!'),
        backgroundColor: AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );

    // 메인 화면으로 이동
    Navigator.of(context).pushReplacementNamed('/main');
  }

  /// ❌ 에러 메시지 표시
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
