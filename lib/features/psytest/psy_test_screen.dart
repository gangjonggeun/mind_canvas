// lib/features/psytest/presentation/screens/psy_test_screen.dart

import 'package:flutter/material.dart';

import '../psy_result/psy_result_demo_screen.dart';

/// MBTI 성격유형 검사 화면
/// 페이지별로 3-4개 질문을 표시하고 라디오버튼으로 답변 선택
class PsyTestScreen extends StatefulWidget {
  const PsyTestScreen({super.key});

  @override
  State<PsyTestScreen> createState() => _PsyTestScreenState();
}

class _PsyTestScreenState extends State<PsyTestScreen>
    with TickerProviderStateMixin {

  // 🎨 테스트 진행 상태
  int _currentPage = 0;
  final int _totalPages = 8; // MBTI 24문항 ÷ 3문항 = 8페이지
  final int _questionsPerPage = 3;
  
  // 🎨 답변 저장 (questionId: selectedAnswer)
  final Map<String, String> _answers = {};

  // 🎨 애니메이션 컨트롤러
  late AnimationController _pageAnimationController;
  late Animation<double> _pageAnimation;

  // 🎨 임시 MBTI 질문 데이터 (실제로는 서버에서 받아올 예정)
  final List<List<MbtiQuestion>> _questionPages = [
    // 페이지 1
    [
      MbtiQuestion(
        id: 'q1',
        text: '새로운 사람들과 만날 때 어떤 기분이 드나요?',
        options: [
          AnswerOption(id: 'a', text: '설레고 기대된다', value: 'E'),
          AnswerOption(id: 'b', text: '조금 긴장되지만 괜찮다', value: 'N'),
          AnswerOption(id: 'c', text: '부담스럽고 피하고 싶다', value: 'I'),
        ],
      ),
      MbtiQuestion(
        id: 'q2',
        text: '주말에 주로 무엇을 하며 시간을 보내나요?',
        options: [
          AnswerOption(id: 'a', text: '친구들과 만나서 활동한다', value: 'E'),
          AnswerOption(id: 'b', text: '집에서 혼자만의 시간을 갖는다', value: 'I'),
          AnswerOption(id: 'c', text: '상황에 따라 다르다', value: 'N'),
        ],
      ),
      MbtiQuestion(
        id: 'q3',
        text: '새로운 아이디어를 떠올릴 때는?',
        options: [
          AnswerOption(id: 'a', text: '현실적이고 구체적인 방법을 생각한다', value: 'S'),
          AnswerOption(id: 'b', text: '창의적이고 혁신적인 방법을 생각한다', value: 'N'),
          AnswerOption(id: 'c', text: '기존 경험을 바탕으로 생각한다', value: 'S'),
        ],
      ),
    ],
    // 페이지 2
    [
      MbtiQuestion(
        id: 'q4',
        text: '중요한 결정을 내릴 때 주로 어떻게 하나요?',
        options: [
          AnswerOption(id: 'a', text: '논리적으로 분석해서 결정한다', value: 'T'),
          AnswerOption(id: 'b', text: '감정과 직감을 따라 결정한다', value: 'F'),
          AnswerOption(id: 'c', text: '다른 사람의 의견을 많이 듣는다', value: 'F'),
        ],
      ),
      MbtiQuestion(
        id: 'q5',
        text: '계획을 세울 때 어떤 스타일인가요?',
        options: [
          AnswerOption(id: 'a', text: '미리 자세히 계획을 세운다', value: 'J'),
          AnswerOption(id: 'b', text: '대략적인 방향만 정한다', value: 'P'),
          AnswerOption(id: 'c', text: '그때그때 상황에 맞춰 한다', value: 'P'),
        ],
      ),
      MbtiQuestion(
        id: 'q6',
        text: '스트레스를 받을 때 어떻게 해소하나요?',
        options: [
          AnswerOption(id: 'a', text: '친구들과 이야기를 나눈다', value: 'E'),
          AnswerOption(id: 'b', text: '혼자서 조용히 생각한다', value: 'I'),
          AnswerOption(id: 'c', text: '운동이나 취미활동을 한다', value: 'S'),
        ],
      ),
    ],
    // 더 많은 페이지들... (실제로는 8페이지까지)
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  /// 🎨 애니메이션 설정
  void _setupAnimations() {
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    ));

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(isDarkMode),
    );
  }

  /// 🎨 앱바 구성
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Row(
        children: [
          Text(
            'MBTI 검사',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          Text(
            '${_currentPage + 1} / $_totalPages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => _showExitDialog(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color(0xFF1E293B).withOpacity(0.9)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
      ),
    );
  }

  /// 🎨 메인 바디
  Widget _buildBody(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            const Color(0xFF0F172A),
            const Color(0xFF1E293B),
            const Color(0xFF334155),
          ]
              : [
            const Color(0xFFF8FAFC),
            const Color(0xFFE2E8F0),
            const Color(0xFFCBD5E1),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(isDarkMode),
            Expanded(child: _buildQuestionContent(isDarkMode)),
            _buildNavigationButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  /// 🎨 진행률 표시기
  Widget _buildProgressIndicator(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF334155).withOpacity(0.6),
          ]
              : [
            Colors.white.withOpacity(0.9),
            const Color(0xFFF8FAFC).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행률',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              Text(
                '${((_currentPage + 1) / _totalPages * 100).round()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3182CE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
            backgroundColor: isDarkMode ? Colors.white24 : Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  /// 🎨 질문 콘텐츠
  Widget _buildQuestionContent(bool isDarkMode) {
    // 현재 페이지가 존재하는지 확인
    if (_currentPage >= _questionPages.length) {
      return _buildCompletionScreen(isDarkMode);
    }

    final currentQuestions = _questionPages[_currentPage];

    return AnimatedBuilder(
      animation: _pageAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _pageAnimation.value)),
          child: Opacity(
            opacity: _pageAnimation.value,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: currentQuestions.length,
              itemBuilder: (context, index) {
                final question = currentQuestions[index];
                return _buildQuestionCard(question, isDarkMode);
              },
            ),
          ),
        );
      },
    );
  }

  /// 🎨 개별 질문 카드
  Widget _buildQuestionCard(MbtiQuestion question, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF334155).withOpacity(0.6),
          ]
              : [
            Colors.white.withOpacity(0.9),
            const Color(0xFFF8FAFC).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 질문 텍스트
          Text(
            question.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          
          // 답변 옵션들
          ...question.options.map((option) => _buildAnswerOption(
            question.id,
            option,
            isDarkMode,
          )).toList(),
        ],
      ),
    );
  }

  /// 🎨 답변 옵션
  Widget _buildAnswerOption(String questionId, AnswerOption option, bool isDarkMode) {
    final isSelected = _answers[questionId] == option.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _answers[questionId] = option.id;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3182CE).withOpacity(0.1)
                  : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3182CE)
                    : (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1)),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // 라디오 버튼
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3182CE)
                          : (isDarkMode ? Colors.white60 : Colors.black38),
                      width: 2,
                    ),
                    color: isSelected ? const Color(0xFF3182CE) : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.white,
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                
                // 답변 텍스트
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF3182CE)
                          : (isDarkMode ? Colors.white70 : const Color(0xFF4A5568)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 네비게이션 버튼들
  Widget _buildNavigationButtons(bool isDarkMode) {
    final canGoNext = _canGoToNextPage();
    final canGoPrevious = _currentPage > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.9),
            const Color(0xFF334155).withOpacity(0.7),
          ]
              : [
            Colors.white.withOpacity(0.9),
            const Color(0xFFF8FAFC).withOpacity(0.7),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 이전 버튼
          if (canGoPrevious)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _goToPreviousPage,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                label: const Text(
                  '이전',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDarkMode ? Colors.white70 : const Color(0xFF718096),
                  side: BorderSide(
                    color: isDarkMode ? Colors.white30 : Colors.black26,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          
          if (canGoPrevious) const SizedBox(width: 16),
          
          // 다음/완료 버튼
          Expanded(
            flex: canGoPrevious ? 1 : 2,
            child: ElevatedButton.icon(
              onPressed: canGoNext ? _goToNextPage : null,
              icon: Icon(
                _currentPage == _totalPages - 1 
                    ? Icons.check_rounded 
                    : Icons.arrow_forward_rounded,
                size: 20,
              ),
              label: Text(
                _currentPage == _totalPages - 1 ? '완료' : '다음',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canGoNext 
                    ? const Color(0xFF3182CE)
                    : (isDarkMode ? Colors.white24 : Colors.black12),
                foregroundColor: canGoNext
                    ? Colors.white
                    : (isDarkMode ? Colors.white38 : Colors.black38),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: canGoNext ? 2 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 완료 화면
  Widget _buildCompletionScreen(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF38A169),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'MBTI 검사 완료!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '결과를 분석중입니다...',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38A169),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  '결과 보기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 다음 페이지로 갈 수 있는지 확인
  bool _canGoToNextPage() {
    if (_currentPage >= _questionPages.length) return true;
    
    final currentQuestions = _questionPages[_currentPage];
    for (final question in currentQuestions) {
      if (!_answers.containsKey(question.id)) {
        return false;
      }
    }
    return true;
  }

  /// 🎨 다음 페이지로 이동
  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      _pageAnimationController.reset();
      _pageAnimationController.forward();
    } else {
      // 마지막 페이지에서 완료
      _submitTest();
    }
  }

  /// 🎨 이전 페이지로 이동
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageAnimationController.reset();
      _pageAnimationController.forward();
    }
  }

  /// 🎨 테스트 제출
  void _submitTest() {
    // TODO: 서버에 답변 데이터 전송 및 결과 분석
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('MBTI 검사가 완료되었습니다!'),
        backgroundColor: const Color(0xFF38A169),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    
    // 결과 화면으로 이동 또는 이전 화면으로 돌아가기
    // Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PsyResultDemoScreen(),
      ),
    );
  }

  /// 🎨 종료 확인 다이얼로그
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFE53E3E)),
            SizedBox(width: 8),
            Text('검사 종료'),
          ],
        ),
        content: const Text(
          '정말로 검사를 종료하시겠습니까?\n현재까지의 답변이 저장되지 않을 수 있습니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 테스트 화면 닫기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: const Text('종료'),
          ),
        ],
      ),
    );
  }
}

/// MBTI 질문 모델
class MbtiQuestion {
  final String id;
  final String text;
  final List<AnswerOption> options;

  MbtiQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
}

/// 답변 옵션 모델
class AnswerOption {
  final String id;
  final String text;
  final String value; // E, I, S, N, T, F, J, P

  AnswerOption({
    required this.id,
    required this.text,
    required this.value,
  });
}
