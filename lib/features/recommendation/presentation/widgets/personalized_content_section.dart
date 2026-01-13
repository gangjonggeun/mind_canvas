import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/recommendation/presentation/widgets/content_detail_sheet.dart';
import 'dart:math'; // 그라디언트 랜덤 생성용

import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../../../core/utils/cover_image_helper.dart';
import '../../domain/enums/rec_category.dart';
import '../../domain/entity/recommendation_result.dart';
import '../provider/recommendation_notifier.dart';
import '../../domain/enums/rec_category_extension.dart'; // 👈 이게 있어야 .themeColor 사용 가능

class PersonalizedContentSection extends ConsumerStatefulWidget {
  const PersonalizedContentSection({super.key});

  @override
  ConsumerState<PersonalizedContentSection> createState() =>
      _PersonalizedContentSectionState();
}

class _PersonalizedContentSectionState
    extends ConsumerState<PersonalizedContentSection> {
  // 초기 카테고리
  RecCategory _selectedCategory = RecCategory.MOVIE;

  @override
  void initState() {
    super.initState();
    // 💡 초기화 로직 삭제:
    // 이제 앱이 켜졌다고 자동으로 요청하지 않고,
    // 사용자가 버튼을 눌렀을 때만 요청합니다.
    // (다만, 이전에 받아둔 데이터가 있다면 Notifier가 알아서 보여줍니다.)
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recState = ref.watch(recommendationNotifierProvider);

    // UI 색상 정의 (기존 디자인 유지)
    Color cardColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    Color textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF2D3748);
    Color subTextColor = isDark
        ? const Color(0xFFA0AEC0)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 헤더 섹션 (Extension 사용)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // 🎨 Extension 사용 (.themeColor)
                  color: _selectedCategory.themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  // 🖼️ Extension 사용 (.icon)
                  _selectedCategory.icon,
                  color: _selectedCategory.themeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신을 위한 AI 추천', // 기존 텍스트 유지
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // 🏷️ Extension 사용 (.label)
                      '${_selectedCategory.label} 큐레이션',
                      style: TextStyle(fontSize: 14, color: subTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 새로고침 버튼 (로딩 중엔 인디케이터)
              if (!recState.isLoading &&
                  ref.watch(recommendationNotifierProvider).result != null)
                IconButton(
                  onPressed: _requestRecommendation,
                  icon: Icon(Icons.refresh, color: subTextColor),
                  tooltip: '다시 추천 받기 (15코인)',
                )
              else if (recState.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _selectedCategory.themeColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. 카테고리 탭 (가로 스크롤)
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: RecCategory.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = RecCategory.values[index];
                return _buildContentTab(category, isDark);
              },
            ),
          ),
          const SizedBox(height: 16),

          // 3. 컨텐츠 리스트 (카드)
          _buildBody(recState, isDark),
        ],
      ),
    );
  }

  // 기존 디자인과 동일한 탭 위젯
  Widget _buildContentTab(RecCategory category, bool isDark) {
    final isSelected = _selectedCategory == category;
    final themeColor = category.themeColor; // Extension

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor
              : (isDark ? const Color(0xFF4A5568) : const Color(0xFFEDF2F7)),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: themeColor.withOpacity(0.3), width: 1),
        ),
        child: Text(
          category.label, // Extension
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : themeColor),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // 데이터 상태에 따른 본문
  Widget _buildBody(RecommendationState state, bool isDark) {
    if (state.errorMessage != null) {
      return _buildErrorState(state.errorMessage!);
    }

    // 1️⃣ 데이터 없음 (초기 상태) -> "추천 받기 버튼" 표시
    if (state.result == null && !state.isLoading) {
      return _buildRequestButtonState(isDark);
    }

    // 2️⃣ 로딩 중
    if (state.isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(
                "AI가 취향을 분석하고 있습니다...",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 3️⃣ 데이터 있음 -> 리스트 표시
    // 현재 선택된 탭에 맞는 데이터 찾기
    final group = state.result!.groups.firstWhere(
      (g) => g.category == _selectedCategory,
      orElse: () =>
          RecommendationCategoryGroup(category: _selectedCategory, items: []),
    );

    if (group.items.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("이 카테고리의 추천 결과가 없습니다.")),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: group.items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = group.items[index];
          // ✨ 기존 카드 디자인 재사용
          return _buildLegacyStyleCard(item);
        },
      ),
    );
  }

  /// 🔘 추천 요청 버튼 위젯
  Widget _buildRequestButtonState(bool isDark) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 40,
            color: _selectedCategory.themeColor,
          ),
          const SizedBox(height: 12),
          Text(
            "아직 추천받은 내역이 없습니다",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "성격 데이터를 기반으로 딱 맞는 컨텐츠를 찾아드려요!",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _requestRecommendation,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedCategory.themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
            ),
            icon: const Icon(Icons.bolt, size: 18),
            label: const Text("추천 받기 (15코인)"),
          ),
          const SizedBox(height: 8),
          const Text(
            "* 심리 테스트 결과가 많을수록 정확도가 올라갑니다",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ⚠️ 에러 상태 위젯
  Widget _buildErrorState(String message) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 32),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          TextButton(
            onPressed: _requestRecommendation,
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }

  // // 🚀 요청 메서드
  // void _requestRecommendation() {
  //   // 1. 코인 확인 (UserNotifier 상태 확인)
  //   final user = ref.read(userNotifierProvider);
  //   final coins = user?.coins ?? 0;
  //
  //   if (coins < 15) {
  //     // 코인 부족 팝업
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('코인이 부족합니다! (필요: 15코인)')));
  //     return;
  //   }
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('AI 추천을 요청합니다... 잠시만 기다려주세요.')),
  //   );
  //
  //   ref
  //       .read(recommendationNotifierProvider.notifier)
  //       .fetchRecommendations(
  //         categories: RecCategory.values,
  //         userMood: "",
  //         forceRefresh: true,
  //       );
  // }

  void _requestRecommendation() {
    _showRefreshConfirmDialog();
  }

  // 💬 [추가] 재요청 확인 다이얼로그
  Future<void> _showRefreshConfirmDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. 다이얼로그 띄우기
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D3748) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '새로운 추천 받기',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 추천받은 컨텐츠 목록은 사라지고,\n새로운 분석 결과로 덮어씌워집니다.',
                style: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Image.asset(
                    'assets/images/icon/coin_palette_128.webp', // 코인 아이콘 경로 확인
                    width: 18,
                    height: 18,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '15코인이 차감됩니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber, // 혹은 포인트 컬러
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // 취소
              child: Text(
                '취소',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // 확인
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('새로 받기'),
            ),
          ],
        );
      },
    );

    // 2. 확인을 눌렀을 때만 실제 로직 실행
    if (confirm == true) {
      _executeRefresh();
    }
  }

  // ⚡ [추가] 실제 API 요청 및 코인 검사 로직
  void _executeRefresh() {
    // 1. 코인 확인
    final user = ref.read(userNotifierProvider);
    final coins = user?.coins ?? 0;

    if (coins < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('코인이 부족합니다! (필요: 15코인)'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // 2. 안내 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('AI가 새로운 취향을 분석 중입니다...'),
        backgroundColor: const Color(0xFF2D3748),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // 3. API 요청 (강제 갱신)
    ref
        .read(recommendationNotifierProvider.notifier)
        .fetchRecommendations(
          categories: RecCategory.values,
          userMood: "", // 필요하다면 여기에 기분 입력값을 넣을 수 있음
          forceRefresh: true,
        );
  }

  /// 🎨 기존 디자인을 최대한 살린 카드 위젯
  /// (이미지 대신 그라디언트를 사용하지만, 텍스트 위치/배지는 그대로 유지)
  Widget _buildLegacyStyleCard(RecommendationContent item) {
    final imagePath = CoverImageHelper.getImagePath(_selectedCategory, item.title);

    return GestureDetector(
      onTap: () {
        showContentDetail(context, item, _selectedCategory);
      },
      child: Container(
        width: 150, // 기존 너비 유지
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 배경 (이미지 or 그라디언트)
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 파일은 있는데 로드 에러나면 그라디언트
                    return Container(
                      decoration: BoxDecoration(
                        gradient: _generateGradient(item.title),
                      ),
                    );
                  },
                )
              else
              // 이미지가 아직 로드 안 됐거나 파일이 없으면 그라디언트
                Container(
                  decoration: BoxDecoration(
                    gradient: _generateGradient(item.title),
                  ),
                ),

              // 💡 틴트 효과 (이미지가 있을 때만 살짝 어둡게)
              if (imagePath != null)
                Container(color: Colors.black.withOpacity(0.3)),

              // 2. 하단 그라디언트 오버레이 (텍스트 가독성용 - 기존 유지)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6), // 어둡게 처리하여 글자 잘 보이게
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // 3. 텍스트 정보 (기존 위치 유지: 하단)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                // ✅ Column 대신 높이가 제한된 Container 사용
                child: SizedBox(
                  height: 60, // 텍스트 영역 높이 고정 (제목 + 설명 + 간격)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end, // 아래 정렬
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [Shadow(blurRadius: 2)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        // 남은 공간 모두 사용
                        child: Text(
                          item.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            shadows: const [Shadow(blurRadius: 2)],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. 배지 (기존 위치 유지: 우측 상단)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.incomplete_circle,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${item.matchPercent}%", // 매칭률 표시
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. 좌측 상단 카테고리 아이콘 (심심해서 추가, 제거 가능)
              Positioned(
                top: 8,
                left: 8,
                child: Icon(
                  _selectedCategory.icon,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 제목 기반 랜덤 그라디언트 생성기 (이미지 대체용)
  LinearGradient _generateGradient(String title) {
    final hash = title.hashCode;
    final random = Random(hash);
    final baseColor = _selectedCategory.themeColor;

    // HSL 변환으로 톤 변경
    final hsl = HSLColor.fromColor(baseColor);
    final color1 = hsl
        .withHue((hsl.hue + random.nextInt(40) - 20) % 360)
        .toColor();
    final color2 = hsl.withLightness(0.4).toColor(); // 좀 더 어둡게

    return LinearGradient(
      colors: [color1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
