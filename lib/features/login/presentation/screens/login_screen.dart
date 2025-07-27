import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/result.dart';
import '../widgets/login_widgets.dart';
import '../providers/login_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_request.dart';
import '../../domain/response/auth_response.dart';
import '../../domain/usecases/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
/// 🔑 Mind Canvas 로그인 화면
///
/// **특징:**
/// - 메모리 최적화된 StatelessWidget
/// - Riverpod 상태 관리
/// - 다크모드 지원 준비
/// - 접근성 고려 설계
/// - Result 패턴으로 안전한 에러 처리
/// - 스크롤 없는 고정 레이아웃
/// - 익명 로그인 포함된 간소화된 소셜 로그인
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  static const String _logTag = 'LoginScreen';

  // 🎮 애니메이션 컨트롤러
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // 🎯 애니메이션
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 🔍 상태 관리 (간소화)
  String _currentLanguage = 'KO'; // 기본 언어

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
    // 🎯 로그인 상태 리스너
    ref.listen<LoginState>(loginProvider, (previous, next) {
      _handleLoginStateChange(context, next);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            // 🎨 메인 콘텐츠
            _buildMainContent(),

            // 🌐 언어 변경 버튼 (우측 상단)
            _buildLanguageButton(),
          ],
        ),
      ),
    );
  }

  /// 🎨 메인 콘텐츠 (스크롤 지원으로 오버플로우 방지)
  Widget _buildMainContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView( // 스크롤 지원 추가
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
                    // 📱 언어 버튼을 위한 상단 여백
                    SizedBox(height: 50.h), // 언어 버튼 공간 확보

                    // 🎨 로고 섹션 (반응형 높이)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28, // 35% → 28%로 축소
                      constraints: BoxConstraints(
                        minHeight: 220.h, // 250 → 220으로 축소
                        maxHeight: 300.h, // 350 → 300으로 축소
                      ),
                      child: _buildLogoSection(),
                    ),

                    // 📝 심리테스트 안내 텍스트
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                      child: Text(
                        '마음색 캔버스에서\n당신의 마음색을 그려보세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    // 🔑 로그인 섹션 (Flexible로 변경)
                    Flexible(
                      child: _buildLoginSection(),
                    ),

                    // 📝 하단 텍스트 (고정 높이)
                    SizedBox(
                      height: 60.h,
                      child: _buildFooterText(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🌐 언어 변경 버튼 (로고와 완전히 분리)
  Widget _buildLanguageButton() {
    return Positioned(
      top: 5.h, // SafeArea 바로 아래 최상단
      right: 15.w,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.withOpacity10(Colors.black),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: _handleLanguageChange,
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
                    _currentLanguage,
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
      ),
    );
  }
  /// 🎨 로고 섹션 (메모리 최적화 + 간격 최소화)
  /// 🎨 로고 섹션 (패딩 최소화 + 크기 증가)
  Widget _buildLogoSection() {
    return Center(
      child: ClipRRect( // ← Container 제거하고 ClipRRect만 사용
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            boxShadow: [
              BoxShadow(
                color: AppColors.withOpacity10(Colors.black),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/logo/mcc_logo_high.webp',
            width: 250.w,  // ← 크기 증가
            height: 250.w, // ← 크기 증가
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 250.w,  // ← 에러 위젯도 같은 크기로
                height: 250.w,
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        size: 70.sp, // ← 크기에 맞춰 증가
                        color: AppColors.primary,
                      ),
                      Gap(8.h),
                      Text(
                        'Mind Canvas',
                        style: TextStyle(
                          fontSize: 28.sp, // ← 크기에 맞춰 증가
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔑 로그인 섹션
  Widget _buildLoginSection() {
    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.withOpacity10(Colors.black),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAllLoginButtons(),
          ],
        ),
      ),
    );
  }

  /// 🌐 모든 로그인 버튼들
  Widget _buildAllLoginButtons() {
    return Consumer(
      builder: (context, ref, child) {
        final loginState = ref.watch(loginProvider);

        return Column(
          children: [
            // 📝 안내 메시지
            Text(
              '다양한 플랫폼으로 로그인하세요',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(16.h),

            // 🌐 Google 로그인
            SocialLoginButton.google(
              onPressed: () => _handleGoogleLogin(ref),
              isLoading: loginState.isLoading &&
                  loginState.loadingProvider == AuthProvider.google,
              width: double.infinity,
            ),

            Gap(10.h),

            // 🍎 Apple 로그인
            SocialLoginButton.apple(
              onPressed: () => _handleAppleLogin(ref),
              isLoading: loginState.isLoading &&
                  loginState.loadingProvider == AuthProvider.apple,
              width: double.infinity,
            ),

            Gap(10.h),

            // 👥 다른 계정으로 로그인
            SocialLoginButton.guest(
              onPressed: () => _handleGuestLogin(ref),
              isLoading: loginState.isLoading &&
                  loginState.loadingProvider == AuthProvider.guest,
              width: double.infinity,
            ),

            // 🎯 or 구분선
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Row(
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
                        fontSize: 11.sp,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
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
              ),
            ),

            // 🔍 익명으로 로그인
            SocialLoginButton.anonymous(
              onPressed: () => _handleAnonymousLogin(ref),
              isLoading: loginState.isLoading &&
                  loginState.loadingProvider == AuthProvider.anonymous,
              width: double.infinity,
            ),
          ],
        );
      },
    );
  }

  /// 📝 하단 텍스트
  Widget _buildFooterText() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          '계속 진행하면 당사의 서비스 이용 약관 및 개인정보 처리방침에 동의하게 됩니다',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textTertiary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 🌐 언어 변경 핸들러
  void _handleLanguageChange() {
    setState(() {
      _currentLanguage = _currentLanguage == 'KO' ? 'EN' : 'KO';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('언어가 $_currentLanguage로 변경되었습니다'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// 🌐 Google 로그인 핸들러
  void _handleGoogleLogin(WidgetRef ref) {
    debugPrint('[$_logTag] Google 로그인 시도');
    ref.read(loginProvider.notifier).loginWithGoogle();
  }

  /// 🍎 Apple 로그인 핸들러
  void _handleAppleLogin(WidgetRef ref) {
    debugPrint('[$_logTag] Apple 로그인 시도');
    ref.read(loginProvider.notifier).loginWithApple();
  }

  /// 👥 게스트 로그인 핸들러
  void _handleGuestLogin(WidgetRef ref) {
    debugPrint('[$_logTag] 게스트 로그인 시도');
    ref.read(loginProvider.notifier).loginAsGuest();
  }

  /// 🔍 익명 로그인 핸들러
  void _handleAnonymousLogin(WidgetRef ref) {
    debugPrint('[$_logTag] 익명 로그인 시도');
    ref.read(loginProvider.notifier).loginAsAnonymous();
  }

  /// 🎯 로그인 상태 변화 처리
  void _handleLoginStateChange(BuildContext context, LoginState state) {
    state.when(
      initial: () {
        // 초기 상태 - 아무것도 하지 않음
      },
      loading: (provider, message) {
        // 로딩 상태 - 이미 UI에서 처리됨
        debugPrint('[$_logTag] 로딩 중: ${provider?.displayName} - $message');
      },
      success: (user, provider) {
        // ✅ 로그인 성공
        _handleLoginSuccess(context, user, provider);
      },
      failure: (message, errorCode, provider) {
        // ❌ 로그인 실패
        _handleLoginFailure(context, message, errorCode, provider);
      },
    );
  }

  /// ✅ 로그인 성공 처리
  void _handleLoginSuccess(BuildContext context, UserEntity user, AuthProvider provider) {
    debugPrint('[$_logTag] 로그인 성공: ${user.displayName} (${provider.displayName})');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${provider.displayName} 로그인에 성공했습니다!'),
        backgroundColor: AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// ❌ 로그인 실패 처리
  void _handleLoginFailure(
      BuildContext context,
      String message,
      String? errorCode,
      AuthProvider? provider,
      ) {
    debugPrint('[$_logTag] 로그인 실패: $message (${errorCode ?? 'NO_CODE'})');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '닫기',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    ref.read(loginProvider.notifier).clearError();
  }
}

// Provider 정의
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(MockAuthRepository());
});

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return LoginNotifier(loginUseCase);
});

// Mock AuthRepository
class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<AuthResponse>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@test.com' && password == 'test123') {
      return Results.success(AuthResponse(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        user: UserResponse(
          id: 'user_123',
          email: email,
          displayName: 'Test User',
          authProvider: 'email',
          isEmailVerified: true,
          isProfileComplete: true,
        ),
      ));
    } else {
      return Results.failure('이메일 또는 비밀번호가 올바르지 않습니다', 'INVALID_CREDENTIALS');
    }
  }

  @override
  Future<Result<AuthResponse>> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    return Results.success(AuthResponse(
      accessToken: 'mock_google_token',
      refreshToken: 'mock_google_refresh',
      user: UserResponse(
        id: 'google_user_123',
        email: 'user@gmail.com',
        displayName: 'Google User',
        authProvider: 'google',
        isEmailVerified: true,
        isProfileComplete: true,
      ),
    ));
  }

  @override
  Future<Result<AuthResponse>> loginWithApple() async {
    await Future.delayed(const Duration(seconds: 1));
    return Results.success(AuthResponse(
      accessToken: 'mock_apple_token',
      refreshToken: 'mock_apple_refresh',
      user: UserResponse(
        id: 'apple_user_123',
        email: 'user@icloud.com',
        displayName: 'Apple User',
        authProvider: 'apple',
        isEmailVerified: true,
        isProfileComplete: true,
      ),
    ));
  }

  @override
  Future<Result<AuthResponse>> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Results.success(AuthResponse(
      accessToken: 'mock_guest_token',
      refreshToken: 'mock_guest_refresh',
      user: UserResponse(
        id: 'guest_user_123',
        email: 'guest@mindcanvas.com',
        displayName: 'Guest User',
        authProvider: 'guest',
        isEmailVerified: false,
        isProfileComplete: false,
      ),
    ));
  }

  @override
  Future<Result<AuthResponse>> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Results.failure('Not implemented', 'NOT_IMPLEMENTED');
  }

  @override
  Future<Result<void>> logout({bool logoutFromAllDevices = false}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Results.success(null);
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Results.success(null);
  }

  @override
  Future<bool> isLoggedIn() async {
    return false;
  }

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // Mock implementation
  }

  @override
  Future<void> clearAuthTokens() async {
    // Mock implementation
  }
}