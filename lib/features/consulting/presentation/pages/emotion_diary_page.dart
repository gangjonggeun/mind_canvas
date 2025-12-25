import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  // bool _isAnalyzing = false;
  // bool _showResult = false;

  // 🎯 감정일기 질문들 (확장 가능)
  final List<EmotionQuestion> _questions = [
    EmotionQuestion(
      id: 0,
      question: '오늘 하루는 어떠셨나요?',
      hint: '전반적인 하루의 느낌을 자유롭게 적어주세요',
      emoji: '🌅',
    ),
    EmotionQuestion(
      id: 1,
      question: '지금 가장 강하게 느끼는 감정은 무엇인가요?',
      hint: '기쁨, 슬픔, 분노, 불안 등 구체적으로 표현해주세요',
      emoji: '💭',
    ),
    EmotionQuestion(
      id: 2,
      question: '그 감정이 생긴 특별한 이유가 있나요?',
      hint: '어떤 상황이나 사건이 그 감정을 불러일으켰는지 생각해보세요',
      emoji: '🔍',
    ),
    EmotionQuestion(
      id: 3,
      question: '지금 이 순간 가장 필요한 것은 무엇일까요?',
      hint: '휴식, 대화, 활동 등 마음이 원하는 것을 적어주세요',
      emoji: '💖',
    ),
    EmotionQuestion(
      id: 4,
      question: '내일은 어떤 하루가 되었으면 좋겠나요?',
      hint: '희망이나 기대, 계획 등을 자유롭게 표현해주세요',
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
          const Text(
            "AI가 당신의 하루를 읽고 있어요...",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "잠시만 기다려주세요 ✨",
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
        _showResult ? '📊 감정 분석 결과' : '💭 감정일기 작성',
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

    // 1. 키보드가 올라왔을 때의 화면 높이를 계산하기 위해 LayoutBuilder 사용
    return LayoutBuilder(
      builder: (context, constraints) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              // 2. 키보드가 올라왔을 때 스크롤 가능하도록 감쌈
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // 하단 패딩 자동 조절
              ),
              physics: const ClampingScrollPhysics(), // 탄성 제거 (깔끔한 스크롤)
              child: ConstrainedBox(
                // 3. 최소 높이를 화면 높이로 설정하여 평소에는 꽉 차게 보임
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  // 4. 내부의 Expanded가 작동하도록 IntrinsicHeight 사용
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // 진행률 바
                        _buildProgressBar(),
                        const SizedBox(height: 32),

                        // 질문 카드
                        // Expanded를 사용하여 남은 공간을 차지하되,
                        // 키보드가 올라오면 IntrinsicHeight 덕분에 스크롤 영역으로 변함
                        Expanded(child: _buildQuestionCard(currentQuestion)),
                        const SizedBox(height: 24),

                        // 네비게이션 버튼들
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
              '질문 ${_currentQuestionIndex + 1}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% 완료',
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
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이모지와 질문
          Row(
            children: [
              Text(question.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 힌트 텍스트
          Text(
            question.hint,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // 답변 입력 영역
          Expanded(
            child: TextField(
              controller: TextEditingController(
                text: _answers[question.id] ?? '',
              ),
              onChanged: (value) {
                _answers[question.id] = value;
              },
              scrollPadding: const EdgeInsets.only(bottom: 120),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: '여기에 자유롭게 적어주세요...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B73FF),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2D3748),
                height: 1.5,
              ),
            ),
          ),
        ],
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
              child: const Text(
                '이전',
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
            onPressed: _isLastQuestion()
                ? _completeQuestionnaire
                : _goToNextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              _isLastQuestion() ? '완료' : '다음',
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
                    child: const Text(
                      "닫기",
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
        emotionText = '기쁨';
        emotionColor = Colors.green;
        break;
      case EmotionType.SADNESS:
        emotionEmoji = '😢';
        emotionText = '슬픔';
        emotionColor = Colors.blue;
        break;
      case EmotionType.ANGER:
        emotionEmoji = '😡';
        emotionText = '분노';
        emotionColor = Colors.red;
        break;
      case EmotionType.ANXIETY:
        emotionEmoji = '😟';
        emotionText = '불안';
        emotionColor = Colors.orange;
        break;
      case EmotionType.TIREDNESS:
        emotionEmoji = '😴';
        emotionText = '무기력';
        emotionColor = Colors.deepPurple;
        break;
      case EmotionType.NEUTRAL:
        emotionEmoji = '😐';
        emotionText = '평온';
        emotionColor = Colors.grey;
        break;
      default:
        emotionEmoji = '🤔';
        emotionText = '미확인';
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
                "오늘의 감정: $emotionText", // ✅ 이모티콘과 텍스트 사용
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
            "AI 피드백", // ✅ 제목 변경
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
