// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:mind_canvas/core/theme/app_colors.dart';
//
// /// 🎨 Mind Canvas 로고 위젯
// ///
// /// 메모리 최적화된 로고 표시 위젯
// /// - WebP 이미지 활용으로 30% 용량 절약
// /// - 다크모드 지원 준비
// /// - 에러 처리 및 플레이스홀더
// class MindCanvasLogo extends StatelessWidget {
//   final double? width;
//   final double? height;
//   final bool showTitle;
//   final bool showSubtitle;
//
//   const MindCanvasLogo({
//     Key? key,
//     this.width,
//     this.height,
//     this.showTitle = true,
//     this.showSubtitle = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // 🖼️ 로고 이미지
//         _buildLogoImage(),
//
//         if (showTitle || showSubtitle) ...[
//           Gap(16.h),
//
//           // 📝 로고 텍스트
//           if (showTitle) _buildTitle(),
//           if (showSubtitle) ...[
//             Gap(8.h),
//             _buildSubtitle(),
//           ],
//         ],
//       ],
//     );
//   }
//
//   /// 🖼️ 로고 이미지 위젯
//   Widget _buildLogoImage() {
//     return Container(
//       width: width ?? 120.w,
//       height: height ?? 120.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.withOpacity10(Colors.black),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.r),
//         child: Image.asset(
//           'assets/images/logo/mcc_logo_high.webp',
//           width: width ?? 120.w,
//           height: height ?? 120.h,
//           fit: BoxFit.cover,
//           // 🎯 메모리 최적화
//           cacheWidth: ((width ?? 120.w) * 2).toInt(),
//           cacheHeight: ((height ?? 120.h) * 2).toInt(),
//           filterQuality: FilterQuality.medium,
//           errorBuilder: (context, error, stackTrace) {
//             return _buildErrorPlaceholder();
//           },
//         ),
//       ),
//     );
//   }
//
//   /// 📝 제목 위젯
//   Widget _buildTitle() {
//     return Text(
//       'Mind Canvas',
//       style: TextStyle(
//         fontSize: 28.sp,
//         fontWeight: FontWeight.bold,
//         color: AppColors.textPrimary,
//         letterSpacing: -0.5,
//       ),
//     );
//   }
//
//   /// 📝 부제목 위젯
//   Widget _buildSubtitle() {
//     return Text(
//       '마음을 그리는 캔버스',
//       style: TextStyle(
//         fontSize: 16.sp,
//         color: AppColors.textSecondary,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }
//
//   /// ❌ 에러 플레이스홀더
//   Widget _buildErrorPlaceholder() {
//     return Container(
//       width: width ?? 120.w,
//       height: height ?? 120.h,
//       decoration: BoxDecoration(
//         color: AppColors.backgroundTertiary,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: AppColors.borderLight,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.image_not_supported_outlined,
//             size: 32.sp,
//             color: AppColors.textTertiary,
//           ),
//           Gap(8.h),
//           Text(
//             'MCC',
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// 🔘 소셜 로그인 버튼 위젯
// ///
// /// 플랫폼별 로그인 버튼 컴포넌트
// /// - Material Design 3 준수
// /// - 접근성 고려한 명도 대비
// /// - 일관된 스타일링
// class SocialLoginButton extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final Color backgroundColor;
//   final Color textColor;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final double? width;
//
//   const SocialLoginButton({
//     Key? key,
//     required this.text,
//     required this.icon,
//     required this.backgroundColor,
//     required this.textColor,
//     this.onPressed,
//     this.isLoading = false,
//     this.width,
//   }) : super(key: key);
//
//   /// 🌐 Google 로그인 버튼 팩토리
//   factory SocialLoginButton.google({
//     VoidCallback? onPressed,
//     bool isLoading = false,
//     double? width,
//   }) {
//     return SocialLoginButton(
//       text: 'Google 계정으로 계속하기',
//       icon: Icons.g_mobiledata,
//       backgroundColor: Colors.white,
//       textColor: AppColors.textPrimary,
//       onPressed: onPressed,
//       isLoading: isLoading,
//       width: width,
//     );
//   }
//
//   /// 🍎 Apple 로그인 버튼 팩토리
//   factory SocialLoginButton.apple({
//     VoidCallback? onPressed,
//     bool isLoading = false,
//     double? width,
//   }) {
//     return SocialLoginButton(
//       text: 'Apple 계정으로 계속하기',
//       icon: Icons.apple,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//       onPressed: onPressed,
//       isLoading: isLoading,
//       width: width,
//     );
//   }
//
//   /// 👥 게스트 로그인 버튼 팩토리
//   factory SocialLoginButton.guest({
//     VoidCallback? onPressed,
//     bool isLoading = false,
//     double? width,
//   }) {
//     return SocialLoginButton(
//       text: '다른 계정으로 로그인',
//       icon: Icons.person_outline,
//       backgroundColor: AppColors.backgroundCard,
//       textColor: AppColors.textSecondary,
//       onPressed: onPressed,
//       isLoading: isLoading,
//       width: width,
//     );
//   }
//
//   /// 🔍 익명 로그인 버튼 팩토리 (새로 추가)
//   factory SocialLoginButton.anonymous({
//     VoidCallback? onPressed,
//     bool isLoading = false,
//     double? width,
//   }) {
//     return SocialLoginButton(
//       text: '익명으로 로그인',
//       icon: Icons.visibility_off_outlined,
//       backgroundColor: AppColors.backgroundTertiary,
//       textColor: AppColors.textSecondary,
//       onPressed: onPressed,
//       isLoading: isLoading,
//       width: width,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       height: 40.h, // 50 → 40으로 감소
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           elevation: 2,
//           shadowColor: AppColors.withOpacity20(Colors.black),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             side: backgroundColor == Colors.white
//                 ? BorderSide(color: AppColors.borderLight, width: 1)
//                 : BorderSide.none,
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//         ),
//         child: isLoading
//             ? _buildLoadingIndicator()
//             : _buildButtonContent(),
//       ),
//     );
//   }
//
//   /// 🔄 로딩 인디케이터
//   Widget _buildLoadingIndicator() {
//     return SizedBox(
//       width: 20.w,
//       height: 20.h,
//       child: CircularProgressIndicator(
//         strokeWidth: 2,
//         valueColor: AlwaysStoppedAnimation<Color>(textColor),
//       ),
//     );
//   }
//
//   /// 📝 버튼 콘텐츠
//   Widget _buildButtonContent() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           icon,
//           size: 18.sp, // 20 → 18로 감소
//           color: textColor,
//         ),
//         Gap(10.w), // 12 → 10으로 감소
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 14.sp, // 16 → 14로 감소
//             fontWeight: FontWeight.w600,
//             color: textColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// 📧 이메일 입력 필드 위젯
// ///
// /// 이메일 전용 최적화된 입력 필드
// /// - 자동 키보드 타입 설정
// /// - 실시간 유효성 검사
// /// - 접근성 레이블링
// class EmailTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String? errorText;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onEditingComplete;
//
//   const EmailTextField({
//     Key? key,
//     required this.controller,
//     this.errorText,
//     this.onChanged,
//     this.onEditingComplete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       autocorrect: false,
//       enableSuggestions: true,
//       onChanged: onChanged,
//       onEditingComplete: onEditingComplete,
//       decoration: InputDecoration(
//         labelText: '이메일',
//         hintText: 'email@domain.com',
//         prefixIcon: Icon(
//           Icons.email_outlined,
//           size: 20.sp,
//           color: AppColors.textSecondary,
//         ),
//         errorText: errorText,
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: 16.w,
//           vertical: 16.h,
//         ),
//       ),
//       style: TextStyle(
//         fontSize: 16.sp,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }
// }
//
// /// 🎯 로그인 화면 전용 구분선 위젯
// ///
// /// "또는" 텍스트가 포함된 구분선
// /// - 세련된 디자인
// /// - 다크모드 지원 준비
// class LoginDivider extends StatelessWidget {
//   final String text;
//
//   const LoginDivider({
//     Key? key,
//     this.text = '또는',
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 24.h),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 1,
//               color: AppColors.borderLight,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: AppColors.textTertiary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: 1,
//               color: AppColors.borderLight,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
