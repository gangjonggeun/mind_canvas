import 'package:flutter/material.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/community_page.dart';

// 실제 프로젝트에서는 아래 import 경로를 활성화하고 사용하세요.
import 'pages/ideal_type_worldcup_page.dart';
import 'pages/personality_recommendations_page.dart';
import 'pages/user_recommendation_page.dart';
import '../data/mock_content_data.dart'; // 제공해주신 Mock 데이터 파일
import '../domain/enums/rec_category.dart';
import 'widgets/personalized_content_section.dart'; // 위젯 import


/// 🌟 Mind Canvas 추천 메인 화면
///
/// 성격 기반 컨텐츠 추천을 메인으로, 데이터 수집 및 상호 추천을 서브로 구성
/// - 🎯 성격 기반 컨텐츠 추천 (메인): '나'를 위한 추천과 '함께' 즐길 컨텐츠 추천 기능 포함
/// - 🏆 이상형 월드컵 (서브): 재미있는 테스트로 성격 데이터 수집
/// - 👥 사용자 컨텐츠 추천 (서브): 비슷한 성격 사용자간 상호 추천
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // final String _userMbti = 'INFP';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A202C) : const Color(0xFFF7F9FC),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2D3748), const Color(0xFF1A202C)]
                : [const Color(0xFFEBF4FF), const Color(0xFFF6F9FC)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 헤더 영역
              _buildHeader(isDark),
              const SizedBox(height: 32),

              // ✨ 2. 메인: 성격 기반 컨텐츠 추천 섹션 (교체 완료!)
              // 기존의 복잡한 로직이 이 한 줄로 끝납니다.
              PersonalizedContentSection(
              ),

              const SizedBox(height: 32),

              // // 3. 서브1: 이상형 월드컵 (기존 유지)
              // _buildWorldCupSection(isDark),
              // const SizedBox(height: 24),

              // 4. 서브2: 사용자 컨텐츠 추천 (기존 유지)
              _buildUserRecommendationSection(isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 1. 헤더 섹션
  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ 맞춤 추천',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '당신의 성격에 맞는 특별한 추천',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  //
  // /// 🎯 2. 메인: 성격 기반 컨텐츠 추천 섹션
  // Widget _buildPersonalizedContentSection(bool isDark) {
  //   Color cardColor = isDark ? const Color(0xFF2D3748) : Colors.white;
  //   Color textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
  //   Color subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);
  //
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: cardColor,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(isDark ? 0.2 : 0.07),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // 섹션 헤더: 모드 전환 기능 포함
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF4ECDC4).withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Text(
  //                 _selectedContentMode == ContentMode.personal ? '🎯' : '👥',
  //                 style: const TextStyle(fontSize: 24),
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     _selectedContentMode == ContentMode.personal ? '당신을 위한 컨텐츠' : '함께 보기 추천',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     _selectedContentMode == ContentMode.personal ? '성격에 맞는 컨텐츠!' : '같이 즐기는 컨텐츠!',
  //                     style: TextStyle(fontSize: 14, color: subTextColor),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _selectedContentMode = _selectedContentMode == ContentMode.personal
  //                       ? ContentMode.together
  //                       : ContentMode.personal;
  //                 });
  //               },
  //               icon: Icon(
  //                 _selectedContentMode == ContentMode.personal ? Icons.group_add_outlined : Icons.person_outline,
  //                 color: const Color(0xFF4ECDC4),
  //               ),
  //               tooltip: _selectedContentMode == ContentMode.personal ? '함께 보기 모드로 전환' : '개인 추천 모드로 전환',
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //
  //         // '함께 보기' 모드일 때만 보이는 MBTI 입력 섹션
  //         if (_selectedContentMode == ContentMode.together) ...[
  //           _buildMbtiInputSection(isDark),
  //           const SizedBox(height: 20),
  //         ],
  //
  //         // 컨텐츠 카테고리 탭
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           physics: const BouncingScrollPhysics(),
  //           child: Row(
  //             children: [
  //               _buildContentTab('🎬 영화', ContentType.movie, isDark),
  //               const SizedBox(width: 12),
  //               _buildContentTab('📺 드라마', ContentType.drama, isDark),
  //               const SizedBox(width: 12),
  //               _buildContentTab('🎵 음악', ContentType.music, isDark),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //
  //         // PersonalizedContentSection 위젯으로 교체
  //         PersonalizedContentSection(
  //           userMbti: _userMbti, // 또는 실제 사용자 MBTI 변수
  //           initialPartnerMbti: _partnerMbti, // 선택사항
  //           initialMode: ContentMode.personal, // 선택사항
  //           initialType: ContentType.movie, // 선택사항
  //           onContentTap: () {
  //             // 콘텐츠 탭했을 때 동작
  //             print('콘텐츠를 탭했습니다!');
  //           },
  //           showMbtiInput: true, // 선택사항
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // /// 🏆 3. 서브1: 이상형 월드컵 섹션
  // Widget _buildWorldCupSection(bool isDark) {
  //   final categories = MockContentData.getWorldCupCategories();
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: isDark ? const Color(0xFF2D3748) : Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: (isDark ? Colors.black : Colors.black).withOpacity(0.07),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF6B73FF).withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(Icons.emoji_events, color: Color(0xFF6B73FF), size: 24),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               '🏆 재미있는 테스트',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           '이상형 월드컵을 통해 취향을 발견하고 데이터를 수집해요',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         GridView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 12,
  //             crossAxisSpacing: 12,
  //             childAspectRatio: 2.8,
  //           ),
  //           itemCount: categories.length,
  //           itemBuilder: (context, index) {
  //             final cat = categories[index];
  //             // return _buildTestCategoryCard(
  //             //   isDark,
  //             //   cat['emoji']!,
  //             //   cat['title']!,
  //             //   cat['category']!,
  //             //   cat['subtitle']!,
  //             // );
  //             PersonalizedContentSection(
  //               userMbti: 'ENFP',
  //               initialMode: ContentMode.together,
  //               initialType: ContentType.drama,
  //               onContentTap: () => print('다른 페이지로 이동!'),
  //               showMbtiInput: false, // MBTI 입력 숨김
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// 👥 4. 서브2: 사용자 컨텐츠 추천 섹션
  Widget _buildUserRecommendationSection(bool isDark) {
    final recommendations = MockContentData.getUserRecommendations();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.people, color: Color(0xFF9F7AEA), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👥 사용자 추천',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      '비슷한 성격의 사용자들이 추천한 컨텐츠',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToUserRecommendations(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9F7AEA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9F7AEA),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return _buildUserRecommendationCard(rec, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- 위젯 빌더 헬퍼 함수들 ---
  //
  // /// 컨텐츠 카테고리 탭 위젯
  // Widget _buildContentTab(String title, ContentType type, bool isDark) {
  //   final isSelected = _selectedContentType == type;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _selectedContentType = type;
  //       });
  //     },
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 300),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: isSelected ? const Color(0xFF4ECDC4) : (isDark ? const Color(0xFF4A5568) : const Color(0xFFEDF2F7)),
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Text(
  //         title,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
  //           fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // /// MBTI 입력 섹션 위젯
  // Widget _buildMbtiInputSection(bool isDark) {
  //   Color subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);
  //   Color boxColor = isDark ? const Color(0xFF4A5568) : Colors.white;
  //   Color borderColor = isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0);
  //   Color textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF3182CE).withOpacity(isDark ? 0.2 : 0.1),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text('나의 MBTI', style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600)),
  //               const SizedBox(height: 8),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //                 decoration: BoxDecoration(
  //                   color: boxColor.withOpacity(0.5),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(_userMbti, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 8.0),
  //           child: Icon(Icons.favorite, color: Color(0xFF3182CE), size: 20),
  //         ),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text('상대방 MBTI', style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600)),
  //               const SizedBox(height: 8),
  //               GestureDetector(
  //                 onTap: () {
  //                   // 여기에 MBTI 선택기를 보여주는 BottomSheet 등을 호출
  //                   _showMbtiSelector();
  //                 },
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //                   decoration: BoxDecoration(
  //                     color: boxColor,
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(color: borderColor),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(_partnerMbti, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
  //                       const SizedBox(width: 8),
  //                       Icon(Icons.edit, size: 16, color: subTextColor),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // /// 추천 컨텐츠 카드 위젯
  // Widget _buildContentCard(Map<String, dynamic> content) {
  //   return GestureDetector(
  //     onTap: () => _navigateToPersonalityRecommendations(),
  //     child: Container(
  //       width: 150,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 10,
  //             offset: const Offset(0, 5),
  //           ),
  //         ],
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(16),
  //         child: Stack(
  //           fit: StackFit.expand,
  //           children: [
  //             Image.network(content['imageUrl']!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
  //             Container(
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [Colors.transparent, (content['gradientColors'] as List<Color>).first.withOpacity(0.3), (content['gradientColors'] as List<Color>).last.withOpacity(0.9)],
  //                   stops: const [0.3, 0.6, 1.0],
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 12,
  //               left: 12,
  //               right: 12,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     content['title']!,
  //                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, shadows: [Shadow(blurRadius: 2)]),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     content['subtitle']!,
  //                     style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, shadows: const [Shadow(blurRadius: 2)]),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               top: 8,
  //               right: 8,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                 decoration: BoxDecoration(
  //                   color: Colors.black.withOpacity(0.6),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
  //                     const SizedBox(width: 4),
  //                     Text(
  //                       content['rating']!,
  //                       style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// 이상형 월드컵 테스트 카테고리 카드 위젯
  Widget _buildTestCategoryCard(bool isDark, String emoji, String title, String category, String subtitle) {
    return GestureDetector(
      onTap: () => _navigateToWorldCup(category),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사용자 추천 카드 위젯
  Widget _buildUserRecommendationCard(Map<String, String> rec, bool isDark) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rec['title']!,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
              ),
              Text(
                rec['similarity']!,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9F7AEA)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            rec['content']!,
            style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B), height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }


  // --- 로직 및 데이터 처리 함수들 ---
  //
  // /// 컨텐츠 리스트를 현재 선택된 모드와 카테고리에 맞게 가져오는 함수
  // List<Map<String, dynamic>> _getContentList() {
  //   if (_selectedContentMode == ContentMode.together) {
  //     switch (_selectedContentType) {
  //       case ContentType.movie:
  //         return MockContentData.getTogetherMovieList(_userMbti, _partnerMbti);
  //       case ContentType.drama:
  //         return MockContentData.getTogetherDramaList(_userMbti, _partnerMbti);
  //       case ContentType.music:
  //         return MockContentData.getTogetherMusicList(_userMbti, _partnerMbti);
  //     }
  //   } else {
  //     switch (_selectedContentType) {
  //       case ContentType.movie:
  //         return MockContentData.getMovieList();
  //       case ContentType.drama:
  //         return MockContentData.getDramaList();
  //       case ContentType.music:
  //         return MockContentData.getMusicList();
  //     }
  //   }
  // }
  //
  // /// 파트너 MBTI를 선택하는 BottomSheet를 보여주는 함수
  // void _showMbtiSelector() {
  //   final mbtiTypes = MockContentData.getMbtiTypes();
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text('상대방의 MBTI를 선택해주세요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 20),
  //             Wrap(
  //               spacing: 10,
  //               runSpacing: 10,
  //               alignment: WrapAlignment.center,
  //               children: mbtiTypes.map((mbti) {
  //                 return ChoiceChip(
  //                   label: Text(mbti),
  //                   selected: _partnerMbti == mbti,
  //                   onSelected: (isSelected) {
  //                     if (isSelected) {
  //                       setState(() {
  //                         _partnerMbti = mbti;
  //                       });
  //                       Navigator.pop(context);
  //                     }
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


  /// 🚀 네비게이션 함수들
  void _navigateToPersonalityRecommendations() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => const PersonalityRecommendationsPage()),
    // );
  }

  void _navigateToWorldCup(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IdealTypeWorldCupPage(category: category)),
    );
  }

  void _navigateToUserRecommendations() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CommunityPage()),
    );
  }
}