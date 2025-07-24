// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:cached_network_image/cached_network_image.dart';
//
// import '../domain/entities/recommended_content_entity.dart';
// import '../providers/recommended_content_provider.dart';
// import '../../theme/app_colors.dart';
//
// class RecommendedContentSection extends ConsumerStatefulWidget {
//   final void Function(RecommendedContentEntity content)? onContentTap;
//   final EdgeInsetsGeometry? padding;
//   final double? height;
//
//   const RecommendedContentSection({
//     super.key,
//     this.onContentTap,
//     this.padding,
//     this.height,
//   });
//
//   @override
//   ConsumerState<RecommendedContentSection> createState() => _RecommendedContentSectionState();
// }
//
// class _RecommendedContentSectionState extends ConsumerState<RecommendedContentSection> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         ref.read(recommendedContentActionsProvider).initialize();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     final selectedContentMode = ref.watch(selectedContentModeProvider);
//     final selectedContentType = ref.watch(selectedContentTypeProvider);
//     final userMbti = ref.watch(userMbtiProvider);
//     final partnerMbti = ref.watch(partnerMbtiProvider);
//     final currentContents = ref.watch(currentContentsProvider);
//     final isLoading = ref.watch(isLoadingProvider);
//     final errorMessage = ref.watch(errorMessageProvider);
//
//     final actions = ref.watch(recommendedContentActionsProvider);
//
//     return Container(
//       padding: widget.padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 20), // 하단 패딩 확보
//       height: widget.height,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: isDarkMode
//               ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)]
//               : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
//         ),
//         borderRadius: BorderRadius.circular(20), // 부드러운 느낌을 위해 반지름 증가
//         border: Border.all(
//           color: isDarkMode
//               ? AppColors.secondaryTeal.withOpacity(0.2)
//               : AppColors.withOpacity20(AppColors.secondaryTeal),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _RecommendedContentHeader(
//             selectedContentMode: selectedContentMode,
//             onModeToggle: actions.changeContentMode,
//           ),
//
//           const SizedBox(height: 18), // 간격 조정
//
//           if (selectedContentMode == ContentMode.together)
//             _MbtiInputSection(
//               userMbti: userMbti,
//               partnerMbti: partnerMbti,
//               onPartnerMbtiChanged: actions.changePartnerMbti,
//               isDarkMode: isDarkMode,
//             ),
//
//           if (selectedContentMode == ContentMode.together)
//             const SizedBox(height: 16), // 간격 조정
//
//           _ContentTypeTabs(
//             selectedContentType: selectedContentType,
//             onContentTypeChanged: actions.changeContentType,
//             isDarkMode: isDarkMode,
//           ),
//
//           const SizedBox(height: 16), // 간격 조정
//
//           // 콘텐츠 리스트 높이 대폭 증가
//           SizedBox(
//             height: 220,
//             child: _ContentListView(
//               contents: currentContents,
//               isLoading: isLoading,
//               errorMessage: errorMessage,
//               onContentTap: widget.onContentTap,
//               onRetry: actions.refresh,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _RecommendedContentHeader extends StatelessWidget {
//   final ContentMode selectedContentMode;
//   final void Function(ContentMode) onModeToggle;
//
//   const _RecommendedContentHeader({
//     required this.selectedContentMode,
//     required this.onModeToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: AppColors.withOpacity10(AppColors.secondaryTeal),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             selectedContentMode.emoji,
//             style: const TextStyle(fontSize: 24),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 selectedContentMode.displayName,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 selectedContentMode.description,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             final newMode = selectedContentMode == ContentMode.personal
//                 ? ContentMode.together
//                 : ContentMode.personal;
//             onModeToggle(newMode);
//           },
//           icon: Icon(
//             selectedContentMode == ContentMode.personal
//                 ? Icons.group_add_outlined
//                 : Icons.person_outline,
//             color: AppColors.secondaryTeal,
//           ),
//           tooltip: selectedContentMode == ContentMode.personal ? '함께 보기' : '개인 추천',
//         ),
//       ],
//     );
//   }
// }
//
// class _MbtiInputSection extends ConsumerWidget {
//   final MbtiInfo userMbti;
//   final MbtiInfo partnerMbti;
//   final void Function(String) onPartnerMbtiChanged;
//   final bool isDarkMode;
//
//   const _MbtiInputSection({
//     required this.userMbti,
//     required this.partnerMbti,
//     required this.onPartnerMbtiChanged,
//     required this.isDarkMode,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? AppColors.primaryBlue.withOpacity(0.15)
//             : AppColors.withOpacity10(AppColors.primaryBlue),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.withOpacity20(AppColors.primaryBlue),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 5,
//             child: _buildMbtiDisplay('나의 MBTI', userMbti.type, isEditable: false),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.0),
//             child: Icon(Icons.favorite, color: AppColors.primaryBlue, size: 20),
//           ),
//           Expanded(
//             flex: 5,
//             child: _buildMbtiDisplay(
//               '상대방 MBTI',
//               partnerMbti.type,
//               isEditable: true,
//               onTap: () => _showMbtiSelector(context, ref),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMbtiDisplay(
//       String label,
//       String mbti, {
//         bool isEditable = false,
//         VoidCallback? onTap,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             color: AppColors.textSecondary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: AppColors.backgroundCard,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.borderLight),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     mbti,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 if (isEditable)
//                   const Icon(Icons.edit, size: 16, color: AppColors.textTertiary),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showMbtiSelector(BuildContext context, WidgetRef ref) {
//     const mbtiTypes = [
//       'INTJ', 'INTP', 'ENTJ', 'ENTP', 'INFJ', 'INFP', 'ENFJ', 'ENFP',
//       'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', 'ISTP', 'ISFP', 'ESTP', 'ESFP',
//     ];
//
//     showModalBottomSheet<void>(
//       context: context,
//       backgroundColor: AppColors.backgroundCard,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         height: 300,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '상대방 MBTI 선택',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
//                 ),
//                 itemCount: mbtiTypes.length,
//                 itemBuilder: (context, index) {
//                   final mbti = mbtiTypes[index];
//                   final isSelected = mbti == partnerMbti.type;
//                   return GestureDetector(
//                     onTap: () {
//                       onPartnerMbtiChanged(mbti);
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: isSelected ? AppColors.primaryBlue : AppColors.backgroundSecondary,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.borderLight),
//                       ),
//                       child: Center(
//                         child: Text(
//                           mbti,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : AppColors.textPrimary,
//                             fontWeight: FontWeight.bold, fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ContentTypeTabs extends StatelessWidget {
//   final ContentType selectedContentType;
//   final void Function(ContentType) onContentTypeChanged;
//   final bool isDarkMode;
//
//   const _ContentTypeTabs({
//     required this.selectedContentType,
//     required this.onContentTypeChanged,
//     required this.isDarkMode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: ContentType.values
//             .map((type) => _buildContentTab(type))
//             .expand((widget) => [widget, const SizedBox(width: 10)])
//             .toList()
//           ..removeLast(),
//       ),
//     );
//   }
//
//   Widget _buildContentTab(ContentType type) {
//     final isSelected = selectedContentType == type;
//     return GestureDetector(
//       onTap: () => onContentTypeChanged(type),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.secondaryTeal : AppColors.backgroundCard,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? AppColors.secondaryTeal.withOpacity(0.8) : AppColors.borderLight,
//           ),
//           boxShadow: isSelected ? [
//             BoxShadow(
//               color: AppColors.secondaryTeal.withOpacity(0.3),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             )
//           ] : [],
//         ),
//         child: Text(
//           type.displayName,
//           style: TextStyle(
//             color: isSelected ? Colors.white : AppColors.textSecondary,
//             fontSize: 14,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ContentListView extends StatelessWidget {
//   final List<RecommendedContentEntity> contents;
//   final bool isLoading;
//   final String? errorMessage;
//   final void Function(RecommendedContentEntity)? onContentTap;
//   final VoidCallback? onRetry;
//
//   const _ContentListView({
//     required this.contents,
//     required this.isLoading,
//     this.errorMessage,
//     this.onContentTap,
//     this.onRetry,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
//     }
//
//     if (errorMessage != null) {
//       return _buildErrorView();
//     }
//
//     if (contents.isEmpty) {
//       return _buildEmptyView();
//     }
//
//     return ListView.separated(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       itemCount: contents.length,
//       separatorBuilder: (context, index) => const SizedBox(width: 12),
//       itemBuilder: (context, index) {
//         final content = contents[index];
//         return _ContentCard(
//           content: content,
//           onTap: () => onContentTap?.call(content),
//         );
//       },
//     );
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             color: AppColors.textTertiary,
//             size: 48,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             errorMessage ?? '오류가 발생했습니다',
//             style: const TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           TextButton(
//             onPressed: onRetry,
//             child: const Text('다시 시도'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyView() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.movie_filter_outlined,
//             color: AppColors.textTertiary,
//             size: 48,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '추천할 컨텐츠가 없습니다',
//             style: TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ContentCard extends StatelessWidget {
//   final RecommendedContentEntity content;
//   final VoidCallback? onTap;
//
//   const _ContentCard({
//     required this.content,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: 150, // 카드 너비 조정
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.backgroundCard,
//             borderRadius: BorderRadius.circular(16), // 부드러운 느낌
//             border: Border.all(color: AppColors.borderLight.withOpacity(0.8)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: _buildImageSection(),
//                 ),
//                 _buildContentInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection() {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         CachedNetworkImage(
//           imageUrl: content.imageUrl,
//           fit: BoxFit.cover,
//           filterQuality: FilterQuality.medium,
//           placeholder: (context, url) => Container(
//             decoration: BoxDecoration(gradient: LinearGradient(colors: content.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
//             child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
//           ),
//           errorWidget: (context, url, error) => Container(
//             decoration: BoxDecoration(gradient: LinearGradient(colors: content.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
//             child: Center(child: Icon(content.type.icon, color: Colors.white, size: 30)),
//           ),
//         ),
//         Positioned(
//           top: 8,
//           right: 8,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//             decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(8)),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.star, color: Colors.yellow, size: 12),
//                 const SizedBox(width: 3),
//                 Text(
//                   content.rating,
//                   style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildContentInfo() {
//     return Container(
//       height: 70, // 하단 정보 영역 높이 고정
//       padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             content.title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textPrimary,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             content.subtitle,
//             style: const TextStyle(
//               fontSize: 12,
//               color: AppColors.textSecondary,
//               height: 1.3,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }