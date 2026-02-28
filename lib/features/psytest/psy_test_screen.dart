// lib/features/psytest/presentation/screens/psy_test_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/psytest/presentation/notifiers/test_content_notifier.dart';
import 'package:mind_canvas/features/psytest/presentation/notifiers/test_content_state.dart';
import '../../core/utils/ai_analysis_helper.dart';
import '../psy_result/data/mapper/test_result_mapper.dart';
import '../psy_result/presentation/psy_result_screen.dart';
import '../psy_result/presentation/screen/psy_result_screen2.dart';
import '../psy_result/psy_result_demo_screen.dart';
import 'data/model/test_question.dart';

/// [최종 버전] 데이터 기반의 유연한 심리 테스트 화면 (주관식 답변 기능 추가)
class PsyTestScreen extends ConsumerStatefulWidget {
  final int testId;
  final String testName;
  final String? testTag;

  const PsyTestScreen({
    super.key,
    required this.testId,
    required this.testName,
    this.testTag, // 리스트 화면에서 넘겨주세요 (예: "AI_BIG5")
  });

  @override
  ConsumerState<PsyTestScreen> createState() => _PsyTestScreenState();
}

class _PsyTestScreenState extends ConsumerState<PsyTestScreen>
    with TickerProviderStateMixin {
  // 🎨 테스트 진행 상태

  // ✅ Getter로 간결하게 접근
  List<List<TestQuestion>> get _questionPages {
    return ref.read(testContentNotifierProvider).questionPages ?? [];
  }

  int _currentPage = 0;

  int get _totalPages => _questionPages.length;

  // ✅ [새로 추가] 스크롤 컨트롤러
  late final ScrollController _scrollController;

  // ✅ [수정됨] 선택지 ID(String)와 주관식 답변(String)을 모두 저장하기 위해 dynamic 타입으로 변경
  final Map<String, dynamic> _answers = {};

  // ✅ [새로 추가] 주관식 답변의 TextEditingController를 관리하는 맵
  final Map<String, TextEditingController> _textControllers = {};

  // 🎨 애니메이션 컨트롤러
  late AnimationController _pageAnimationController;
  late Animation<double> _pageAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // ✅ [새로 추가] 스크롤 컨트롤러 초기화
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTestContent();
    });
  }

  // ✅ 수정 후 (간단하게)
  Future<void> _loadTestContent() async {
    await ref
        .read(testContentNotifierProvider.notifier)
        .loadTestContent(widget.testId);
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _scrollController.dispose();

    // ✅ 화면이 사라질 때 모든 컨트롤러를 메모리에서 해제하여 누수를 방지합니다.
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setupAnimations() {
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _pageAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // ✅ 추가: 상태 감시
    final contentState = ref.watch(testContentNotifierProvider);

    // ✅ 제출 완료/에러 감지
    ref.listen<TestContentState>(testContentNotifierProvider, (previous, next) {
      // 에러체크
      if (next.errorMessage != null && !next.isSubmitting) {
        AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
        return;
      }

      // 2. 🚨 [순서 중요] AI 분석 중인지 먼저 체크 (PENDING_AI)
      // 이 체크를 결과창 이동보다 먼저 해야 합니다.
      if (next.isCompleted && next.testResult?.resultKey == "PENDING_AI") {
        print("🤖 AI 분석 접수 확인 -> 다이얼로그 노출");
        AiAnalysisHelper.showPendingDialog(context);// 다이얼로그 띄우기 (여기서 홈으로 이동)
        return;
      }

      // 3. 일반 결과창 이동 (PENDING_AI가 아닐 때만 실행됨)
      if (next.isCompleted && next.testResult != null) {
        print("📊 일반 결과 도출 -> 결과창 이동");
        final psyResult = TestResultMapper.toEntity(next.testResult!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PsyResultScreen2(result: psyResult)),
        );
      }
    });

    // ✅ 추가: 로딩 처리
    if (contentState.isLoading) {
      return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ 추가: 에러 처리
    if (contentState.errorMessage != null) {
      return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('오류: ${contentState.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(testContentNotifierProvider.notifier)
                    .loadTestContent(widget.testId),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ 추가: 데이터 없음 처리
    final questionPages = contentState.questionPages;
    if (questionPages == null || questionPages.isEmpty) {
      return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        body: const Center(child: Text('테스트 콘텐츠가 없습니다')),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(isDarkMode, contentState),
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
          Expanded(
            child: Text(
              widget.testName,
              overflow: TextOverflow.ellipsis, // 길어지면 ...
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
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
  Widget _buildBody(bool isDarkMode, TestContentState contentState) {
    return SafeArea(
      child: Column(
        children:[
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // 👈 [추가] 여기로 컨트롤러 이동!
              physics: const BouncingScrollPhysics(),
              child: Column(
                children:[
                  _buildProgressIndicator(isDarkMode),
                  _buildQuestionContent(isDarkMode),
                ],
              ),
            ),
          ),
          _buildNavigationButtons(isDarkMode, contentState),
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
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3182CE),
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

  /// 🎨 질문 콘텐츠 영역
  Widget _buildQuestionContent(bool isDarkMode) {
    if (_currentPage >= _questionPages.length) {
      return _buildCompletionScreen(isDarkMode); // 완료 화면은 별도 처리
    }

    final currentQuestions = _questionPages[_currentPage];

    // ✅ 애니메이션 빌더
    return AnimatedBuilder(
      animation: _pageAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pageAnimation.value,
          child: ListView.builder(
            // 🚨 [수정 1] 스크롤은 부모(SingleChildScrollView)가 함
            physics: const NeverScrollableScrollPhysics(),
            // 🚨 [수정 2] 내용물 크기만큼만 높이 잡기
            shrinkWrap: true,

            // controller: _scrollController, 👈 [삭제] 부모가 스크롤하므로 필요 없음

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
              child: Image.network(
                question.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
          ],
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
          // ✅ [수정됨] 질문 타입에 따라 다른 위젯을 그립니다.
          if (question.type == QuestionType.text ||
              question.type == QuestionType.textarea)
            _buildSubjectiveInput(question, isDarkMode)
          else
            ...(question.options ?? []).map((option) {
              if (option.imageUrl != null)
                return _buildImageOption(question.id, option, isDarkMode);
              return _buildTextOption(question.id, option, isDarkMode);
            }).toList(),
        ],
      ),
    );
  }

  /// 🎨 텍스트 답변 옵션
  Widget _buildTextOption(
    String questionId,
    QuestionOption option,
    bool isDarkMode,
  ) {
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
              Expanded(
                child: Text(
                  option.text ?? '',
                  style: _optionTextStyle(isSelected, isDarkMode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 이미지 답변 옵션
  Widget _buildImageOption(
    String questionId,
    QuestionOption option,
    bool isDarkMode,
  ) {
    final isSelected = _answers[questionId] == option.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _answers[questionId] = option.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: _optionDecoration(
            isSelected,
            isDarkMode,
          ).copyWith(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  option.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (option.text != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    option.text!,
                    style: _optionTextStyle(isSelected, isDarkMode),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 주관식 답변 입력
  Widget _buildSubjectiveInput(TestQuestion question, bool isDarkMode) {
    final controller = _textControllers.putIfAbsent(
      question.id,
      () => TextEditingController(text: _answers[question.id] as String?),
    );

    // ✅ inputType 확인 (서버에서 "textarea"로 내려온다고 가정)
    // TestQuestion 모델에 inputType 필드가 없으면 map['inputType']을 확인하거나
    // 기본적으로 길이가 긴 질문은 textarea로 취급하는 로직 필요
    final isLongText = question.type == QuestionType.textarea;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: _optionDecoration(false, isDarkMode).copyWith(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
      ),
      child: TextField(
        controller: controller,
        onChanged: (text) => setState(() => _answers[question.id] = text),

        // ✅ [핵심] 텍스트 에어리어 스타일 적용
        maxLines: isLongText ? null : 1,
        // null이면 제한 없이 늘어남
        minLines: isLongText ? 5 : 1,
        // 최소 높이 확보
        keyboardType: isLongText ? TextInputType.multiline : TextInputType.text,
        textInputAction: isLongText
            ? TextInputAction.newline
            : TextInputAction.done,

        style: _optionTextStyle(false, isDarkMode).copyWith(
          fontWeight: FontWeight.normal,
          height: 1.5, // 줄간격 살짝 넉넉하게
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: isLongText
              ? '내용을 자유롭게 작성해주세요.\n(자세하고 솔직하게 적을수록 정확도가 올라갑니다.)'
              : '답변을 입력하세요...',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white38 : Colors.black38,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // ✅ 수정: 제출 중 상태 확인
  Widget _buildNavigationButtons(
    bool isDarkMode,
    TestContentState contentState,
  ) {
    final canGoNext = _canGoToNextPage();
    final isSubmitting = contentState.isSubmitting;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSubmitting ? null : _goToPreviousPage,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                label: const Text(
                  '이전',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDarkMode
                      ? Colors.white70
                      : const Color(0xFF718096),
                  side: BorderSide(
                    color: isDarkMode ? Colors.white30 : Colors.black26,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: (canGoNext && !isSubmitting) ? _goToNextPage : null,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      _currentPage == _totalPages - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
              label: Text(
                isSubmitting
                    ? '제출 중...'
                    : (_currentPage == _totalPages - 1 ? '완료' : '다음'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: (canGoNext && !isSubmitting)
                    ? const Color(0xFF3182CE)
                    : (isDarkMode ? Colors.white24 : Colors.black12),
                foregroundColor: (canGoNext && !isSubmitting)
                    ? Colors.white
                    : (isDarkMode ? Colors.white38 : Colors.black38),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Color(0xFF38A169),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

  // --- 중복 스타일을 위한 헬퍼 ---
  BoxDecoration _cardDecoration(bool isDarkMode) => BoxDecoration(
    color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: isDarkMode ? Colors.white12 : Colors.black12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 15,
        offset: const Offset(0, 4),
      ),
    ],
  );

  BoxDecoration _optionDecoration(bool isSelected, bool isDarkMode) =>
      BoxDecoration(
        color: isSelected
            ? const Color(0xFF3182CE).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF3182CE)
              : (isDarkMode ? Colors.white24 : Colors.black26),
          width: isSelected ? 2 : 1.5,
        ),
      );

  TextStyle _optionTextStyle(bool isSelected, bool isDarkMode) => TextStyle(
    fontSize: 16,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
    color: isSelected
        ? const Color(0xFF3182CE)
        : (isDarkMode ? Colors.white70 : const Color(0xFF4A5568)),
  );

  //==================================================================
  // ⚙️ 상태 관리 및 로직 함수들
  //==================================================================

  bool _canGoToNextPage() {
    // 마지막 페이지 넘어서는 항상 true
    if (_currentPage >= _questionPages.length) return true;

    final currentQuestions = _questionPages[_currentPage];

    for (final question in currentQuestions) {
      // 1. 답변 키가 아예 없거나 값이 null인 경우 (공통)
      if (!_answers.containsKey(question.id) || _answers[question.id] == null) {
        return false;
      }

      final answer = _answers[question.id];

      // 2. 주관식 (한 줄 or 여러 줄)인 경우: 빈 문자열 체크
      if (question.type == QuestionType.text ||
          question.type == QuestionType.textarea) {
        // String으로 형변환 후 trim()으로 공백 제거 확인
        if (answer is String && answer.trim().isEmpty) {
          return false;
        }
      }

      // 3. (선택사항) Drawing 타입이 추가된다면 여기서 파일 경로 체크 등 추가
    }

    return true;
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);

      _scrollController.jumpTo(0);

      _pageAnimationController.reset();
      _pageAnimationController.forward();
    } else {
      _submitTest();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);

      _scrollController.jumpTo(0);

      _pageAnimationController.reset();
      _pageAnimationController.forward();
    }
  }

  void _submitTest() {
    print('📤 _submitTest 호출됨');
    print('답변 데이터: $_answers');

    // ✅ AI 테스트 여부 확인 (태그가 'AI_'로 시작하거나 특정 태그 리스트에 포함)
    final isAiTest =
        widget.testTag != null &&
        widget.testTag!.toUpperCase().startsWith('AI');

    if (isAiTest) {
      print('🤖 AI 주관식 테스트 제출 로직 실행');
      // [신규] 주관식 제출 함수 호출
      ref
          .read(testContentNotifierProvider.notifier)
          .submitSubjectiveTest(
            testId: widget.testId,
            testTag: widget.testTag!, // "AI_BIG5"
            userAnswers: _answers,
          );
    } else {
      print('📝 일반 객관식 테스트 제출 로직 실행');
      // [기존] 일반 제출 함수 호출
      ref
          .read(testContentNotifierProvider.notifier)
          .submitTest(testId: widget.testId, userAnswers: _answers);
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('검사 종료'),
        content: const Text('정말로 검사를 종료하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('종료'),
          ),
        ],
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool isSelected;

  const _RadioCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF3182CE) : Colors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3182CE),
                ),
              ),
            )
          : null,
    );
  }
}
