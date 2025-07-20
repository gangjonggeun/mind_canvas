import 'package:flutter/material.dart';

/// 🏆 이상형 월드컵 페이지
/// 
/// 재미있는 테스트를 통한 성격 데이터 수집용 서브 기능
/// - 여러 카테고리 테스트 지원 (음식/영화/여행/음악)
/// - 16강 → 8강 → 4강 → 결승 토너먼트
/// - 선택 기반 성격 데이터 수집 및 분석
/// - 결과를 통한 추천 시스템 개선
class IdealTypeWorldCupPage extends StatefulWidget {
  final String category;

  const IdealTypeWorldCupPage({
    super.key,
    required this.category,
  });

  @override
  State<IdealTypeWorldCupPage> createState() => _IdealTypeWorldCupPageState();
}

class _IdealTypeWorldCupPageState extends State<IdealTypeWorldCupPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardFlipAnimation;

  // 토너먼트 상태
  List<WorldCupItem> _currentRound = [];
  List<WorldCupItem> _winners = [];
  int _currentMatchIndex = 0;
  TournamentStage _currentStage = TournamentStage.round16;
  bool _isGameFinished = false;
  bool _isTransitioning = false;

  // 선택된 데이터 (성격 분석용)
  final Map<String, double> _personalityScores = {};
  final List<String> _selectionHistory = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initializeWorldCup();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 초기화 (메모리 최적화)
  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _cardFlipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  /// 🏆 월드컵 초기화
  void _initializeWorldCup() {
    _currentRound = _generateWorldCupItems(widget.category);
    _currentRound.shuffle(); // 랜덤 순서
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A202C) : const Color(0xFFF7F9FC),
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        child: _isGameFinished ? _buildResultScreen(isDark) : _buildGameScreen(isDark),
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
        _isGameFinished 
          ? '🏆 ${_getCategoryName(widget.category)} 테스트 결과'
          : '🏆 ${_getCategoryName(widget.category)} 이상형 월드컵',
        style: TextStyle(
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (!_isGameFinished)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStageText(),
                  style: const TextStyle(
                    color: Color(0xFF6B73FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 🎮 게임 화면
  Widget _buildGameScreen(bool isDark) {
    if (_isTransitioning) {
      return _buildRoundTransition(isDark);
    }

    if (_currentMatchIndex >= _getCurrentRoundMatches()) {
      return _buildRoundTransition(isDark);
    }

    final leftItem = _currentRound[_currentMatchIndex * 2];
    final rightItem = _currentRound[_currentMatchIndex * 2 + 1];

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 진행률 표시
              _buildProgressIndicator(isDark),
              const SizedBox(height: 24),

              // VS 매치 화면
              Expanded(
                child: Column(
                  children: [
                    // 스테이지 표시
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getStageText()} • ${_currentMatchIndex + 1}/${_getCurrentRoundMatches()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 대결 카드들
                    Expanded(
                      child: Row(
                        children: [
                          // 왼쪽 선택지
                          Expanded(
                            child: _buildChoiceCard(leftItem, true, isDark),
                          ),
                          
                          // VS 표시
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2D3748) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'VS',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6B73FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 오른쪽 선택지
                          Expanded(
                            child: _buildChoiceCard(rightItem, false, isDark),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎭 선택 카드 위젯 (메모리 최적화)
  Widget _buildChoiceCard(WorldCupItem item, bool isLeft, bool isDark) {
    return GestureDetector(
      onTap: () => _makeChoice(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(
          left: isLeft ? 0 : 8,
          right: isLeft ? 8 : 0,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3748) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 이미지/아이콘 영역
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withOpacity(0.1),
                      item.color.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 텍스트 영역
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 진행률 표시
  Widget _buildProgressIndicator(bool isDark) {
    final totalMatches = _getTotalMatches();
    final completedMatches = _getCompletedMatches();
    final progress = completedMatches / totalMatches;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '매치 ${completedMatches + 1} / $totalMatches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% 완료',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: isDark ? const Color(0xFF4A5568) : const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
          minHeight: 6,
        ),
      ],
    );
  }

  /// 🔄 라운드 전환 화면
  Widget _buildRoundTransition(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D3748) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 64,
                  color: Color(0xFF6B73FF),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_getStageText()} 완료!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '진출: ${_winners.length}개',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _proceedToNextRound,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _getNextStageText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🏆 결과 화면
  Widget _buildResultScreen(bool isDark) {
    final winner = _winners.isNotEmpty ? _winners.first : _currentRound.first;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 우승 카드
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B73FF),
                    Color(0xFF9F7AEA),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '🏆 우승!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    winner.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    winner.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 성격 분석 요약
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🧠 취향 분석 완료',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _generatePersonalityInsight(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '이 데이터는 더 정확한 추천을 위해 활용됩니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // 액션 버튼들
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _restartWorldCup,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('다시 플레이'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF6B73FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    foregroundColor: const Color(0xFF6B73FF),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _goToRecommendations,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('맞춤 추천 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  /// 🎯 게임 로직 메서드들
  void _makeChoice(WorldCupItem chosen) {
    // 성격 점수 누적 (메모리 효율적으로)
    for (final tag in chosen.personalityTags) {
      _personalityScores[tag.trait] = 
        (_personalityScores[tag.trait] ?? 0.0) + tag.weight;
    }
    
    // 선택 기록 (데이터 수집용)
    _selectionHistory.add(chosen.id);

    _winners.add(chosen);
    _currentMatchIndex++;

    if (_currentMatchIndex >= _getCurrentRoundMatches()) {
      // 라운드 완료
      if (_winners.length == 1) {
        // 게임 종료
        setState(() {
          _isGameFinished = true;
        });
      } else {
        // 다음 라운드 준비
        setState(() {
          _isTransitioning = true;
        });
        
        // 애니메이션 후 다음 라운드로
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _currentRound = List.from(_winners);
            _winners.clear();
            _currentMatchIndex = 0;
            _currentStage = _getNextStage();
            _isTransitioning = false;
          });
          _restartAnimation();
        });
      }
    }

    _restartAnimation();
  }

  void _proceedToNextRound() {
    setState(() {
      _currentRound = List.from(_winners);
      _winners.clear();
      _currentMatchIndex = 0;
      _currentStage = _getNextStage();
      _isTransitioning = false;
    });
    _restartAnimation();
  }

  void _restartWorldCup() {
    setState(() {
      _initializeWorldCup();
      _winners.clear();
      _currentMatchIndex = 0;
      _currentStage = TournamentStage.round16;
      _isGameFinished = false;
      _isTransitioning = false;
      _personalityScores.clear();
      _selectionHistory.clear();
    });
    _restartAnimation();
  }

  void _goToRecommendations() {
    // TODO: 성격 분석 결과를 서버로 전송 후 추천 화면으로 이동
    Navigator.of(context).pop();
  }

  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  /// 🔧 유틸리티 메서드들
  String _getCategoryName(String category) {
    const categoryNames = {
      'food': '음식',
      'travel': '여행',
      'movie': '영화',
      'music': '음악',
    };
    return categoryNames[category] ?? category;
  }

  String _getStageText() {
    switch (_currentStage) {
      case TournamentStage.round16:
        return '16강';
      case TournamentStage.round8:
        return '8강';
      case TournamentStage.round4:
        return '준결승';
      case TournamentStage.final_round:
        return '결승';
    }
  }

  String _getNextStageText() {
    switch (_currentStage) {
      case TournamentStage.round16:
        return '8강 진출!';
      case TournamentStage.round8:
        return '준결승 진출!';
      case TournamentStage.round4:
        return '결승 진출!';
      case TournamentStage.final_round:
        return '우승 결정!';
    }
  }

  int _getCurrentRoundMatches() => _currentRound.length ~/ 2;
  int _getTotalMatches() => 15; // 16강(8) + 8강(4) + 준결승(2) + 결승(1)

  int _getCompletedMatches() {
    int completed = 0;
    switch (_currentStage) {
      case TournamentStage.round16:
        completed = _currentMatchIndex;
        break;
      case TournamentStage.round8:
        completed = 8 + _currentMatchIndex;
        break;
      case TournamentStage.round4:
        completed = 12 + _currentMatchIndex;
        break;
      case TournamentStage.final_round:
        completed = 14 + _currentMatchIndex;
        break;
    }
    return completed;
  }

  TournamentStage _getNextStage() {
    switch (_currentStage) {
      case TournamentStage.round16:
        return TournamentStage.round8;
      case TournamentStage.round8:
        return TournamentStage.round4;
      case TournamentStage.round4:
        return TournamentStage.final_round;
      case TournamentStage.final_round:
        return TournamentStage.final_round;
    }
  }

  String _generatePersonalityInsight() {
    final insights = [
      '모험적이고 새로운 경험을 선호하는 성향을 보입니다.',
      '안정적이고 계획적인 선택을 좋아하는 스타일이네요.',
      '창의적이고 예술적인 감각이 뛰어난 것 같습니다.',
      '사회적이고 활동적인 라이프스타일을 선호하시는군요.',
      '세심하고 꼼꼼한 성격이 드러나는 선택이었습니다.',
    ];
    insights.shuffle();
    return insights.first;
  }

  /// 📊 Mock 데이터 생성 (메모리 효율적으로)
  List<WorldCupItem> _generateWorldCupItems(String category) {
    switch (category) {
      case 'food':
        return _generateFoodItems();
      case 'travel':
        return _generateTravelItems();
      case 'movie':
        return _generateMovieItems();
      case 'music':
        return _generateMusicItems();
      default:
        return _generateFoodItems();
    }
  }

  List<WorldCupItem> _generateFoodItems() {
    return [
      // 한식
      const WorldCupItem(
        id: 'korean',
        title: '한식',
        subtitle: '따뜻한 집밥',
        emoji: '🍚',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'traditional', weight: 0.8),
          PersonalityTag(trait: 'comfort', weight: 0.7),
        ],
      ),
      // 이탈리아
      const WorldCupItem(
        id: 'italian',
        title: '이탈리아',
        subtitle: '파스타 & 피자',
        emoji: '🍝',
        color: Color(0xFFE53E3E),
        personalityTags: [
          PersonalityTag(trait: 'social', weight: 0.7),
          PersonalityTag(trait: 'passionate', weight: 0.6),
        ],
      ),
      // 일식
      const WorldCupItem(
        id: 'japanese',
        title: '일식',
        subtitle: '정교하고 깔끔한',
        emoji: '🍣',
        color: Color(0xFF3182CE),
        personalityTags: [
          PersonalityTag(trait: 'precision', weight: 0.9),
          PersonalityTag(trait: 'minimalist', weight: 0.8),
        ],
      ),
      // 중식
      const WorldCupItem(
        id: 'chinese',
        title: '중식',
        subtitle: '다양하고 풍부한',
        emoji: '🥢',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'variety', weight: 0.8),
          PersonalityTag(trait: 'social', weight: 0.7),
        ],
      ),
      // 태국
      const WorldCupItem(
        id: 'thai',
        title: '태국',
        subtitle: '매콤하고 향신료',
        emoji: '🌶️',
        color: Color(0xFF38A169),
        personalityTags: [
          PersonalityTag(trait: 'adventurous', weight: 0.9),
          PersonalityTag(trait: 'bold', weight: 0.8),
        ],
      ),
      // 멕시칸
      const WorldCupItem(
        id: 'mexican',
        title: '멕시칸',
        subtitle: '활기찬 라틴',
        emoji: '🌮',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'energetic', weight: 0.8),
          PersonalityTag(trait: 'fun', weight: 0.7),
        ],
      ),
      // 인도
      const WorldCupItem(
        id: 'indian',
        title: '인도',
        subtitle: '향신료의 조합',
        emoji: '🍛',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'complex', weight: 0.8),
          PersonalityTag(trait: 'cultural', weight: 0.7),
        ],
      ),
      // 지중해
      const WorldCupItem(
        id: 'mediterranean',
        title: '지중해',
        subtitle: '건강하고 신선한',
        emoji: '🫒',
        color: Color(0xFF38A169),
        personalityTags: [
          PersonalityTag(trait: 'healthy', weight: 0.9),
          PersonalityTag(trait: 'natural', weight: 0.8),
        ],
      ),
      // 베트남
      const WorldCupItem(
        id: 'vietnamese',
        title: '베트남',
        subtitle: '깔끔하고 건강한',
        emoji: '🍜',
        color: Color(0xFF38A169),
        personalityTags: [
          PersonalityTag(trait: 'light', weight: 0.8),
          PersonalityTag(trait: 'balanced', weight: 0.7),
        ],
      ),
      // 패스트푸드
      const WorldCupItem(
        id: 'fastfood',
        title: '패스트푸드',
        subtitle: '빠르고 간편한',
        emoji: '🍔',
        color: Color(0xFFE53E3E),
        personalityTags: [
          PersonalityTag(trait: 'convenience', weight: 0.9),
          PersonalityTag(trait: 'casual', weight: 0.8),
        ],
      ),
      // 디저트
      const WorldCupItem(
        id: 'dessert',
        title: '디저트',
        subtitle: '달콤한 행복',
        emoji: '🍰',
        color: Color(0xFFE53E3E),
        personalityTags: [
          PersonalityTag(trait: 'sweet', weight: 0.9),
          PersonalityTag(trait: 'indulgent', weight: 0.8),
        ],
      ),
      // 비건
      const WorldCupItem(
        id: 'vegan',
        title: '비건',
        subtitle: '자연 친화적',
        emoji: '🥗',
        color: Color(0xFF38A169),
        personalityTags: [
          PersonalityTag(trait: 'conscious', weight: 0.9),
          PersonalityTag(trait: 'ethical', weight: 0.8),
        ],
      ),
      // 길거리음식
      const WorldCupItem(
        id: 'street',
        title: '길거리음식',
        subtitle: '서민적이고 친근한',
        emoji: '🌭',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'authentic', weight: 0.8),
          PersonalityTag(trait: 'casual', weight: 0.7),
        ],
      ),
      // 파인다이닝
      const WorldCupItem(
        id: 'fine_dining',
        title: '파인다이닝',
        subtitle: '고급스러운 미식',
        emoji: '🍾',
        color: Color(0xFF805AD5),
        personalityTags: [
          PersonalityTag(trait: 'luxury', weight: 0.9),
          PersonalityTag(trait: 'sophisticated', weight: 0.8),
        ],
      ),
      // 브런치
      const WorldCupItem(
        id: 'brunch',
        title: '브런치',
        subtitle: '여유로운 식사',
        emoji: '🥞',
        color: Color(0xFFD69E2E),
        personalityTags: [
          PersonalityTag(trait: 'relaxed', weight: 0.8),
          PersonalityTag(trait: 'trendy', weight: 0.7),
        ],
      ),
      // 바베큐
      const WorldCupItem(
        id: 'bbq',
        title: '바베큐',
        subtitle: '불맛과 함께',
        emoji: '🔥',
        color: Color(0xFFE53E3E),
        personalityTags: [
          PersonalityTag(trait: 'social', weight: 0.8),
          PersonalityTag(trait: 'outdoor', weight: 0.7),
        ],
      ),
    ];
  }

  List<WorldCupItem> _generateTravelItems() {
    // TODO: 여행 아이템들 (현재는 간단한 예시)
    return [];
  }

  List<WorldCupItem> _generateMovieItems() {
    // TODO: 영화 아이템들
    return [];
  }

  List<WorldCupItem> _generateMusicItems() {
    // TODO: 음악 아이템들
    return [];
  }
}

/// 🏆 토너먼트 단계
enum TournamentStage {
  round16,
  round8,
  round4,
  final_round,
}

/// 🎭 월드컵 아이템 모델 (메모리 효율적)
class WorldCupItem {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<PersonalityTag> personalityTags;

  const WorldCupItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.personalityTags,
  });
}

/// 🧠 성격 태그 모델
class PersonalityTag {
  final String trait;
  final double weight;

  const PersonalityTag({
    required this.trait,
    required this.weight,
  });
}
