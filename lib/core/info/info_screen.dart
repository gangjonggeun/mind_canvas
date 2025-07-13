import 'package:flutter/material.dart';
import 'package:mind_canvas/core/theme/app_colors.dart';

import '../htp/htp_dashboard_screen.dart';
import '../htp/htp_drawing_screen.dart';

import 'package:mind_canvas/core/navigation/test_router.dart';
import 'package:mind_canvas/core/factories/test_factory.dart';

import '../psytest/psy_test_screen.dart';


/// 🔍 테스트 정보 화면
/// 
/// 테스트 시작 전 사용자에게 제공되는 정보:
/// - 테스트 제목 및 부제목
/// - 테스트 진행 방법 안내
/// - 시작하기 버튼
/// 
/// 메모리 최적화:
/// - const 생성자 사용
/// - 위젯 재사용 최대화
/// - 이미지 로딩 최적화
class InfoScreen extends StatefulWidget {
  final String testId;
  final String? heroTag; // Hero 애니메이션용
  
  const InfoScreen({
    Key? key,
    required this.testId,
    this.heroTag,
  }) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // TODO: 서버에서 받아올 데이터 (현재는 Mock 데이터)
  TestInfoData? _testInfo;
  bool _isLoading = true;

  // 화면 패딩 상수
  static const double screenPadding = 20.0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadTestInfo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _loadTestInfo() async {
    // TODO: 실제 API 호출로 교체
    // final testInfo = await TestApiService.getTestInfo(widget.testId);
    
    // Mock 데이터 로딩 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _testInfo = _getMockTestInfo(widget.testId);
        _isLoading = false;
      });
      
      _animationController.forward();
    }
  }

  // TODO: 실제 API 연동 시 제거
  TestInfoData _getMockTestInfo(String testId) {
    final mockData = {
      'htp': TestInfoData(
        id: 'htp',
        title: 'HTP 심리검사',
        subtitle: '그림으로 알아보는 나의 심리상태',
        description: '집(House), 나무(Tree), 사람(Person)을 그려서 무의식 속 심리를 분석하는 검사입니다.',
        instructions: [
          '🏠 먼저 집을 자유롭게 그려주세요',
          '🌳 다음으로 나무를 원하는 모양으로 그려주세요', 
          '👤 마지막으로 사람을 그려주세요',
          '⏱️  각 그림당 제한시간은 없으니 편안하게 그리시면 됩니다',
          '🎨 그림 실력은 중요하지 않습니다. 마음대로 표현해주세요',
        ],
        estimatedTime: '15-20분',
        difficulty: '쉬움',
        category: '투사 검사',
        imageUrl: 'assets/images/htp_pageview/htp_intro.png',
      ),
      'mbti': TestInfoData(
        id: 'mbti',
        title: 'MBTI 성격유형 검사',
        subtitle: '16가지 성격유형으로 나를 알아보자',
        description: '세계에서 가장 널리 사용되는 성격유형 검사로, 당신의 성격을 16가지 유형 중 하나로 분류합니다.',
        instructions: [
          '📝 총 60개의 질문에 답하시면 됩니다',
          '🤔 각 질문을 읽고 가장 가까운 답변을 선택해주세요',
          '⚡ 너무 오래 고민하지 말고 직감적으로 답해주세요',
          '🎯 정답은 없으니 솔직하게 답변해주시면 됩니다',
          '📊 완료 후 상세한 성격 분석을 받아보실 수 있습니다',
        ],
        estimatedTime: '10-15분',
        difficulty: '보통',
        category: '성격 검사',
        imageUrl: 'assets/images/persona_pageview/mbti_item_high.png',
      ),
      'persona': TestInfoData(
        id: 'persona',
        title: '페르소나 테스트',
        subtitle: '진짜 나는 누구일까?',
        description: '겉으로 드러나는 모습과 내면의 진짜 모습을 비교 분석하여 당신의 페르소나를 발견합니다.',
        instructions: [
          '🎭 상황별 질문에 솔직하게 답해주세요',
          '🔄 같은 상황에서도 다른 관점의 질문이 나올 수 있습니다',
          '💭 "다른 사람들이 보는 나"와 "내가 아는 나" 두 관점으로 생각해주세요',
          '🎨 결과에서 당신만의 독특한 페르소나를 확인하실 수 있습니다',
          '📈 성장을 위한 개인별 맞춤 조언도 제공됩니다',
        ],
        estimatedTime: '12-18분',
        difficulty: '보통',
        category: '자아 탐색',
        imageUrl: 'assets/images/persona_pageview/persona_intro.png',
      ),
    };
    
    return mockData[testId] ?? TestInfoData(
      id: testId,
      title: '알 수 없는 테스트',
      subtitle: '테스트 정보를 불러올 수 없습니다',
      description: '잠시 후 다시 시도해주세요.',
      instructions: const [],
      estimatedTime: '알 수 없음',
      difficulty: '알 수 없음',
      category: '기타',
      imageUrl: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: _isLoading 
        ? _buildLoadingState()
        : _buildContent(context),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          SizedBox(height: 16),
          Text(
            '테스트 정보를 불러오는 중...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_testInfo == null) return const SizedBox.shrink();
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.backgroundCard,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage(),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryBlue.withOpacity(0.8),
            AppColors.primaryBlue.withOpacity(0.4),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지
          if (_testInfo!.imageUrl.isNotEmpty)
            ClipRRect(
              child: Image.asset(
                _testInfo!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    child: const Icon(
                      Icons.psychology,
                      size: 80,
                      color: AppColors.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          
          // 그라데이션 오버레이
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // 테스트 기본 정보
          Positioned(
            bottom: 60,
            left: screenPadding,
            right: screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _testInfo!.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 제목
                Text(
                  _testInfo!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 부제목
                Text(
                  _testInfo!.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickInfo(),
          
          const SizedBox(height: 32),
          
          _buildDescription(),
          
          const SizedBox(height: 32),
          
          _buildInstructions(),
          
          const SizedBox(height: 40),
          
          _buildStartButton(context),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Card(
      color: AppColors.backgroundCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.access_time,
                label: '소요 시간',
                value: _testInfo!.estimatedTime,
                color: AppColors.primaryBlue,
              ),
            ),
            
            Container(
              width: 1,
              height: 40,
              color: AppColors.borderLight,
            ),
            
            Expanded(
              child: _buildInfoItem(
                icon: Icons.trending_up,
                label: '난이도',
                value: _testInfo!.difficulty,
                color: _getDifficultyColor(_testInfo!.difficulty),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case '쉬움':
        return AppColors.statusSuccess;
      case '보통':
        return AppColors.statusWarning;
      case '어려움':
        return AppColors.statusError;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '테스트 소개',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            _testInfo!.description,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.list_alt,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '진행 방법',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 구분선
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.6),
                AppColors.primaryBlue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        
        const SizedBox(height: 20),
        
        ...List.generate(_testInfo!.instructions.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildInstructionItem(
              step: index + 1,
              instruction: _testInfo!.instructions[index],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInstructionItem({
    required int step,
    required String instruction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 스텝 번호
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 설명 텍스트
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Text(
              instruction,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _startTest(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primaryBlue.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              '테스트 시작하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startTest(BuildContext context) {
    // TODO: 실제 테스트 화면으로 네비게이션
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_testInfo!.title} 시작!'),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const HtpDrawingScreen(
    //       drawingType: 'house',
    //       title: 'Draw a House',
    //     ),
    //   ),
    // );


    // 🏭 Factory + Router 패턴 사용
    TestRouter.navigateToTest(
      context,
      _getTestTypeFromInfo(_testInfo!), // TestInfo에서 TestType으로 변환
    );



  }
}
// 팩토리 테스트 헬퍼
TestType _getTestTypeFromInfo(dynamic testInfo) {
  // 실제로는 testInfo의 id나 type 필드로 판단
  final testId = testInfo.id ?? testInfo.title ?? '';

  if (testId.contains('htp') || testId.contains('그림')) {
    return TestType.htp;
  } else if (testId.contains('mbti')) {
    return TestType.mbti;
  } else if (testId.contains('persona')) {
    return TestType.persona;
  } else {
    return TestType.cognitive;
  }
}

/// 📊 테스트 정보 데이터 모델
/// 
/// 서버에서 받아올 테스트 정보 구조
class TestInfoData {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> instructions;
  final String estimatedTime;
  final String difficulty;
  final String category;
  final String imageUrl;

  const TestInfoData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.instructions,
    required this.estimatedTime,
    required this.difficulty,
    required this.category,
    required this.imageUrl,
  });

  // TODO: 서버 연동 시 fromJson 구현
  factory TestInfoData.fromJson(Map<String, dynamic> json) {
    return TestInfoData(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      instructions: List<String>.from(json['instructions'] ?? []),
      estimatedTime: json['estimatedTime'] ?? '',
      difficulty: json['difficulty'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
