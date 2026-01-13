import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/utils/cover_image_helper.dart';
import '../../domain/entity/recommendation_result.dart';
import '../../domain/enums/rec_category.dart';

/// 🚀 상세 보기 바텀 시트 호출 함수
void showContentDetail(BuildContext context, RecommendationContent item, RecCategory category) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ContentDetailSheet(item: item, category: category),
  );
}

class _ContentDetailSheet extends StatelessWidget {
  final RecommendationContent item;
  final RecCategory category; // ✅ 추가됨

  const _ContentDetailSheet({
    super.key,
    required this.item,
    required this.category,
  });

  // 🎨 제목을 기반으로 고유한 그라디언트 생성
  LinearGradient _generateGradient(String title) {
    final hash = title.hashCode;
    final color1 = Color((hash & 0xFFFFFF).toInt() | 0xFF000000);
    final color2 = Color(((hash >> 8) & 0xFFFFFF).toInt() | 0xFF000000);

    return LinearGradient(
      colors: [color1.withOpacity(0.8), color2.withOpacity(0.9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // 🔍 검색 확인 스낵바 표시 (취소 가능)
  Future<void> _showSearchDialog(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D3748) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text("구글 검색", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "'${item.title}'\n구글 검색 결과로 이동하시겠습니까?",
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "취소",
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
          // 이동 버튼
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // 다이얼로그 닫기
              _launchGoogleSearch(); // 브라우저 열기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("이동"),
          ),
        ],
      ),
    );
  }
  // 🌐 브라우저 실행 로직 (강제 실행 옵션 추가)
  Future<void> _launchGoogleSearch() async {
    final query = Uri.encodeComponent(item.title);
    final url = 'https://www.google.com/search?q=$query';

    try {
      // 1. canLaunchUrlString 체크 (Manifest 설정 필요)
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        // 2. 체크 실패 시에도 강제 시도 (일부 기기 호환성용)
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('❌ Could not launch $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A202C) : Colors.white;
    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF2D3748);
    final subTextColor = isDark
        ? const Color(0xFFA0AEC0)
        : const Color(0xFF64748B);
    const accentColor = Color(0xFF6B73FF);

    final imagePath = CoverImageHelper.getImagePath(category, item.title);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // 1. 드래그 핸들
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 2. 본문
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    // 🖼️ 상단 비주얼 (제스처 감지 추가)
                    GestureDetector(
                      onDoubleTap: () =>_showSearchDialog(context),
                      child: Hero(
                        tag: item.title,
                        child: Container(
                          height: 250, // 상세화면이니까 조금 더 크게
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 1. 배경 이미지 (없으면 그라디언트)
                                if (imagePath != null)
                                  Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      decoration: BoxDecoration(
                                        gradient: _generateGradient(item.title),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: _generateGradient(item.title),
                                    ),
                                  ),

                                // 2. 틴트 (글자 잘 보이게 어둡게 처리)
                                Container(color: Colors.black.withOpacity(0.3)),

                                // 3. 배경 패턴 (은은하게)
                                Positioned(
                                  right: -30,
                                  bottom: -30,
                                  child: Icon(
                                    Icons.format_quote,
                                    size: 180,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),

                                // 4. 중앙 텍스트 (첫 글자 - 이미지가 없을때만 보이게 하거나 항상 보이게)
                                // 이미지가 있으면 가리는게 나을 수 있으므로 Opacity 조절
                                Center(
                                  child: Text(
                                    item.title.isNotEmpty ? item.title[0] : '?',
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(
                                        0.15,
                                      ), // 더 연하게
                                    ),
                                  ),
                                ),

                                // 5. 제스처 힌트
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.touch_app,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Double tap to search",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 6. 매칭률 배지
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      '${item.matchPercent}% 일치',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 📝 제목
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 💡 AI 추천 이유
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accentColor.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.psychology_alt,
                                color: accentColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "AI 분석 코멘트",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.reason,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: textColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 📖 줄거리 섹션
                    if (item.description.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 20,
                            color: subTextColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "줄거리 / 정보",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: subTextColor,
                        ),
                      ),
                    ],

                    // 하단 여백 확보 (버튼이 사라졌으므로)
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
