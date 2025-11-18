// import 'package:flutter/material.dart';
// import 'presentation/psy_result_screen.dart';
// import 'psy_result_sample_data.dart';
//
// /// 심리테스트 결과 데모 화면 (카드뷰 기반 통합)
// /// 이미지 유무에 따른 자동 카드뷰 레이아웃 테스트
// class PsyResultDemoScreen extends StatelessWidget {
//   const PsyResultDemoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text(
//           '심리테스트 결과 미리보기',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF2D3748),
//         elevation: 0.5,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '🃏 카드뷰 기반 심리테스트 결과 UI',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             const Text(
//               '이미지 유무에 따라 자동으로 조정되는 카드뷰\n'
//               '모든 결과 타입을 통일된 UI로 표시',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF718096),
//                 height: 1.5,
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             Expanded(
//               child: ListView(
//                 children: [
//                   // 텍스트 기반 결과 (이미지 없음)
//                   _buildSampleCard(
//                     context,
//                     title: '💕 연애 성향 테스트',
//                     subtitle: '이미지 없는 카드뷰',
//                     description:
//                         '텍스트 중심 - 기존 감성적 디자인\n'
//                         '메인 설명 카드 + 섹션별 카드',
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFFF8FA3), Color(0xFFFFC1CC)],
//                     ),
//                     icon: Icons.favorite,
//                     onTap: () => _showResult(
//                       context,
//                       PsyResultSampleData.textCentricResult,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // MBTI 결과 (캐릭터 이미지 + 섹션 이미지)
//                   _buildSampleCard(
//                     context,
//                     title: '🌟 MBTI 성격 유형',
//                     subtitle: '이미지 + 텍스트 카드뷰',
//                     description:
//                         'MBTI 캐릭터 이미지 카드 + 텍스트 카드\n'
//                         '섹션별 이미지가 있는 카드도 포함',
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFA78BFA), Color(0xFFD1C4E9)],
//                     ),
//                     icon: Icons.psychology,
//                     onTap: () => _showResult(
//                       context,
//                       PsyResultSampleData.hybridMbtiResult,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // HTP 결과 (3개 그림 격자)
//                   _buildSampleCard(
//                     context,
//                     title: '🎨 HTP 그림 검사',
//                     subtitle: '그림 격자 카드뷰',
//                     description:
//                         '집-나무-사람 3x1 격자 이미지 카드\n'
//                         '측정 데이터가 포함된 메인 설명 카드',
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF6B73E6), Color(0xFF9BA3FF)],
//                     ),
//                     icon: Icons.palette,
//                     onTap: () => _showResult(
//                       context,
//                       PsyResultSampleData.imageCentricHtpResult,
//                     ),
//                   ),
//
//                   const SizedBox(height: 32),
//
//                   // 기술적 특징 안내
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: const Color(0xFFE2E8F0)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF6B73E6).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Icon(
//                                 Icons.auto_awesome,
//                                 color: Color(0xFF6B73E6),
//                                 size: 20,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               '카드뷰 기반 통합 레이아웃',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF2D3748),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         ...[
//                           '🃏 통일된 카드뷰 디자인 (복잡한 레이아웃 분기 제거)',
//                           '🖼️ 스마트 이미지 처리 (이미지 유무 자동 감지)',
//                           '⚫ 명확한 외곽선 + 어두운 텍스트 (가독성 최적화)',
//                           '🎨 HTP 3x1 격자 + MBTI 원형 캐릭터',
//                           '📋 섹션별 독립 카드 (하이라이트 태그 포함)',
//                           '📊 HTP 측정 데이터 카드 (시간, 횟수, 순서)',
//                         ].map((feature) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: 4,
//                                   height: 4,
//                                   margin: const EdgeInsets.only(
//                                     top: 8,
//                                     right: 8,
//                                   ),
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFF6B73E6),
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     feature,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Color(0xFF4A5568),
//                                       height: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//
//                         const SizedBox(height: 12),
//
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF10B981).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: const Color(0xFF10B981).withOpacity(0.3),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.check_circle_outline,
//                                 color: Color(0xFF10B981),
//                                 size: 16,
//                               ),
//                               const SizedBox(width: 8),
//                               const Expanded(
//                                 child: Text(
//                                   '코드 300줄 → 200줄 간소화, 유지보수성 대폭 향상',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF065F46),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showResult(BuildContext context, dynamic result) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return PsyResultScreen(result: result);
//         },
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, 1.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOutCubic;
//
//           var tween = Tween(begin: begin, end: end).chain(
//             CurveTween(curve: curve),
//           );
//
//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//     );
//   }
//
//   Widget _buildSampleCard(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     required String description,
//     required Gradient gradient,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: gradient,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // 제목 (어두운 색)
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF2D3748), // 어두운 색으로 변경
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       // 부제목 태그 (어두운 배경 + 밝은 텍스트)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF2D3748).withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: const Color(0xFF4A5568)),
//                         ),
//                         child: Text(
//                           subtitle,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // 아이콘 (어두운 색)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2D3748).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF2D3748).withOpacity(0.2),
//                     ),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: const Color(0xFF2D3748), // 어두운 색으로 변경
//                     size: 24,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             // 설명 텍스트 (어두운 색)
//             Text(
//               description,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF4A5568), // 어두운 회색으로 변경
//                 height: 1.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // 하단 버튼 영역
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2D3748),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF2D3748).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '결과 보기',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
