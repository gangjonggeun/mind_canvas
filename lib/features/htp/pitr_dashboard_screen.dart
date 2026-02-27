// features/starry_sea/presentation/screens/starry_sea_dashboard_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_canvas/features/htp/presentation/providers/pitr_session_provider.dart';
import 'package:mind_canvas/features/htp/presentation/psy_dashboard_components.dart';

import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen.dart';

class PitrDashboardScreen extends ConsumerStatefulWidget {
  const PitrDashboardScreen({super.key});

  @override
  ConsumerState<PitrDashboardScreen> createState() =>
      _StarrySeaDashboardScreenState();
}

class _StarrySeaDashboardScreenState
    extends ConsumerState<PitrDashboardScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<PdiQuestion> _pdiQuestions = [
    PdiQuestion(id: 'q1', questionText: '이 바다의 날씨는 어떤가요?'),
    PdiQuestion(id: 'q2', questionText: '이곳에 누가 함께 있나요?'),
    PdiQuestion(id: 'q3', questionText: '그림을 그리면서 어떤 기분이 들었나요?'),
  ];

  // ✅ 다이얼로그 호출 함수
  void _openPdiDialog() {
    // 1. 기존 작성한 답변이 있는지 확인
    final session = ref.read(pitrSessionProvider);
    final initialAnswers = session?.pdiAnswers;

    // 2. 다이얼로그 띄우기
    showDialog(
      context: context,
      barrierDismissible: false, // 작성 중 실수로 닫히는 것 방지
      builder: (context) => PsyPdiDialog(
        title: '어항',
        questions: _pdiQuestions,
        initialAnswers: initialAnswers,
        onSubmit: (answers) {
          // 3. Provider에 저장
          ref.read(pitrSessionProvider.notifier).savePdiAnswers(answers);
        },
      ),
    );
  }

  /// 🌊 별바다 설정 (1개)
  final Map<String, dynamic> _config = {
    'pitr': {
      // Enum 이름과 매칭 추천
      'title': '빗속의 사람',
      'icon': Icons.umbrella,
      'color': const Color(0xFF5A67D8)
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ 별바다 세션 시작
      ref.read(pitrSessionProvider.notifier).startNewSession('user_123');
    });
  }

  // 📸 업로드
  Future<void> _handleImageUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await ref
        .read(pitrSessionProvider.notifier)
        .updateDrawingFromGallery(HtpType.starrySea, File(image.path));

    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final session = ref.watch(pitrSessionProvider);
    final drawing = ref.watch(pitrSessionProvider.notifier).getDrawing();

    final bool isDrawingCompleted = drawing != null;
    final bool hasPdiAnswers = session?.pdiAnswers != null && session!.pdiAnswers!.isNotEmpty;

    int completedCount = 0;
    if (isDrawingCompleted) completedCount++;
    if (hasPdiAnswers) completedCount++;

    final bool canSubmit = completedCount == 2;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("빗속의 사람 그림 심리검사"), backgroundColor: Colors.transparent, elevation: 0),

      // 💡 [수정1] 스크롤 영역에서는 제출 버튼 제외
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            PsyHeader(
              title: '빗속의 사람',
              description: '비가 내리고 있는 풍경과 그 속에 있는 사람을 자유롭게 그려보세요.',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            PsyProgressBar(current: completedCount, total: 2, isDarkMode: isDarkMode),
            const SizedBox(height: 30),

            ..._config.entries.map((entry) {
              final config = entry.value;
              return PsyTaskCard(
                title: config['title'],
                icon: config['icon'],
                color: config['color'],
                status: isDrawingCompleted ? PsyTaskStatus.completed : PsyTaskStatus.notStarted,
                isDarkMode: isDarkMode,
                onStart: () => _navigateToDrawing(config['title']),
                onUpload: _handleImageUpload,
                onPreview: _showPreview,
              );
            }).toList(),

            // const SizedBox(height: 16),

            // 💡 [수정2] PDI 카드에 커스텀 텍스트 및 업로드 숨김 적용
            PsyTaskCard(
              title: '질문지 작성 (PDI)',
              icon: Icons.assignment_rounded,
              color: const Color(0xFFD69E2E),
              status: hasPdiAnswers ? PsyTaskStatus.completed : PsyTaskStatus.notStarted,
              isDarkMode: isDarkMode,

              // 커스텀 설정
              actionText: '작성하기',          // "그리기" 대신 "작성하기"
              completedActionText: '수정하기', // "수정" 대신 "수정하기"
              actionIcon: Icons.edit_document, // 붓 대신 문서 작성 아이콘
              showUpload: false,           // 업로드 버튼 숨김!

              onStart: _openPdiDialog,
              onUpload: () {}, // showUpload가 false라 화면에 렌더링 안됨
              onPreview: _openPdiDialog,
            ),

            // 더 이상 제출 버튼이 여기에 없습니다!
          ],
        ),
      ),

      // 💡 [수정3] 화면 하단에 제출 버튼 고정 (스크롤 무관하게 항상 표시)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: PsySubmitButton(
            isEnabled: canSubmit,
            isSubmitting: false,
            text: "검사 결과 제출하기 ($completedCount/2)",
            onPressed: _submitDrawings,
          ),
        ),
      ),
    );
  }

  // --- 네비게이션 & 프리뷰 (스크린 내부 로직) ---

  void _navigateToDrawing(String title) async {
    // ✅ 기존 그리기 화면 재사용 (Type은 String이나 Enum으로 전달)
    final drawing = ref.read(pitrSessionProvider.notifier).getDrawing();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreen(
          // 이름은 나중에 DrawingScreen으로 변경 추천
          drawingType: 'pitr', // String으로 전달된다면
          title: title,
          existingSketchJson: drawing?.sketchJson,
        ),
      ),
    );
    setState(() {});
  }

  void _showPreview() {
    final drawing = ref.read(pitrSessionProvider.notifier).getDrawing();
    if (drawing == null) return;

    final imageFile = File(drawing.imagePath!);

    if (drawing == null || drawing.imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('저장된 이미지를 찾을 수 없습니다'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!imageFile.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('이미지 파일이 존재하지 않습니다'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.nights_stay_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '그림 미리보기',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // 이미지
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 정보
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ✅ 컴포넌트 사용
                  PsyInfoRow(
                    label: '소요 시간',
                    value: '${drawing.durationSeconds}초',
                    icon: Icons.timer_outlined,
                  ),
                  const SizedBox(height: 8),

                  // ✅ 컴포넌트 사용
                  PsyInfoRow(
                    label: '행동 횟수',
                    value: '${drawing.strokeCount}회',
                    icon: Icons.gesture_rounded,
                  ),

                  if (drawing.modificationCount > 0) ...[
                    const SizedBox(height: 8),
                    // ✅ 컴포넌트 사용
                    PsyInfoRow(
                      label: '수정 횟수',
                      value: '${drawing.modificationCount}회',
                      icon: Icons.edit_rounded,
                    ),
                  ],
                ],
              ),
            ),

            // 액션 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // 다이얼로그 닫기
                        // ✅ _navigateToDrawing 호출 (Sketch JSON 자동 전달됨)
                        _navigateToDrawing('pitr');
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('수정하기'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitDrawings() {
    // 별바다 제출 로직 (Analysis Provider 호출 등)
    print("pitr 제출!");
  }
}
