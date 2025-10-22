// import 'package:flutter/material.dart';
// import '../../domain/entities/psy_result.dart';
//
// /// 긴 결과용 레이아웃
// /// 섹션 기반의 읽기 친화적 디자인
// class LongResultLayout extends StatefulWidget {
//   final PsyResult result;
//   final ScrollController scrollController;
//
//   const LongResultLayout({
//     super.key,
//     required this.result,
//     required this.scrollController,
//   });
//
//   @override
//   State<LongResultLayout> createState() => _LongResultLayoutState();
// }
//
// class _LongResultLayoutState extends State<LongResultLayout> {
//   double _readingProgress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.scrollController.addListener(_updateReadingProgress);
//   }
//
//   @override
//   void dispose() {
//     widget.scrollController.removeListener(_updateReadingProgress);
//     super.dispose();
//   }
//
//   void _updateReadingProgress() {
//     if (widget.scrollController.hasClients) {
//       final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
//       final currentScroll = widget.scrollController.offset;
//
//       if (maxScrollExtent > 0) {
//         setState(() {
//           _readingProgress = (currentScroll / maxScrollExtent).clamp(0.0, 1.0);
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 읽기 진행률 표시
//           Container(
//             width: double.infinity,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(2),
//             ),
//             child: FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: _readingProgress,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(2),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.5),
//                       blurRadius: 4,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // 메인 설명 카드
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Color(int.parse(widget.result.mainColor, radix: 16))
//                             .withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '📖',
//                           style: const TextStyle(fontSize: 24),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '결과 요약',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(int.parse(widget.result.mainColor, radix: 16)),
//                             ),
//                           ),
//                           Text(
//                             '당신만의 특별한 이야기',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                   .withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Text(
//                   widget.result.description,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     height: 1.6,
//                     color: Color(0xFF2D3748),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // 섹션들 (긴 결과용)
//           ...widget.result.sections.asMap().entries.map((entry) {
//             final index = entry.key;
//             final section = entry.value;
//
//             return Container(
//               margin: const EdgeInsets.only(bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 섹션 헤더
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(int.parse(widget.result.mainColor, radix: 16))
//                               .withOpacity(0.1),
//                           Color(int.parse(widget.result.mainColor, radix: 16))
//                               .withOpacity(0.05),
//                         ],
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                       border: Border.all(
//                         color: Color(int.parse(widget.result.mainColor, radix: 16))
//                             .withOpacity(0.2),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                 .withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               section.iconEmoji,
//                               style: const TextStyle(fontSize: 20),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 section.title,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(int.parse(widget.result.mainColor, radix: 16)),
//                                 ),
//                               ),
//                               Text(
//                                 '${index + 1}/${widget.result.sections.length}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                       .withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // 섹션 컨텐츠
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(16),
//                         bottomRight: Radius.circular(16),
//                       ),
//                       border: Border(
//                         left: BorderSide(
//                           color: Color(int.parse(widget.result.mainColor, radix: 16))
//                               .withOpacity(0.2),
//                         ),
//                         right: BorderSide(
//                           color: Color(int.parse(widget.result.mainColor, radix: 16))
//                               .withOpacity(0.2),
//                         ),
//                         bottom: BorderSide(
//                           color: Color(int.parse(widget.result.mainColor, radix: 16))
//                               .withOpacity(0.2),
//                         ),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           section.content,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             height: 1.7,
//                             color: Color(0xFF2D3748),
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//
//                         // 하이라이트 텍스트들
//                         if (section.highlights.isNotEmpty) ...[
//                           const SizedBox(height: 16),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                   .withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                     .withOpacity(0.1),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       '✨',
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       '핵심 포인트',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color(int.parse(widget.result.mainColor, radix: 16)),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 ...section.highlights.map((highlight) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 8),
//                                     child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 4,
//                                           height: 4,
//                                           margin: const EdgeInsets.only(top: 8, right: 8),
//                                           decoration: BoxDecoration(
//                                             color: Color(int.parse(widget.result.mainColor, radix: 16)),
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                             highlight,
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               height: 1.5,
//                                               color: Color(int.parse(widget.result.mainColor, radix: 16))
//                                                   .withOpacity(0.8),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
