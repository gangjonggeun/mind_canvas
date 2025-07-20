import 'package:flutter/material.dart';

/// 👥 사용자 컨텐츠 추천 페이지
/// 
/// 비슷한 성격의 사용자들간 상호 추천 및 피드백 시스템
/// - 성격 유사도 기반 사용자 매칭
/// - 사용자가 추천한 컨텐츠 목록
/// - 추천에 대한 피드백 (도움됨/안됨)
/// - 내가 다른 사용자들에게 추천하기
class UserRecommendationPage extends StatefulWidget {
  const UserRecommendationPage({super.key});

  @override
  State<UserRecommendationPage> createState() => _UserRecommendationPageState();
}

class _UserRecommendationPageState extends State<UserRecommendationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _tabs = ['받은 추천', '내 추천', '피드백'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _initAnimations();
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
            // 유사도 프로필 요약
            _buildSimilarityProfile(isDark),
            
            // 탭바
            _buildTabBar(isDark),
            
            // 탭 컨텐츠
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReceivedRecommendations(isDark),
                  _buildMyRecommendations(isDark),
                  _buildFeedbackHistory(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDark),
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
        '👥 사용자 추천',
        style: TextStyle(
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showRecommendationTips(isDark),
          icon: Icon(
            Icons.help_outline,
            color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// 👤 유사도 프로필 요약
  Widget _buildSimilarityProfile(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9F7AEA),
            Color(0xFF667EEA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9F7AEA).withOpacity(0.3),
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
                  Icons.people,
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
                      '비슷한 성격 사용자들',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '47명의 유사한 성격 사용자 발견',
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
          
          // 상위 유사 사용자들
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final users = [
                  {'name': '김민수', 'similarity': '94%', 'personality': '창의적'},
                  {'name': '박지은', 'similarity': '91%', 'personality': '사교적'},
                  {'name': '이준호', 'similarity': '89%', 'personality': '계획적'},
                  {'name': '최서연', 'similarity': '87%', 'personality': '모험적'},
                  {'name': '정다현', 'similarity': '85%', 'personality': '호기심'},
                ];
                
                final user = users[index];
                return Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: Text(
                          user['name']![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['name']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user['similarity']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 📑 탭바
  Widget _buildTabBar(bool isDark) {
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
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF9F7AEA).withOpacity(0.1),
        ),
        labelColor: const Color(0xFF9F7AEA),
        unselectedLabelColor: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  /// 📨 받은 추천 탭
  Widget _buildReceivedRecommendations(bool isDark) {
    final recommendations = _getMockReceivedRecommendations();
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: recommendations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildRecommendationCard(recommendations[index], isDark);
      },
    );
  }

  /// 📤 내 추천 탭
  Widget _buildMyRecommendations(bool isDark) {
    final myRecommendations = _getMockMyRecommendations();
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: myRecommendations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildMyRecommendationCard(myRecommendations[index], isDark);
      },
    );
  }

  /// 📊 피드백 히스토리 탭
  Widget _buildFeedbackHistory(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 피드백 통계
          Container(
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
                Text(
                  '📊 추천 성과',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('👍 도움됨', '23', '78%', const Color(0xFF38A169), isDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('👎 안됨', '7', '22%', const Color(0xFFE53E3E), isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('📝 총 추천', '30', '개', const Color(0xFF9F7AEA), isDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('⭐ 평균 점수', '4.2', '/5.0', const Color(0xFFD69E2E), isDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // 최근 피드백 목록
          Expanded(
            child: Container(
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
                  Text(
                    '📋 최근 피드백',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 5,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final feedbacks = [
                          {'user': '김민수', 'content': '스트레인저 씽즈', 'feedback': '도움됨', 'score': '5'},
                          {'user': '박지은', 'content': 'Lo-fi 플레이리스트', 'feedback': '도움됨', 'score': '4'},
                          {'user': '이준호', 'content': '스타듀 밸리', 'feedback': '도움됨', 'score': '5'},
                          {'user': '최서연', 'content': '기생충', 'feedback': '안됨', 'score': '2'},
                          {'user': '정다현', 'content': '달러구트 꿈 백화점', 'feedback': '도움됨', 'score': '4'},
                        ];
                        
                        final feedback = feedbacks[index];
                        final isPositive = feedback['feedback'] == '도움됨';
                        
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isPositive 
                                  ? const Color(0xFF38A169).withOpacity(0.2)
                                  : const Color(0xFFE53E3E).withOpacity(0.2),
                                child: Text(
                                  feedback['user']![0],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isPositive ? const Color(0xFF38A169) : const Color(0xFFE53E3E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${feedback['user']} → ${feedback['content']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                                      ),
                                    ),
                                    Text(
                                      '${feedback['feedback']} (${feedback['score']}/5)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isPositive ? const Color(0xFF38A169) : const Color(0xFFE53E3E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 통계 카드
  Widget _buildStatCard(String title, String value, String subtitle, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎭 추천 카드 위젯
  Widget _buildRecommendationCard(UserRecommendation recommendation, bool isDark) {
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
          // 추천자 정보
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF9F7AEA).withOpacity(0.2),
                child: Text(
                  recommendation.recommenderName[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9F7AEA),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.recommenderName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      '유사도 ${recommendation.similarity}% • ${recommendation.personalityMatch}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recommendation.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9F7AEA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 추천 컨텐츠
          Text(
            recommendation.contentTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.description,
            style: TextStyle(
              fontSize: 14,
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
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Color(0xFF9F7AEA),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${recommendation.reason}"',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 액션 버튼들
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _provideFeedback(recommendation, false),
                  icon: const Icon(Icons.thumb_down, size: 16),
                  label: const Text('별로'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53E3E),
                    side: const BorderSide(color: Color(0xFFE53E3E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _provideFeedback(recommendation, true),
                  icon: const Icon(Icons.thumb_up, size: 16),
                  label: const Text('도움됨'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38A169),
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

  /// 📝 내 추천 카드 위젯
  Widget _buildMyRecommendationCard(MyRecommendation recommendation, bool isDark) {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.contentTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recommendation.targetCount}명에게 추천',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getFeedbackColor(recommendation.feedbackScore).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⭐ ${recommendation.feedbackScore.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getFeedbackColor(recommendation.feedbackScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation.description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFCBD5E0) : const Color(0xFF4A5568),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          // 피드백 요약
          Row(
            children: [
              Icon(
                Icons.thumb_up,
                size: 16,
                color: const Color(0xFF38A169),
              ),
              const SizedBox(width: 4),
              Text(
                '${recommendation.positiveCount}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF38A169),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.thumb_down,
                size: 16,
                color: const Color(0xFFE53E3E),
              ),
              const SizedBox(width: 4),
              Text(
                '${recommendation.negativeCount}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE53E3E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                recommendation.createdAt,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🎯 플로팅 액션 버튼
  Widget _buildFloatingActionButton(bool isDark) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateRecommendationDialog(isDark),
      backgroundColor: const Color(0xFF9F7AEA),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        '추천하기',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 📊 피드백 색상
  Color _getFeedbackColor(double score) {
    if (score >= 4.0) return const Color(0xFF38A169);
    if (score >= 3.0) return const Color(0xFFD69E2E);
    return const Color(0xFFE53E3E);
  }

  /// 🎯 액션 메서드들
  void _provideFeedback(UserRecommendation recommendation, bool isPositive) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPositive 
            ? '👍 "${recommendation.contentTitle}" 추천이 도움이 되었다고 표시했습니다'
            : '👎 "${recommendation.contentTitle}" 추천이 별로라고 표시했습니다',
        ),
        backgroundColor: isPositive ? const Color(0xFF38A169) : const Color(0xFFE53E3E),
      ),
    );
  }

  void _showCreateRecommendationDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D3748) : Colors.white,
        title: Text(
          '새 추천 작성',
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '컨텐츠 제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '추천 이유',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📝 추천이 등록되었습니다!'),
                  backgroundColor: Color(0xFF9F7AEA),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9F7AEA),
            ),
            child: const Text('등록'),
          ),
        ],
      ),
    );
  }

  void _showRecommendationTips(bool isDark) {
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
              '💡 추천 팁',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildTipItem('🎯', '구체적인 이유를 포함해서 추천해주세요'),
            _buildTipItem('💝', '자신이 정말 좋아하는 컨텐츠를 추천해주세요'),
            _buildTipItem('🔍', '비슷한 성격의 사람이 좋아할만한 것을 생각해보세요'),
            _buildTipItem('📝', '솔직한 피드백으로 추천 품질을 높여주세요'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFCBD5E0) : const Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 Mock 데이터 생성
  List<UserRecommendation> _getMockReceivedRecommendations() {
    return [
      UserRecommendation(
        id: '1',
        recommenderName: '김민수',
        similarity: 94,
        personalityMatch: '창의적 성향',
        category: '드라마',
        contentTitle: '스트레인저 씽즈',
        description: '80년대 배경의 초자연적 스릴러 드라마. 호기심 많고 모험을 좋아하는 성격에 완벽해요!',
        reason: '당신처럼 창의적이고 호기심이 많은 분이라면 이 드라마의 미스터리한 요소를 정말 좋아하실 것 같아요.',
      ),
      UserRecommendation(
        id: '2',
        recommenderName: '박지은',
        similarity: 91,
        personalityMatch: '사교적 성향',
        category: '음악',
        contentTitle: 'Indie Folk 플레이리스트',
        description: '차분하고 감성적인 인디 포크 음악 모음. 혼자만의 시간을 소중히 여기는 당신에게 추천해요.',
        reason: '저도 비슷한 성격인데, 이 플레이리스트를 들으면서 정말 많은 영감을 받았어요. 창작 활동할 때 특히 좋더라구요.',
      ),
      UserRecommendation(
        id: '3',
        recommenderName: '이준호',
        similarity: 89,
        personalityMatch: '계획적 성향',
        category: '게임',
        contentTitle: '스타듀 밸리',
        description: '농장을 가꾸며 차근차근 발전시켜 나가는 힐링 게임. 계획적인 성격에 딱 맞아요.',
        reason: '계획 세우는 걸 좋아하시는 분이라면 농장을 체계적으로 발전시켜 나가는 재미를 느끼실 거예요.',
      ),
    ];
  }

  List<MyRecommendation> _getMockMyRecommendations() {
    return [
      MyRecommendation(
        id: '1',
        contentTitle: '기생충',
        description: '봉준호 감독의 계급 갈등을 다룬 블랙 코미디 영화. 사회적 메시지가 깊어요.',
        targetCount: 12,
        positiveCount: 9,
        negativeCount: 3,
        feedbackScore: 4.2,
        createdAt: '3일 전',
      ),
      MyRecommendation(
        id: '2',
        contentTitle: 'Lo-fi Study Beats',
        description: '집중력 향상에 도움이 되는 차분한 음악 모음집.',
        targetCount: 8,
        positiveCount: 7,
        negativeCount: 1,
        feedbackScore: 4.6,
        createdAt: '1주 전',
      ),
    ];
  }
}

/// 👥 사용자 추천 모델
class UserRecommendation {
  final String id;
  final String recommenderName;
  final int similarity;
  final String personalityMatch;
  final String category;
  final String contentTitle;
  final String description;
  final String reason;

  const UserRecommendation({
    required this.id,
    required this.recommenderName,
    required this.similarity,
    required this.personalityMatch,
    required this.category,
    required this.contentTitle,
    required this.description,
    required this.reason,
  });
}

/// 📝 내 추천 모델
class MyRecommendation {
  final String id;
  final String contentTitle;
  final String description;
  final int targetCount;
  final int positiveCount;
  final int negativeCount;
  final double feedbackScore;
  final String createdAt;

  const MyRecommendation({
    required this.id,
    required this.contentTitle,
    required this.description,
    required this.targetCount,
    required this.positiveCount,
    required this.negativeCount,
    required this.feedbackScore,
    required this.createdAt,
  });
}
