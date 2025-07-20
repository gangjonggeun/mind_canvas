import 'package:flutter/material.dart';

/// 🧠 성격 기반 컨텐츠 추천 페이지
/// 
/// 드라마/영화/게임/소설/음악 카테고리별 맞춤 추천
/// - Mock 벡터 코사인 유사도 기반 추천
/// - 추천 이유 및 성격 분석 설명
/// - 카테고리별 필터링 및 정렬
class PersonalityRecommendationsPage extends StatefulWidget {
  final String? initialCategory;
  
  const PersonalityRecommendationsPage({
    super.key,
    this.initialCategory,
  });

  @override
  State<PersonalityRecommendationsPage> createState() => _PersonalityRecommendationsPageState();
}

class _PersonalityRecommendationsPageState extends State<PersonalityRecommendationsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // 컨텐츠 카테고리들 (드라마/영화/게임/소설/음악)
  final List<ContentCategory> _categories = [
    ContentCategory(
      id: 'drama_movie',
      name: '드라마 & 영화',
      emoji: '🎬',
      color: const Color(0xFFE53E3E),
    ),
    ContentCategory(
      id: 'game',
      name: '게임',
      emoji: '🎮',
      color: const Color(0xFF3182CE),
    ),
    ContentCategory(
      id: 'book_webtoon',
      name: '소설 & 웹툰',
      emoji: '📚',
      color: const Color(0xFFD69E2E),
    ),
    ContentCategory(
      id: 'music_playlist',
      name: '음악 & 플레이리스트',
      emoji: '🎵',
      color: const Color(0xFF805AD5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTabController();
    _initAnimations();
  }

  void _initTabController() {
    final initialIndex = widget.initialCategory != null
        ? _categories.indexWhere((cat) => cat.id == widget.initialCategory)
        : 0;
    
    _tabController = TabController(
      length: _categories.length, 
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 초기화
  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A202C) : const Color(0xFFF7F9FC),
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // 성격 프로필 요약
            _buildPersonalityProfile(isDark),
            
            // 카테고리 탭바
            _buildCategoryTabs(isDark),
            
            // 추천 결과 목록
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  return _buildRecommendationList(category, isDark);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 앱바 구성
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
        ),
      ),
      title: Text(
        '🎯 성격 기반 컨텐츠 추천',
        style: TextStyle(
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showRecommendationSettings(isDark),
          icon: Icon(
            Icons.tune,
            color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// 👤 성격 프로필 요약
  Widget _buildPersonalityProfile(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4ECDC4),
            Color(0xFF44A08D),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신의 성격 프로필',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'AI 분석 완료 · 94% 정확도',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 성격 특성 태그들
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPersonalityTag('🎨 창의적', 0.89),
              _buildPersonalityTag('🤝 사교적', 0.76),
              _buildPersonalityTag('📝 계획적', 0.82),
              _buildPersonalityTag('🌟 모험적', 0.71),
              _buildPersonalityTag('💡 호기심', 0.94),
            ],
          ),
        ],
      ),
    );
  }

  /// 🏷️ 성격 태그 위젯
  Widget _buildPersonalityTag(String label, double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${(score * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// 📑 카테고리 탭바
  Widget _buildCategoryTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF4ECDC4).withOpacity(0.1),
        ),
        labelColor: const Color(0xFF4ECDC4),
        unselectedLabelColor: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: _categories.map((category) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.emoji),
                const SizedBox(width: 6),
                Text(category.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 📋 추천 결과 목록
  Widget _buildRecommendationList(ContentCategory category, bool isDark) {
    final recommendations = _generateRecommendations(category);
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: recommendations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildRecommendationCard(recommendations[index], isDark);
      },
    );
  }

  /// 🎭 추천 카드 위젯
  Widget _buildRecommendationCard(ContentRecommendation item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (제목 + 유사도)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.genre,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (item.year != null)
                          Text(
                            '· ${item.year}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 14,
                      color: item.category.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(item.similarity * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 설명
          Text(
            item.description,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? const Color(0xFFCBD5E0) : const Color(0xFF4A5568),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          // 추천 이유
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: item.category.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.reason,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 태그들
          if (item.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: item.category.color,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // 액션 버튼들
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _saveRecommendation(item),
                  icon: const Icon(Icons.bookmark_border, size: 16),
                  label: const Text('저장'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: item.category.color,
                    side: BorderSide(color: item.category.color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exploreRecommendation(item),
                  icon: const Icon(Icons.explore, size: 16),
                  label: const Text('자세히'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.category.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 추천 설정 다이얼로그
  void _showRecommendationSettings(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3748) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚙️ 추천 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF4ECDC4)),
              title: Text(
                '추천 새로고침',
                style: TextStyle(
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                ),
              ),
              subtitle: Text(
                '최신 데이터로 다시 분석',
                style: TextStyle(
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _refreshRecommendations();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.tune, color: Color(0xFF6B73FF)),
              title: Text(
                '필터 설정',
                style: TextStyle(
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                ),
              ),
              subtitle: Text(
                '관심 분야 및 장르 조정',
                style: TextStyle(
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showFilterSettings();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.feedback, color: Color(0xFF9F7AEA)),
              title: Text(
                '피드백 제공',
                style: TextStyle(
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                ),
              ),
              subtitle: Text(
                '추천 정확도 개선에 도움',
                style: TextStyle(
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 액션 메서드들
  void _saveRecommendation(ContentRecommendation item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💾 "${item.title}" 추천이 저장되었습니다'),
        backgroundColor: item.category.color,
      ),
    );
  }

  void _exploreRecommendation(ContentRecommendation item) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D3748) : Colors.white,
          title: Text(
            item.title,
            style: TextStyle(
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.genre} · ${item.year ?? ""}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: item.category.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: TextStyle(
                  color: isDark ? const Color(0xFFCBD5E0) : const Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '추천 이유:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.reason,
                style: TextStyle(
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _refreshRecommendations() {
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 추천이 새로고침되었습니다'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
  }

  void _showFilterSettings() {
    // TODO: 필터 설정 화면
  }

  void _showFeedbackDialog() {
    // TODO: 피드백 다이얼로그
  }

  /// 📊 Mock 데이터 생성 (실제로는 서버 벡터 유사도 기반)
  List<ContentRecommendation> _generateRecommendations(ContentCategory category) {
    switch (category.id) {
      case 'drama_movie':
        return [
          ContentRecommendation(
            id: 'stranger_things',
            title: '스트레인저 씽즈',
            genre: 'SF 스릴러',
            year: '2016',
            description: '1980년대 작은 마을에서 벌어지는 초자연적 현상과 우정을 그린 넷플릭스 오리지널 시리즈입니다. 호기심 많은 성격과 모험을 좋아하는 당신에게 완벽한 작품입니다.',
            reason: '당신의 높은 호기심 지수(94%)와 모험적 성향(71%)이 이 작품의 미스터리한 요소와 잘 맞습니다.',
            similarity: 0.94,
            category: category,
            tags: ['미스터리', '우정', '성장', '80년대'],
          ),
          ContentRecommendation(
            id: 'parasite',
            title: '기생충',
            genre: '블랙 코미디',
            year: '2019',
            description: '계급 갈등을 날카롭게 그린 봉준호 감독의 칸 영화제 황금종려상 수상작입니다. 창의적이고 깊이 있는 사고를 좋아하는 당신에게 추천합니다.',
            reason: '창의적 성향(89%)과 사회적 관심이 높은 당신의 성격에 매우 적합한 작품입니다.',
            similarity: 0.91,
            category: category,
            tags: ['사회비판', '블랙코미디', '한국영화', '아카데미'],
          ),
          ContentRecommendation(
            id: 'her',
            title: '그녀 (Her)',
            genre: '로맨스 드라마',
            year: '2013',
            description: 'AI와 인간의 사랑을 그린 스파이크 존즈 감독의 작품입니다. 기술과 감정에 대한 깊이 있는 사색을 담고 있어 계획적이고 사색적인 성향에 잘 맞습니다.',
            reason: '계획적 성향(82%)과 깊이 있는 사고를 선호하는 당신에게 완벽한 영화입니다.',
            similarity: 0.88,
            category: category,
            tags: ['AI', '미래', '철학적', '감성'],
          ),
        ];
      
      case 'game':
        return [
          ContentRecommendation(
            id: 'stardew_valley',
            title: '스타듀 밸리',
            genre: '시뮬레이션',
            year: '2016',
            description: '평화로운 농장 생활을 즐길 수 있는 힐링 게임입니다. 계획적이고 꾸준한 성격의 당신에게 완벽한 게임입니다.',
            reason: '계획적 성향(82%)과 꾸준함을 중시하는 성격에 매우 잘 맞는 게임입니다.',
            similarity: 0.92,
            category: category,
            tags: ['힐링', '농장', '건설', '인디게임'],
          ),
          ContentRecommendation(
            id: 'zelda_botw',
            title: '젤다의 전설: 야생의 숨결',
            genre: '어드벤처',
            year: '2017',
            description: '광활한 오픈월드를 자유롭게 탐험하며 모험을 즐기는 게임입니다. 모험적이고 창의적인 당신의 성격에 딱 맞습니다.',
            reason: '모험적 성향(71%)과 창의적 사고(89%)를 만족시키는 완벽한 게임입니다.',
            similarity: 0.89,
            category: category,
            tags: ['오픈월드', '모험', '퍼즐', '닌텐도'],
          ),
        ];
      
      case 'book_webtoon':
        return [
          ContentRecommendation(
            id: 'dalguet_dream_store',
            title: '달러구트 꿈 백화점',
            genre: '판타지 소설',
            year: '2020',
            description: '꿈을 사고파는 신비로운 백화점을 그린 따뜻한 판타지 소설입니다. 창의적이고 상상력이 풍부한 당신에게 추천합니다.',
            reason: '창의적 성향(89%)과 상상력을 중시하는 성격에 완벽하게 맞는 작품입니다.',
            similarity: 0.93,
            category: category,
            tags: ['판타지', '따뜻함', '상상력', '힐링'],
          ),
          ContentRecommendation(
            id: 'tower_of_god',
            title: '신의 탑',
            genre: '액션 웹툰',
            year: '2010',
            description: '탑을 오르며 벌어지는 치열한 생존 게임을 그린 대표적인 한국 웹툰입니다. 모험적이고 도전을 좋아하는 성격에 적합합니다.',
            reason: '모험적 성향(71%)과 도전 정신이 강한 당신에게 완벽한 웹툰입니다.',
            similarity: 0.87,
            category: category,
            tags: ['액션', '모험', '성장', '한국웹툰'],
          ),
        ];
      
      case 'music_playlist':
        return [
          ContentRecommendation(
            id: 'lofi_study',
            title: 'Lo-fi Study Beats',
            genre: '앰비언트',
            year: null,
            description: '집중력 향상에 도움이 되는 차분한 Lo-fi 플레이리스트입니다. 계획적이고 집중력이 좋은 당신에게 추천합니다.',
            reason: '계획적 성향(82%)과 집중을 중시하는 성격에 완벽하게 맞는 음악입니다.',
            similarity: 0.90,
            category: category,
            tags: ['집중', '스터디', 'Lo-fi', '차분함'],
          ),
          ContentRecommendation(
            id: 'indie_folk',
            title: 'Indie Folk Vibes',
            genre: '인디 포크',
            year: null,
            description: '따뜻하고 감성적인 인디 포크 플레이리스트입니다. 창의적이고 감성적인 당신의 취향에 딱 맞습니다.',
            reason: '창의적 성향(89%)과 감성을 중시하는 성격에 매우 적합한 음악입니다.',
            similarity: 0.86,
            category: category,
            tags: ['인디', '감성', '어쿠스틱', '따뜻함'],
          ),
        ];
      
      default:
        return [];
    }
  }
}

/// 📂 컨텐츠 카테고리 모델
class ContentCategory {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const ContentCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

/// 🎯 컨텐츠 추천 모델
class ContentRecommendation {
  final String id;
  final String title;
  final String genre;
  final String? year;
  final String description;
  final String reason;
  final double similarity;
  final ContentCategory category;
  final List<String> tags;

  const ContentRecommendation({
    required this.id,
    required this.title,
    required this.genre,
    this.year,
    required this.description,
    required this.reason,
    required this.similarity,
    required this.category,
    this.tags = const [],
  });
}
