// lib/features/psytest/presentation/screens/psy_test_screen.dart

import 'package:flutter/material.dart';
import '../psy_result/psy_result_demo_screen.dart';
import 'model/TestQuestion.dart'; // ✅ 실제 프로젝트 경로를 확인해주세요.

/// [최종 버전] 데이터 기반의 유연한 심리 테스트 화면 (주관식 답변 기능 추가)
class PsyTestScreen extends StatefulWidget {
  const PsyTestScreen({super.key});

  @override
  State<PsyTestScreen> createState() => _PsyTestScreenState();
}

class _PsyTestScreenState extends State<PsyTestScreen> with TickerProviderStateMixin {
  // 🎨 테스트 진행 상태
  int _currentPage = 0;
  // ✅ [수정됨] 선택지 ID(String)와 주관식 답변(String)을 모두 저장하기 위해 dynamic 타입으로 변경
  final Map<String, dynamic> _answers = {};
  // ✅ [새로 추가] 주관식 답변의 TextEditingController를 관리하는 맵
  final Map<String, TextEditingController> _textControllers = {};

  // 🎨 애니메이션 컨트롤러
  late AnimationController _pageAnimationController;
  late Animation<double> _pageAnimation;

  // ✅ [수정됨] '주관식' 질문이 포함된 새로운 데이터
  final List<List<TestQuestion>> _questionPages = [
    // 페이지 1: 기본 유형 (텍스트 라디오 + 주관식)
    [
      TestQuestion(id: 'q1', text: '주말에 주로 무엇을 하며 시간을 보내나요?', options: [
        QuestionOption(id: 'a', text: '친구들과 만나서 활동한다', value: 'E'),
        QuestionOption(id: 'b', text: '집에서 혼자만의 시간을 갖는다', value: 'I'),
      ]),
      TestQuestion(id: 'q2', text: '최근 당신을 가장 잘 표현하는 단어 하나를 적어주세요.', type: QuestionType.subjective),
    ],
    // 페이지 2: 이미지 선택 유형
    [
      TestQuestion(id: 'q3', text: '더 끌리는 풍경을 선택해주세요.', type: QuestionType.image, options: [
        QuestionOption(id: 'a', value: 'J', imageUrl: 'assets/images/background/htp_background_1_high.webp', text: '잘 정돈된 집'),
        QuestionOption(id: 'b', value: 'P', imageUrl: 'assets/images/background/htp_background_2_high.webp', text: '자유로운 숲길'),
      ]),
    ],
    // 페이지 3: 질문에 이미지 + 답변은 라디오
    [
      TestQuestion(
        id: 'q4',
        text: '이 그림을 보고 어떤 감정이 드나요?',
        imageUrl: 'assets/images/background/htp_background_2_high.webp', // ✅ 질문 자체에 이미지가 포함된 경우
        options: [
          QuestionOption(id: 'a', text: '평온하고 안정적이다', value: 'S'),
          QuestionOption(id: 'b', text: '자유롭고 창의적이다', value: 'N'),
          QuestionOption(id: 'c', text: '조금 외로워 보인다', value: 'F'),
        ],
      ),
    ],
    // 페이지 4: 질문에 이미지 + 답변은 주관식
    [
      TestQuestion(
        id: 'q5',
        text: '이 그림 속 장소에 제목을 붙여주세요.',
        imageUrl: 'assets/images/background/htp_background_1_high.webp',
        type: QuestionType.subjective,
      ),
    ],
    // 페이지 5: 드롭다운(선택 박스) 유형
    [
      TestQuestion(
        id: 'q6',
        text: '당신의 업무 스타일과 가장 가까운 것을 선택해주세요.',
        type: QuestionType.text, // ✅ 드롭다운 질문 타입
        options: [
          QuestionOption(id: 'a', text: '미리 계획하고 체계적으로 실행한다', value: 'J'),
          QuestionOption(id: 'b', text: '상황에 맞춰 유연하게 대처한다', value: 'P'),
          QuestionOption(id: 'c', text: '마감 기한에 맞춰 집중적으로 처리한다', value: 'P'),
          QuestionOption(id: 'd', text: '마감 기한에 맞춰 집중적으로 처리한다', value: 'J'),
        ],
      ),
    ],
    // 페이지 6: 질문에 이미지 + 답변은 드롭다운
    [
      TestQuestion(
        id: 'q7',
        text: '이 캐릭터가 할 것 같은 말은 무엇인가요?',
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop',
        type: QuestionType.text,
        options: [
          QuestionOption(id: 'a', text: '"우리 같이 새로운거 해보자!"', value: 'E'),
          QuestionOption(id: 'b', text: '"이 문제의 핵심은 말이야..."', value: 'T'),
          QuestionOption(id: 'c', text: '"다들 괜찮아? 내가 도와줄까?"', value: 'F'),
        ],
      ),
    ],
    // 페이지 7: 모든 유형 혼합
    [
      TestQuestion(id: 'q8', text: '스트레스를 받을 때 어떻게 해소하나요?', options: [
        QuestionOption(id: 'a', text: '친구들과 이야기를 나눈다', value: 'E'),
        QuestionOption(id: 'b', text: '혼자서 조용히 생각한다', value: 'I'),
      ]),
      TestQuestion(id: 'q9', text: '가장 중요하게 생각하는 가치를 적어주세요.', type: QuestionType.subjective),
    ],
  ];

  late final int _totalPages = _questionPages.length;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    // ✅ 화면이 사라질 때 모든 컨트롤러를 메모리에서 해제하여 누수를 방지합니다.
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setupAnimations() {
    _pageAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _pageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _pageAnimationController, curve: Curves.easeInOut));
    _pageAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(isDarkMode),
    );
  }

  //==================================================================
  // 🎨 UI 부품 위젯들 (역할에 따라 완벽히 분리됨)
  //==================================================================

  /// 🎨 앱바 구성
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Row(
        children: [
          Text(
            'MBTI 검사',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : const Color(0xFF2D3748)),
          ),
          const Spacer(),
          Text(
            '${_currentPage + 1} / $_totalPages',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white70 : const Color(0xFF718096)),
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
            color: isDarkMode ? const Color(0xFF1E293B).withOpacity(0.9) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), width: 1),
          ),
          child: Icon(Icons.arrow_back_ios_new, size: 20, color: isDarkMode ? Colors.white : const Color(0xFF2D3748)),
        ),
      ),
    );
  }

  /// 🎨 메인 바디
  Widget _buildBody(bool isDarkMode) {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressIndicator(isDarkMode),
          Expanded(child: _buildQuestionContent(isDarkMode)),
          _buildNavigationButtons(isDarkMode),
        ],
      ),
    );
  }

  /// 🎨 진행률 표시기
  Widget _buildProgressIndicator(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('진행률', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : const Color(0xFF2D3748))),
              Text('${((_currentPage + 1) / _totalPages * 100).round()}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF3182CE))),
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

  /// 🎨 질문 콘텐츠 영역
  Widget _buildQuestionContent(bool isDarkMode) {
    if (_currentPage >= _questionPages.length) {
      return _buildCompletionScreen(isDarkMode);
    }
    final currentQuestions = _questionPages[_currentPage];
    return AnimatedBuilder(
      animation: _pageAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pageAnimation.value,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: currentQuestions.length,
            itemBuilder: (context, index) {
              return _buildQuestionCard(currentQuestions[index], isDarkMode);
            },
          ),
        );
      },
    );
  }

  /// 🎨 [핵심] '만능 질문 카드' - 데이터에 따라 다른 위젯을 조립
  Widget _buildQuestionCard(TestQuestion question, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ [새로 추가] 질문 자체에 이미지가 있으면 먼저 그립니다.
          if (question.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(question.imageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
          ],
          Text(question.text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : const Color(0xFF2D3748), height: 1.4)),
          const SizedBox(height: 20),
          // ✅ [수정됨] 질문 타입에 따라 다른 위젯을 그립니다.
          if (question.type == QuestionType.subjective)
            _buildSubjectiveInput(question.id, isDarkMode)
          else
            ...(question.options ?? []).map((option) {
              if (option.imageUrl != null) return _buildImageOption(question.id, option, isDarkMode);
              return _buildTextOption(question.id, option, isDarkMode);
            }).toList(),
        ],
      ),
    );
  }

  /// 🎨 텍스트 답변 옵션
  Widget _buildTextOption(String questionId, QuestionOption option, bool isDarkMode) {
    final isSelected = _answers[questionId] == option.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _answers[questionId] = option.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _optionDecoration(isSelected, isDarkMode),
          child: Row(
            children: [
              _RadioCircle(isSelected: isSelected),
              const SizedBox(width: 16),
              Expanded(child: Text(option.text ?? '', style: _optionTextStyle(isSelected, isDarkMode))),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 이미지 답변 옵션
  Widget _buildImageOption(String questionId, QuestionOption option, bool isDarkMode) {
    final isSelected = _answers[questionId] == option.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _answers[questionId] = option.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: _optionDecoration(isSelected, isDarkMode).copyWith(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(option.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
              if (option.text != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(option.text!, style: _optionTextStyle(isSelected, isDarkMode)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 주관식 답변 입력
  Widget _buildSubjectiveInput(String questionId, bool isDarkMode) {
    final controller = _textControllers.putIfAbsent(
      questionId,
          () => TextEditingController(text: _answers[questionId] as String?),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _optionDecoration(false, isDarkMode).copyWith(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
      ),
      child: TextField(
        controller: controller,
        onChanged: (text) => setState(() => _answers[questionId] = text),
        maxLines: 1,
        style: _optionTextStyle(false, isDarkMode).copyWith(fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '여기에 답변을 입력하세요...',
          hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.black38),
        ),
      ),
    );
  }

  /// 🎨 네비게이션 버튼들
  Widget _buildNavigationButtons(bool isDarkMode) {
    final canGoNext = _canGoToNextPage();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _goToPreviousPage,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                label: const Text('이전', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDarkMode ? Colors.white70 : const Color(0xFF718096),
                  side: BorderSide(color: isDarkMode ? Colors.white30 : Colors.black26, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: canGoNext ? _goToNextPage : null,
              icon: Icon(_currentPage == _totalPages - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 20),
              label: Text(_currentPage == _totalPages - 1 ? '완료' : '다음', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: canGoNext ? const Color(0xFF3182CE) : (isDarkMode ? Colors.white24 : Colors.black12),
                foregroundColor: canGoNext ? Colors.white : (isDarkMode ? Colors.white38 : Colors.black38),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const Icon(Icons.check_circle_outline_rounded, size: 80, color: Color(0xFF38A169)),
            const SizedBox(height: 30),
            Text('MBTI 검사 완료!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : const Color(0xFF2D3748))),
            const SizedBox(height: 16),
            Text('결과를 분석중입니다...', style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : const Color(0xFF718096))),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTest,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38A169), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('결과 보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 중복 스타일을 위한 헬퍼 ---
  BoxDecoration _cardDecoration(bool isDarkMode) => BoxDecoration(color: isDarkMode ? const Color(0xFF1E293B) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDarkMode ? Colors.white12 : Colors.black12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))]);
  BoxDecoration _optionDecoration(bool isSelected, bool isDarkMode) => BoxDecoration(color: isSelected ? const Color(0xFF3182CE).withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? const Color(0xFF3182CE) : (isDarkMode ? Colors.white24 : Colors.black26), width: isSelected ? 2 : 1.5));
  TextStyle _optionTextStyle(bool isSelected, bool isDarkMode) => TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF3182CE) : (isDarkMode ? Colors.white70 : const Color(0xFF4A5568)));

  //==================================================================
  // ⚙️ 상태 관리 및 로직 함수들
  //==================================================================

  bool _canGoToNextPage() {
    if (_currentPage >= _questionPages.length) return true;
    final currentQuestions = _questionPages[_currentPage];
    for (final question in currentQuestions) {
      if (!_answers.containsKey(question.id) || _answers[question.id] == null) {
        return false;
      }
      if (question.type == QuestionType.subjective && (_answers[question.id] as String).isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      _pageAnimationController.reset();
      _pageAnimationController.forward();
    } else {
      _submitTest();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageAnimationController.reset();
      _pageAnimationController.forward();
    }
  }

  void _submitTest() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PsyResultDemoScreen()));
  }

  void _showExitDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: const Text('검사 종료'), content: const Text('정말로 검사를 종료하시겠습니까?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('계속하기')), ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('종료'))]));
  }
}

class _RadioCircle extends StatelessWidget {
  final bool isSelected;
  const _RadioCircle({required this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFF3182CE) : Colors.grey, width: 2)), child: isSelected ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF3182CE)))) : null);
  }
}
