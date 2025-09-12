import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/test_ranking_item.dart';
import '../notifiers/test_list_notifier.dart';

/// 📊 인기 테스트 랭킹 화면 (개선된 디자인 + Notifier 연동)
class PopularTestRankingScreen extends ConsumerStatefulWidget {
  const PopularTestRankingScreen({super.key});

  @override
  ConsumerState<PopularTestRankingScreen> createState() => _PopularTestRankingScreenState();
}

class _PopularTestRankingScreenState extends ConsumerState<PopularTestRankingScreen> {
  final ScrollController _scrollController = ScrollController();

  // 필터 상태 (확장된 옵션)
  RankingFilter _selectedFilter = RankingFilter.popular;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 초기 데이터 로딩
  void _initializeData() {
    // Notifier를 통해 최신 테스트 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(testListNotifierProvider.notifier).loadLatestTests();
    });
  }

  /// 스크롤 리스너 설정 (무한 스크롤)
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        // 무한 스크롤 트리거
        ref.read(testListNotifierProvider.notifier).loadNextPage();
      }
    });
  }

  /// 필터 변경 처리
  void _onFilterChanged(RankingFilter filter) {
    if (_selectedFilter == filter) return;

    setState(() {
      _selectedFilter = filter;
    });

    // 새로고침
    _onRefresh();
  }

  /// 새로고침 처리
  Future<void> _onRefresh() async {
    await ref.read(testListNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  /// 🎯 상단 앱바 생성
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundCard,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          const Text(
            '🏆 인기 테스트 랭킹',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  /// 🔽 필터 드롭다운 버튼
  Widget _buildFilterDropdown() {
    return PopupMenuButton<RankingFilter>(
      initialValue: _selectedFilter,
      onSelected: _onFilterChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedFilter.displayName,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryBlue,
              size: 18,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => RankingFilter.values
          .map((filter) => PopupMenuItem<RankingFilter>(
        value: filter,
        child: Row(
          children: [
            Text(
              filter.emoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              filter.displayName,
              style: TextStyle(
                color: _selectedFilter == filter
                    ? AppColors.primaryBlue
                    : AppColors.textPrimary,
                fontWeight: _selectedFilter == filter
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ))
          .toList(),
    );
  }

  /// 📱 메인 바디 구성 (Notifier 상태 기반)
  Widget _buildBody() {
    final testListState = ref.watch(testListNotifierProvider);

    return testListState.when(
      initial: () => const SizedBox(),
      loading: () => _buildLoadingState(),
      loaded: (items, hasMore, currentPage, isLoadingMore) => _buildLoadedState(
        items: items,
        hasMore: hasMore,
        isLoadingMore: isLoadingMore,
      ),
      error: (message) => _buildErrorState(message),
    );
  }

  /// ⏳ 로딩 상태 위젯
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryBlue),
          SizedBox(height: 16),
          Text(
            '인기 테스트를 불러오는 중...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ 로드된 상태 위젯
  Widget _buildLoadedState({
    required List<TestRankingItem> items,
    required bool hasMore,
    required bool isLoadingMore,
  }) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // 헤더 정보
        SliverToBoxAdapter(
          child: _buildHeader(items.length),
        ),

        // 테스트 목록
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.builder(
            itemCount: items.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _buildLoadingIndicator();
              }

              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRankingCard(
                  rank: index + 1,
                  item: item,
                  onTap: () => _onTestItemTap(item),
                ),
              );
            },
          ),
        ),

        // 하단 여백
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  /// ❌ 에러 상태 위젯
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.statusError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.statusError,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '데이터를 불러올 수 없어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📋 헤더 정보 위젯
  Widget _buildHeader(int totalCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedFilter.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFilter.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedFilter.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '총 ${totalCount}개',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📄 빈 상태 위젯
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '테스트를 찾을 수 없어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_selectedFilter.displayName} 데이터가 \n아직 준비되지 않았습니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('새로고침'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⏳ 로딩 인디케이터 (무한 스크롤용)
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: Column(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '더 많은 테스트를 불러오는 중...',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎴 랭킹 카드 위젯 (이미지 수정 포함)
  Widget _buildRankingCard({
    required int rank,
    required TestRankingItem item,
    required VoidCallback onTap,
  }) {
    Color rankColor = _getRankColor(rank);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 좌측 이미지 영역
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary.withOpacity(0.3),
                ),
                child: Stack(
                  children: [
                    _buildImageWithFallback(item),
                    // 랭킹 배지
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: rankColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '$rank위',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 우측 정보 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_formatParticipantCount(item.participantCount)}명 참여',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '⭐ ${item.popularityScore.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 우측 화살표 아이콘
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textTertiary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 랭킹별 색상 반환
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 금색
      case 2:
        return const Color(0xFFC0C0C0); // 은색
      case 3:
        return const Color(0xFFCD7F32); // 동색
      default:
        return AppColors.primaryBlue;
    }
  }

  /// 참여자 수 포맷팅
  String _formatParticipantCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}천';
    } else {
      return count.toString();
    }
  }

  /// 이미지 로딩 및 fallback 처리 (수정된 버전)
  Widget _buildImageWithFallback(TestRankingItem item) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: item.imagePath.isNotEmpty
          ? Image.asset(
        item.imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(item);
        },
      )
          : _buildImagePlaceholder(item),
    );
  }

  /// 이미지 플레이스홀더 (기본 아이콘 표시)
  Widget _buildImagePlaceholder(TestRankingItem item) {
    return Container(
      color: AppColors.backgroundSecondary.withOpacity(0.5),
      child: const Center(
        child: Icon(
            Icons.psychology_outlined,
            size: 40,
            color: AppColors.textTertiary
        ),
      ),
    );
  }

  /// 테스트 아이템 클릭 처리
  void _onTestItemTap(TestRankingItem item) {
    print('🎯 테스트 선택: ${item.title} (ID: ${item.id})');

    // TODO: 실제 테스트 상세 화면으로 네비게이션
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestDetailScreen(testId: item.id),
      ),
    );
    */
  }
}

/// 🔍 랭킹 필터 열거형 (확장된 옵션)
enum RankingFilter {
  popular('🏆', '인기순', '전체 사용자 기준 인기 랭킹'),
  malePopular('👨', '남성 인기순', '남성 사용자 기준 인기 랭킹'),
  femalePopular('👩', '여성 인기순', '여성 사용자 기준 인기 랭킹'),
  recent('🆕', '최신순', '최근 출시된 테스트 순'),
  alphabetical('🔤', '가나다순', '테스트 이름 가나다 순');

  const RankingFilter(this.emoji, this.displayName, this.description);

  final String emoji;
  final String displayName;
  final String description;
}