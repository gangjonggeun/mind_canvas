import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n.dart';
import '../../data/dto/journal_response.dart';
import '../providers/journal_notifier.dart';

/// 🎭 AI 감정일기 작성 페이지
///
/// 여러 질문에 답변하며 감정을 기록하고 AI 분석을 받는 화면
/// - 단계별 질문 구조
/// - 부드러운 애니메이션
/// - 메모리 효율적인 상태 관리
/// - 일기 저장/삭제 기능
class EmotionDiaryPage extends ConsumerStatefulWidget {
  const EmotionDiaryPage({super.key});

  @override
  ConsumerState<EmotionDiaryPage> createState() => _EmotionDiaryPageState();
}

class _EmotionDiaryPageState extends ConsumerState<EmotionDiaryPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 타이핑 효과를 위한 컨트롤러
  late AnimationController _typingController;
  late Animation<int> _typingAnimation;

  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};
  final Map<int, TextEditingController> _controllers = {};

  // bool _isAnalyzing = false;
  // bool _showResult = false;

  // 🎯 감정일기 질문들 (확장 가능)
  List<EmotionQuestion> get _questions => [
    EmotionQuestion(
      id: 0,
      question: S.of(context).diary_q1,
      hint: S.of(context).diary_hint1,
      emoji: '🌅',
    ),
    EmotionQuestion(
      id: 1,
      question: S.of(context).diary_q2,
      hint: S.of(context).diary_hint2,
      emoji: '💭',
    ),
    EmotionQuestion(
      id: 2,
      question: S.of(context).diary_q3,
      hint: S.of(context).diary_hint3,
      emoji: '🔍',
    ),
    EmotionQuestion(
      id: 3,
      question: S.of(context).diary_q4,
      hint: S.of(context).diary_hint4,
      emoji: '💖',
    ),
    EmotionQuestion(
      id: 4,
      question: S.of(context).diary_q5,
      hint: S.of(context).diary_hint5,
      emoji: '🌟',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 초기화
  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    _typingController = AnimationController(vsync: this);
  }

  void _startTypingAnimation(String text) {
    _typingController.duration = Duration(
      milliseconds: text.length * 50,
    ); // 글자당 50ms
    _typingAnimation = IntTween(
      begin: 0,
      end: text.length,
    ).animate(_typingController);
    _typingController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 Provider 상태 구독
    final journalState = ref.watch(journalNotifierProvider);
    final bool showResult = journalState.analysisResult != null;

    // 👂 상태 리스너: 에러 처리 및 타이핑 시작
    ref.listen(journalNotifierProvider, (previous, next) {
      if (next.errorMessage != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('⚠️ ${next.errorMessage}')));
      }
      // 결과가 새로 들어왔으면 타이핑 시작
      if (previous?.analysisResult == null && next.analysisResult != null) {
        _startTypingAnimation(next.analysisResult!.analysis.aiFeedback);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(showResult),
      body: SafeArea(
        child: journalState.isLoading
            ? _buildLoadingView() // 로딩 화면 별도 구현
            : (showResult
                ? _buildResultView(journalState.analysisResult!)
                : _buildQuestionView()),
      ),
    );
  }

  /// ⏳ 로딩 화면
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6B73FF)),
          const SizedBox(height: 24),
           Text(
            S.of(context).diary_loading,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).diary_wait,
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  /// 🎯 앱바 구성
  PreferredSizeWidget _buildAppBar(bool _showResult) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
      ),
      title: Text(
        _showResult ? S.of(context).diary_result : S.of(context).diary_report,
        style: const TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (!_showResult)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// ❓ 질문 화면
  Widget _buildQuestionView() {
    final currentQuestion = _questions[_currentQuestionIndex];

    // 💡 빈 공간 터치 시 키보드를 부드럽게 내리기 위한 GestureDetector
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            color: const Color(0xFFFBFBFE),
            child: SafeArea(
              child: Column(
                children: [
                  // 1. 상단: 프로그레스 바 (고정)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: _buildProgressBar(),
                  ),

                  // 2. 메인: 스크롤 가능한 영역 (키보드 오버플로우 완벽 해결)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🎨 질문 카드 (이모지 삭제됨)
                          _buildQuestionCard(currentQuestion),

                          const SizedBox(height: 32),

                          // 📝 텍스트 입력 캔버스
                          _buildTextInputCanvas(currentQuestion),
                        ],
                      ),
                    ),
                  ),

                  // 3. 하단: 네비게이션 버튼 (키보드 위로 예쁘게 밀려 올라옴)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildNavigationButtons(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// 🎨 몰입형 입력 캔버스 (기존 _buildQuestionCard 대체)
  Widget _buildFocusCanvas(EmotionQuestion question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // 💡 포인트 1: 질문 영역을 감싸는 우아한 '카드 섹션'
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, // 카드 배경색
              borderRadius: BorderRadius.circular(24), // 부드러운 라운딩
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF6B73FF).withOpacity(0.05), // 브랜드 컬러의 은은한 그림자
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이모지
                    Text(question.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    // 질문 텍스트
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // 힌트 텍스트 (이모지 아래 빈 공간까지 꽉 채우도록 재배치)
                if (question.hint.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9)), // 은은한 구분선
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.hint,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32), // 카드와 텍스트 입력창 사이의 넉넉한 여백

          // 💡 포인트 2: 박스 없는 무한 캔버스 (자유로운 글쓰기 경험 유지)
          Expanded(
            child: TextFormField(
              initialValue: _answers[question.id],
              onChanged: (value) {
                _answers[question.id] = value;
              },
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: const Color(0xFF6B73FF),
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF334155),
                height: 1.8,
              ),
              decoration: const InputDecoration(
                hintText: '자세하게 말할수록 정확도가 올라갑니다.',
                hintStyle: TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 17,
                  height: 1.8,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 진행률 바
  Widget _buildProgressBar() {
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).diary_q_inedex(_currentQuestionIndex + 1), 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              S.of(context).diary_complete((progress * 100).toInt()), //
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
          minHeight: 6,
        ),
      ],
    );
  }

  /// 🎭 질문 카드
  Widget _buildQuestionCard(EmotionQuestion question) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // 카드 배경색
        borderRadius: BorderRadius.circular(24), // 부드러운 라운딩
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF6B73FF).withOpacity(0.05), // 브랜드 컬러의 은은한 그림자
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 💡 이모지 삭제, 질문 텍스트만 깔끔하고 크게 배치
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.4,
              letterSpacing: -0.5,
            ),
          ),

          // 💡 힌트 텍스트 (질문 아래 구분선 추가)
          if (question.hint.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)), // 은은한 구분선
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.hint,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextInputCanvas(EmotionQuestion question) {
    return TextFormField(
      // 💡 [핵심 해결책] 질문 ID를 Key로 부여!
      // 질문이 바뀔 때마다 기존 텍스트를 날리고 텍스트 필드를 완전히 새로 그립니다.
      key: ValueKey(question.id),

      // 만약 '이전' 버튼을 눌러서 돌아왔을 때는 저장된 답변을 보여주고, 새 질문이면 빈칸('') 처리
      initialValue: _answers[question.id] ?? '',

      onChanged: (value) {
        _answers[question.id] = value;
      },

      minLines: 10,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      cursorColor: const Color(0xFF6B73FF),
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFF334155),
        height: 1.8,
      ),
      decoration: InputDecoration(
        hintText: S.of(context).diary_input_text,
        hintStyle: TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 17,
          height: 1.8,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
  /// 🚀 네비게이션 버튼들
  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // 이전 버튼
        if (_currentQuestionIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _goToPreviousQuestion,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF6B73FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:Text(
                S.of(context).diary_prev,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B73FF),
                ),
              ),
            ),
          ),

        if (_currentQuestionIndex > 0) const SizedBox(width: 16),

        // 다음/완료 버튼
        Expanded(
          flex: _currentQuestionIndex > 0 ? 1 : 1,
          child: ElevatedButton(
            onPressed:
                _isLastQuestion() ? _completeQuestionnaire : _goToNextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              _isLastQuestion() ? S.of(context).diary_complete_btn : S.of(context).diary_next_btn,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //
  // /// 📊 분석 결과 화면
  // Widget _buildResultView() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       children: [
  //         // AI 분석 카드
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: const Color(0xFF6B73FF).withOpacity(0.3),
  //                 blurRadius: 20,
  //                 offset: const Offset(0, 8),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             children: [
  //               const Icon(Icons.psychology, color: Colors.white, size: 48),
  //               const SizedBox(height: 16),
  //               const Text(
  //                 '🎯 AI 감정 분석 완료',
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               const Text(
  //                 '당신의 감정을 분석하여\n맞춤형 조언을 준비했습니다',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.white70,
  //                   height: 1.4,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //
  //         // 분석 결과 (샘플)
  //         Expanded(
  //           child: Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.all(24),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withOpacity(0.05),
  //                   blurRadius: 20,
  //                   offset: const Offset(0, 8),
  //                 ),
  //               ],
  //             ),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     '📋 분석 결과',
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color(0xFF2D3748),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   _buildAnalysisItem(
  //                     '😊 주요 감정',
  //                     '긍정적인 에너지와 약간의 피로감이 공존하고 있습니다.',
  //                   ),
  //                   const SizedBox(height: 16),
  //                   _buildAnalysisItem(
  //                     '💡 AI 조언',
  //                     '충분한 휴식과 함께 좋아하는 활동을 통해 에너지를 재충전하시는 것을 권장합니다.',
  //                   ),
  //                   const SizedBox(height: 16),
  //                   _buildAnalysisItem(
  //                     '🎯 추천 활동',
  //                     '산책, 명상, 좋은 음악 감상 등이 현재 상태에 도움이 될 것 같습니다.',
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //
  //         // 액션 버튼들
  //         _buildActionButtons(),
  //       ],
  //     ),
  //   );
  // }

  /// 📋 분석 항목 위젯
  Widget _buildAnalysisItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 액션 버튼들
  Widget _buildActionButtons() {
    return Column(
      children: [
        // 저장 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveDiary,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              '💾 일기 저장하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 새로 작성하기 버튼
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _resetDiary,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF6B73FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '✏️ 새로 작성하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B73FF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔄 상태 관리 메서드들
  bool _isLastQuestion() => _currentQuestionIndex == _questions.length - 1;

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _restartAnimation();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _restartAnimation();
    }
  }

  void _completeQuestionnaire() {
    // 1. 답변 합치기
    final StringBuffer contentBuffer = StringBuffer();
    for (int i = 0; i < _questions.length; i++) {
      final answer = _answers[i] ?? '';
      if (answer.isNotEmpty) {
        contentBuffer.writeln("Q: ${_questions[i].question}");
        contentBuffer.writeln("A: $answer\n");
      }
    }

    // 2. 오늘 날짜
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 3. Provider 호출
    ref
        .read(journalNotifierProvider.notifier)
        .submitJournal(date: today, content: contentBuffer.toString());
  }

  void _saveDiary() {
    // TODO: 실제 저장 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 감정일기가 저장되었습니다!'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
  }

  void _resetDiary() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers.clear();
      // _showResult = false;
    });
    _restartAnimation();
  }

  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildResultView(JournalResponse result) {
    final analysis = result.analysis;
    final date = DateTime.parse(result.date);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 비율에 맞춰 종이 크기 계산 (비율 유지)
        double paperWidth = constraints.maxWidth * 0.95;
        double paperHeight = paperWidth * 1.414; // A4 비율

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // 1. 일기장 영역 (이미지 배경)
              Center(
                child: Container(
                  width: paperWidth,
                  height: paperHeight, // 내용이 길면 늘어나도록 수정 가능
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBF7), // 종이 색상 (이미지 로드 전)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    // 🖼️ 배경 이미지 설정
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/background/daily_journal_bg_mid.webp',
                      ),
                      // ✅ 이미지 경로 확인
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    // 이미지의 여백에 맞춰 Padding 조절 (중요!)
                    padding: EdgeInsets.fromLTRB(
                      paperWidth * 0.1, // 왼쪽 여백
                      paperHeight * 0.15, // 위쪽 여백 (Daily Journal 타이틀 아래)
                      paperWidth * 0.1, // 오른쪽 여백
                      paperHeight * 0.1, // 아래쪽 여백
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 날짜 표시
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd').format(date),
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              DateFormat('MMM').format(date).toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy').format(date),
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // ✍️ AI 피드백 (타이핑 효과)
                        Expanded(
                          child: SingleChildScrollView(
                            child: AnimatedBuilder(
                              animation: _typingAnimation,
                              builder: (context, child) {
                                String text = analysis.aiFeedback;
                                int count = _typingAnimation.value;
                                // 안전하게 자르기
                                if (count > text.length) count = text.length;
                                String visibleText = text.substring(0, count);

                                return Text(
                                  visibleText,
                                  style: const TextStyle(
                                    fontFamily: 'Handwriting',
                                    // ✅ 손글씨 폰트 적용 (pubspec.yaml 등록 필요)
                                    fontSize: 18,
                                    // 화면 크기에 따라 조절 필요
                                    height: 1.8,
                                    // 줄간격 (줄공책 라인에 맞추기)
                                    color: Color(0xFF2D3748),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. 감정 분석 카드 (종이 밖)
              _buildEmotionCard(analysis),

              const SizedBox(height: 20),

              // 3. 하단 버튼 (나가기)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(journalNotifierProvider.notifier)
                          .resetState(); // 상태 초기화
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B73FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text(
                      S.of(context).diary_close,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  /// 🧠 감정 분석 요약 카드
  // _buildEmotionCard 함수 내부
  Widget _buildEmotionCard(EmotionAnalysis analysis) {
    // ✅ 감정 타입에 따른 이모티콘 매핑
    String emotionEmoji;
    String emotionText;
    Color emotionColor;

    switch (analysis.primaryEmotion) {
      case EmotionType.JOY:
        emotionEmoji = '😊';
        emotionText = S.of(context).diary_emotion_delight;
        emotionColor = Colors.green;
        break;
      case EmotionType.SADNESS:
        emotionEmoji = '😢';
        emotionText = S.of(context).diary_emotion_sad;
        emotionColor = Colors.blue;
        break;
      case EmotionType.ANGER:
        emotionEmoji = '😡';
        emotionText = S.of(context).diary_emotion_angry;
        emotionColor = Colors.red;
        break;
      case EmotionType.ANXIETY:
        emotionEmoji = '😟';
        emotionText = S.of(context).diary_emotion_anxious;
        emotionColor = Colors.orange;
        break;
      case EmotionType.TIREDNESS:
        emotionEmoji = '😴';
        emotionText = S.of(context).diary_emotion_let;
        emotionColor = Colors.deepPurple;
        break;
      case EmotionType.NEUTRAL:
        emotionEmoji = '😐';
        emotionText = S.of(context).diary_emotion_netral;
        emotionColor = Colors.grey;
        break;
      default:
        emotionEmoji = '🤔';
        emotionText = S.of(context).diary_emotion_unkonown;
        emotionColor = Colors.black54;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
        children: [
          Row(
            children: [
              Text(emotionEmoji, style: const TextStyle(fontSize: 24)), // 이모티콘
              const SizedBox(width: 8),
              Text(
                S.of(context).diary_emotion_text(emotionText), // ✅ 이모티콘과 텍스트 사용 emotionText
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: emotionColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            S.of(context).diary_result_title, // ✅ 제목 변경
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            analysis.aiFeedback, // ✅ AI 피드백 내용
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
              height: 1.5,
            ),
            textAlign: TextAlign.start, // ✅ 피드백은 왼쪽 정렬
          ),
        ],
      ),
    );
  }
}

/// 🎭 감정일기 질문 모델
class EmotionQuestion {
  final int id;
  final String question;
  final String hint;
  final String emoji;

  const EmotionQuestion({
    required this.id,
    required this.question,
    required this.hint,
    required this.emoji,
  });
}
