// features/single_test/presentation/screens/single_test_dashboard_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_canvas/features/htp/presentation/enum/single_test_type.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/psy_analysis_state.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/single_test_analysis_notifier.dart';
import 'package:mind_canvas/features/htp/presentation/providers/single_test_session_provider.dart';
import 'package:mind_canvas/features/htp/presentation/psy_dashboard_components.dart';

import '../../core/utils/ai_analysis_helper.dart';
import 'data/model/request/htp_basic_request.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen_v2.dart'; // ✅ V2 드로잉 스크린 임포트 경로 확인

class SingleTestDashboardScreen extends ConsumerStatefulWidget {
  final SingleTestType testType; // 👈 홈에서 넘겨받음!

  const SingleTestDashboardScreen({required this.testType, super.key});

  @override
  ConsumerState<SingleTestDashboardScreen> createState() =>
      _SingleTestDashboardScreenState();
}

class _SingleTestDashboardScreenState
    extends ConsumerState<SingleTestDashboardScreen> {
  final ImagePicker _picker = ImagePicker();

  // 💡 타입에 따라 UI에 들어갈 설정값을 동적으로 뽑아냅니다.
  Map<String, dynamic> get _config {
    switch (widget.testType) {
      case SingleTestType.starrySea:
        return {
          'title': '별이 빛나는 밤바다',
          'desc': '밤하늘의 별과 바다를 자유롭게 그려주세요.',
          'icon': Icons.nights_stay_rounded,
          'color': const Color(0xFF5A67D8),
          'questions': [
            PdiQuestion(id: 'q1', questionText: '지금 이 밤하늘을 바라보고 있으면 어떤 기분이나 느낌이 드나요?'),
            PdiQuestion(id: 'q2', questionText: '가장 밝게 빛나는 별은 어디에 위치해 있나요?'),
            PdiQuestion(id: 'q3', questionText: '가장 밝게 빛나는 별을 보면 누가 생각 나나요?'),
            PdiQuestion(id: 'q4', questionText: '파도에서는 어떤 소리가 나나요? 들어가서 놀 수 있나요?'),
            PdiQuestion(id: 'q5', questionText: '만약 당신이 지금 저 바닷가에 있다면, 모래사장에서 무엇을 하고 싶나요?'),
            PdiQuestion(id: 'q6', questionText: '달빛이 있다면 비춰진 바다는 어떤 느낌 인가요?'),
          ]
        };
      case SingleTestType.pitr:
        return {
          'title': '비 속의 사람',
          'desc': '비가 내리고 있는 풍경과 그 속에 있는 사람을 자유롭게 그려보세요.',
          'icon': Icons.umbrella,
          'color': const Color(0xFF3182CE),
          'questions': [
            PdiQuestion(id: 'q1', questionText: '지금 내리고 있는 비를 맞으면 어떤 느낌이 들까요?'),
            PdiQuestion(id: 'q2', questionText: '그림 속 사람은 어디를 향해 가고 있나요?'),
            PdiQuestion(id: 'q3', questionText: '빗속에 서 있는 사람에게 선물을 하나 줄 수 있다면 무엇을 주고 싶나요?'),
            PdiQuestion(id: 'q4', questionText: '그림 속 사람 주변은 어떤 소리가 나고 어떤 냄새가 나나요?'),
            PdiQuestion(id: 'q5', questionText: '비가 그치고 하늘이 맑아지면, 이 사람은 어디로 가고 싶어 할까요?'),
          ]
        };
      case SingleTestType.fishbowl:
        return {
          'title': '어항과 물고기 가족들',
          'desc': '어항을 안을 물고기 가족과 소품들로 자유롭게 채워보세요.',
          'icon': Icons.set_meal_rounded,
          'color': const Color(0xFF00B5D8),
          'questions': [
            PdiQuestion(id: 'q1', questionText: '어항 속 물고기 중 \'나\'를 닮은 물고기가 있나요?'),
            PdiQuestion(id: 'q2', questionText: '물고기 가족들이 어항 안에서 가장 좋아하는 장소가 있을까요?'),
            PdiQuestion(id: 'q3', questionText: '물고기 가족들은 서로 마주치면 어떤 이야기를 나누나요?'),
            PdiQuestion(id: 'q4', questionText: '이 어항은 누가 관리하고 있나요?'),
            PdiQuestion(id: 'q5', questionText: '물고기 가족들은 어항 벽 너머 어디를 보고 있나요?'),
          ]
        };


      case SingleTestType.sinkingShip:
        return {
          'title': '가라앉는 배',
          'desc': '바다 한가운데서 가라앉고 있는 배와 그 주변 상황을 그려보세요.',
          'icon': Icons.directions_boat_rounded, // 배 모양 아이콘
          'color': const Color(0xFF2C5282), // 깊고 어두운 바다의 네이비
          'questions':[
            PdiQuestion(id: 'q1', questionText: '이 배는 왜 가라앉고 있나요? (암초, 폭풍, 고장 등)'),
            PdiQuestion(id: 'q2', questionText: '배 안에는 누가, 혹은 무엇이 타고 있나요?'),
            PdiQuestion(id: 'q3', questionText: '구명보트나 구명조끼는 충분히 준비되어 있나요?'),
            PdiQuestion(id: 'q4', questionText: '이 상황에서 구조대가 오고 있나요? 온다면 언제쯤 도착할까요?'),
            PdiQuestion(id: 'q5', questionText: '가라앉는 배를 지켜보는 당신의 마음은 어떤가요?'),
          ]
        };


      case SingleTestType.dewOnLeaf:
        return {
          'title': '나뭇잎 위의 이슬',
          'desc': '나뭇잎 위에 맺힌 투명한 아침 이슬 한 방울을 그려주세요.',
          'icon': Icons.water_drop_rounded, // 물방울 아이콘
          'color': const Color(0xFF48BB78), // 싱그러운 나뭇잎의 그린
          'questions':[
            PdiQuestion(id: 'q1', questionText: '이 이슬은 방금 맺힌 건가요, 아니면 밤새 맺혀 있던 건가요?'),
            PdiQuestion(id: 'q2', questionText: '이슬은 나뭇잎 위에 머물러 있는 지금, 평온해 보이나요 아니면 불안해 보이나요?'),
            PdiQuestion(id: 'q3', questionText: '이슬 안에 세상의 어떤 풍경이 비치고 있나요?'),
            PdiQuestion(id: 'q4', questionText: '햇빛이 강해지거나 바람이 불면 이 이슬은 어떻게 될까요?'),
            PdiQuestion(id: 'q5', questionText: '이 이슬 방울에게 조심스럽게 해주고 싶은 말이 있다면 무엇인가요?'),
          ]
        };

      case SingleTestType.road:
        return {
          'title': '길 (Road)',
          'desc': '어디론가 이어지는 길을 자유롭게 그려주세요.',
          'icon': Icons.edit_road_rounded, // 또는 alt_route
          'color': const Color(0xFFD69E2E), // 흙길을 연상시키는 따뜻한 옐로우브라운
          'questions':[
            PdiQuestion(id: 'q1', questionText: '이 길은 어디에서 시작해서 어디로 향하고 있나요?'),
            PdiQuestion(id: 'q2', questionText: '이 길을 걷고 있다면, 지금 앞으로 가고 있나요 아니면 뒤돌아보고 있나요?'),
            PdiQuestion(id: 'q3', questionText: '길 끝에는 무엇이 기다리고 있을까요?'),
            PdiQuestion(id: 'q4', questionText: '길을 걷다가 장애물을 만난다면 무엇일까요? 어떻게 지나갈 건가요?'),
            PdiQuestion(id: 'q5', questionText: '이 길 위에서 함께 걷고 싶은 사람이 있다면 누구인가요?'),
          ]
        };

      case SingleTestType.bridge:
        return {
          'title': '다리 (Bridge)',
          'desc': '무언가를 연결하는 다리와 그 주변 풍경을 그려주세요.',
          'icon': Icons.architecture_rounded, // 다리 모양과 어울리는 아이콘
          'color': const Color(0xFF718096), // 견고한 느낌의 쿨그레이
          'questions':[
            PdiQuestion(id: 'q1', questionText: '이 다리는 무엇과 무엇을 연결해 주고 있나요?'),
            PdiQuestion(id: 'q2', questionText: '다리 아래에는 무엇이 있나요? (예: 강, 절벽, 도로 등)'),
            PdiQuestion(id: 'q3', questionText: '이 다리는 얼마나 튼튼한가요? 흔들리지는 않나요?'),
            PdiQuestion(id: 'q4', questionText: '누군가 다리 건너편에서 당신을 기다리고 있다면 누구일까요?'),
            PdiQuestion(id: 'q5', questionText: '다리를 다 건너고 나면 당신의 기분은 어떨 것 같나요?'),
          ]
        };

      case SingleTestType.magicShop:
        return {
          'title': '마법 상점',
          'desc': '무엇이든 팔고 살 수 있는 신비한 마법 상점을 그려보세요.',
          'icon': Icons.storefront_rounded, // 또는 auto_awesome
          'color': const Color(0xFF9F7AEA), // 신비로운 보라색
          'questions':[
            PdiQuestion(id: 'q1', questionText: '이 마법 상점에서는 주로 어떤 물건을 팔고 있나요?'),
            PdiQuestion(id: 'q2', questionText: '당신은 이곳에서 무엇을 사고 싶나요?'),
            PdiQuestion(id: 'q3', questionText: '원하는 것을 사기 위해, 당신이 가진 것 중 무엇을 지불해야 하나요?'),
            PdiQuestion(id: 'q4', questionText: '상점의 주인은 어떤 모습이고, 당신에게 어떤 말을 건넸나요?'),
            PdiQuestion(id: 'q5', questionText: '물건을 사고 상점을 나서는 당신의 발걸음은 어떤가요?'),
          ]
        };

    // ==========================================
    // 치료(Therapy) 탭 추가 항목
    // ==========================================
      case SingleTestType.scribble:
        return {
          'title': '난화 (Scribble)',
          'desc': '눈을 감고 화면에 마음껏 선을 휘갈긴 후, 그 안에서 떠오르는 모양을 찾아 완성해 보세요.',
          'icon': Icons.gesture_rounded,
          'color': const Color(0xFFED8936), // 에너지가 느껴지는 오렌지
          'questions':[
            PdiQuestion(id: 'q1', questionText: '선을 막 휘갈길 때 기분이 어땠나요? (답답함, 시원함 등)'),
            PdiQuestion(id: 'q2', questionText: '어지러운 선들 속에서 어떤 모양이나 이미지를 발견했나요?'),
            PdiQuestion(id: 'q3', questionText: '이 그림에 제목을 붙여준다면 무엇이라고 짓고 싶나요?'),
            PdiQuestion(id: 'q4', questionText: '그려진 대상이 당신에게 하고 싶은 말이 있다면 무엇일까요?'),
          ]
        };

      case SingleTestType.weather:
        return {
          'title': '날씨와 기분 풍경',
          'desc': '지금 당신의 마음속 날씨는 어떤가요? 풍경으로 표현해 보세요.',
          'icon': Icons.cloud_circle_rounded,
          'color': const Color(0xFF4FD1C5), // 맑고 상쾌한 틸(Teal) 색상
          'questions':[
            PdiQuestion(id: 'q1', questionText: '그림 속 날씨는 현재 어떤 상태인가요? (맑음, 비, 폭풍 등)'),
            PdiQuestion(id: 'q2', questionText: '이 날씨는 언제부터 시작되었나요?'),
            PdiQuestion(id: 'q3', questionText: '그림 속에 당신이 있다면 어디에 있고, 무엇을 하고 있나요?'),
            PdiQuestion(id: 'q4', questionText: '조금 뒤, 이 풍경의 날씨는 어떻게 변할 것 같나요?'),
            PdiQuestion(id: 'q5', questionText: '이 날씨에 가장 필요한 물건이나 사람이 있다면 무엇일까요?'),
          ]
        };

      case SingleTestType.mandala:
        return {
          'title': '만다라 (Mandala)',
          'desc': '안전하고 동그란 원 안에 당신의 마음을 자유롭게 채워보세요.',
          'icon': Icons.filter_vintage_rounded, // 꽃 모양의 아이콘으로 만다라 상징
          'color': const Color(0xFFF687B3), // 마음을 따뜻하게 안아주는 핑크
          'questions':[
            PdiQuestion(id: 'q1', questionText: '원의 중심(가운데)에는 무엇을 그렸나요? 혹은 어떤 색을 칠했나요?'),
            PdiQuestion(id: 'q2', questionText: '그림을 그릴 때 원 안에서 밖으로 나갔나요, 아니면 밖에서 안으로 들어왔나요?'),
            PdiQuestion(id: 'q3', questionText: '원 안을 채우면서 마음이 어떻게 변했나요?'),
            PdiQuestion(id: 'q4', questionText: '원의 테두리는 당신에게 어떤 느낌을 주나요? (보호받는 느낌, 답답한 느낌 등)'),
            PdiQuestion(id: 'q5', questionText: '완성된 이 만다라의 제목을 지어주세요.'),
          ]
        };
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ 패밀리 Provider 호출 (동적 타입)
      ref
          .read(singleTestSessionProvider(widget.testType).notifier)
          .startNewSession('user_123');
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ 패밀리 Provider 구독 (동적 타입)
    final session = ref.watch(singleTestSessionProvider(widget.testType));
    final analysisState = ref.watch(singleTestAnalysisProvider);
    final drawing = ref
        .watch(singleTestSessionProvider(widget.testType).notifier)
        .getDrawing();

    final bool isDrawingCompleted = drawing != null;
    final bool hasPdiAnswers =
        session?.pdiAnswers != null && session!.pdiAnswers!.isNotEmpty;

    int completedCount = 0;
    if (isDrawingCompleted) completedCount++;
    if (hasPdiAnswers) completedCount++;

    final bool canSubmit = completedCount == 2;

    // ✅ [핵심 1] 분석/FCM 리스너 복구
    ref.listen<PsyAnalysisState>(singleTestAnalysisProvider, (previous, next) {
      if (next.errorMessage != null && !next.isSubmitting) {
        AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
        return;
      }
      if (next.isCompleted && next.result?.resultKey == "PENDING_AI") {
        AiAnalysisHelper.showPendingDialog(context);
        ref
            .read(singleTestSessionProvider(widget.testType).notifier)
            .clearSession();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(widget.testType.displayName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 💡 1. 고급 카드뷰 헤더
            PsyHeader(
              title: config['title'],
              description: config['desc'],
              icon: config['icon'],
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            PsyProgressBar(
                current: completedCount, total: 2, isDarkMode: isDarkMode),
            const SizedBox(height: 30),

            // 💡 2. 그림 카드
            PsyTaskCard(
              title: config['title'],
              icon: config['icon'],
              color: config['color'],
              status: isDrawingCompleted
                  ? PsyTaskStatus.completed
                  : PsyTaskStatus.notStarted,
              isDarkMode: isDarkMode,
              onStart: () => _navigateToDrawing(config['title']),
              onUpload: _handleImageUpload,
              onPreview: _showPreview,
            ),
            // const SizedBox(height: 16),

            // 💡 3. 질문지 (PDI) 카드
            PsyTaskCard(
              title: '질문지 작성 (PDI)',
              icon: Icons.assignment_rounded,
              color: const Color(0xFFD69E2E),
              status: hasPdiAnswers
                  ? PsyTaskStatus.completed
                  : PsyTaskStatus.notStarted,
              isDarkMode: isDarkMode,
              actionText: '작성하기',
              completedActionText: '수정하기',
              actionIcon: Icons.edit_document,
              showUpload: false,
              onStart: _openPdiDialog,
              onUpload: () {},
              onPreview: _openPdiDialog,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: PsySubmitButton(
            isEnabled: canSubmit,
            isSubmitting: analysisState.isSubmitting,
            text: "검사 제출하기 ($completedCount/2)",
            onPressed: _submitDrawings,
          ),
        ),
      ),
    );
  }

  // =======================================================
  // 동적 로직 업데이트 (하드코딩 제거됨)
  // =======================================================

  Future<void> _handleImageUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // ✅ 동적 Provider 호출 (HtpType 안 넘겨도 됨, Provider가 알아서 처리)
    await ref
        .read(singleTestSessionProvider(widget.testType).notifier)
        .updateDrawingFromGallery(File(image.path));

    if (mounted) setState(() {});
  }

  void _openPdiDialog() {
    // ✅ 동적 Provider 호출
    final session = ref.read(singleTestSessionProvider(widget.testType));
    final initialAnswers = session?.pdiAnswers;
    final config = _config;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PsyPdiDialog(
        title: '그림 완성 후', // ✅ 하드코딩 제거
        questions: config['questions'], // ✅ config에서 퀘스천 가져오기
        initialAnswers: initialAnswers,
        onSubmit: (answers) {
          ref
              .read(singleTestSessionProvider(widget.testType).notifier)
              .savePdiAnswers(answers);
        },
      ),
    );
  }

  void _navigateToDrawing(String title) async {
    // 1. 현재 저장된 그림 정보 가져오기 (이어그리기 용)
    final drawing = ref
        .read(singleTestSessionProvider(widget.testType).notifier)
        .getDrawing();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreenV2(
          // 2. 화면에 표시할 타입 정보 (starrySea 등)
          drawingType: widget.testType.name,
          title: title,
          existingSketchJson: drawing?.sketchJson,

          // ✅ 3. [핵심] 저장 콜백 추가!
          // "저장 버튼을 누르면 이 함수를 실행해줘" 라고 전달
          onSave: (newDrawing, imageFile) async {
            // 여기서 '싱글 테스트 전용 Provider'를 호출합니다.
            await ref
                .read(singleTestSessionProvider(widget.testType).notifier)
                .updateDrawing(newDrawing, imageFile);
          },
        ),
      ),
    );

    // 4. 돌아왔을 때 화면 갱신
    if (mounted) setState(() {});
  }

  void _showPreview() {
    // ✅ 동적 Provider 호출
    final drawing = ref
        .read(singleTestSessionProvider(widget.testType).notifier)
        .getDrawing();
    if (drawing == null || drawing.imagePath == null) return;

    final imageFile = File(drawing.imagePath!);
    if (!imageFile.existsSync()) return;

    final config = _config;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: config['color'].withOpacity(0.1), // ✅ 동적 색상
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(config['icon'], color: config['color'], size: 24),
                  // ✅ 동적 아이콘
                  const SizedBox(width: 12),
                  const Text('그림 미리보기',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),

            // 이미지
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9),
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(imageFile, fit: BoxFit.contain)),
            ),

            // 정보
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  PsyInfoRow(
                      label: '소요 시간',
                      value: '${drawing.durationSeconds}초',
                      icon: Icons.timer_outlined),
                  const SizedBox(height: 8),
                  PsyInfoRow(
                      label: '행동 횟수',
                      value: '${drawing.strokeCount}회',
                      icon: Icons.gesture_rounded),
                  if (drawing.modificationCount > 0) ...[
                    const SizedBox(height: 8),
                    PsyInfoRow(
                        label: '수정 횟수',
                        value: '${drawing.modificationCount}회',
                        icon: Icons.edit_rounded),
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
                        Navigator.pop(context);
                        _navigateToDrawing(config['title']); // ✅ 동적 타이틀
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('수정하기'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
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




  Future<void> _submitDrawings() async {
    final session = ref.read(singleTestSessionProvider(widget.testType));// 또는 singleTestSessionProvider
    if (session == null || session.drawings.isEmpty) return;

    // 1️⃣ 갤러리 저장 여부 묻기
    bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.collections_rounded, color: Color(0xFF38A169)),
            SizedBox(width: 10),
            Text('그림 저장'),
          ],
        ),
        content: const Text(
          '그린 그림들을 갤러리에 저장하시겠습니까?\n분석 결과 페이지에서도 확인할 수 있습니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // 저장 안 함
            child: const Text('아니요', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // 저장함
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38A169),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('네, 저장할게요', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // 2️⃣ 사용자가 '네'를 선택한 경우에만 저장 로직 실행
    if (shouldSave == true) {
      await _saveImagesToGallery(session.drawings);
    }

    // 3️⃣ 최종 제출 다이얼로그 (수정할 수 없다는 안내) 띄우기
    _showFinalConfirmDialog();
  }

  /// 💾 최종 서버 제출 전 확인 및 실제 전송 호출
  void _showFinalConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('검사 제출'),
        content: const Text('분석을 시작할까요?\n제출 후에는 그림을 수정할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSubmit(); // 실제 서버 전송 로직 실행
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38A169)),
            child: const Text('제출하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  Future<void> _performSubmit() async {
    try {
      // 1. 세션 상태 가져오기 및 Null / 빈 값 체크 (에러 1 해결 ✅)
      final session = ref.read(singleTestSessionProvider(widget.testType));
      if (session == null || session.drawings.isEmpty) {
        AiAnalysisHelper.showErrorSnackBar(context, '분석할 그림이 없습니다.');
        return;
      }

      // 단일 테스트이므로 첫 번째(유일한) 그림 가져오기
      final drawing = session.drawings.first;

      // 2. 🚀 데이터 가공 로직 (아까 만든 공통 팩토리 재사용!)
      // 싱글이든 다중이든 session.drawings만 던져주면 알아서 계산합니다.
      final drawingProcess = DrawingProcess.fromEntities(session.drawings);


      // 3. AI 분석 요청 (에러 2, 3 해결 ✅)
      // 싱글 테스트 Notifier의 파라미터 스펙에 정확히 맞춥니다.
      await ref.read(singleTestAnalysisProvider.notifier).submitTest(
        testType: widget.testType,              // 현재 진행 중인 테스트 타입 (starrySea 등)
        imageFile: File(drawing.imagePath!),    // List가 아닌 단일 파일 전달
        pdiAnswers: session.pdiAnswers ?? {},   // 세션에 저장된 PDI 답변 전달
        drawingProcess: drawingProcess,         // 깔끔하게 가공된 메타데이터
      );

      // (참고: 로딩 다이얼로그나 결과창 이동은 ref.listen에서 처리)

    } catch (e) {
      debugPrint("❌ 제출 중 에러 발생: $e");
      AiAnalysisHelper.showErrorSnackBar(context, '전송 중 오류가 발생했습니다: $e');
    }
  }



  Future<void> _saveImagesToGallery(List<HtpDrawingEntity> drawings) async {
    try {
      // 권한 요청 (Gal이 알아서 OS 버전에 맞게 처리해줍니다)
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      int successCount = 0;
      for (var drawing in drawings) {
        if (drawing.imagePath != null) {
          final File file = File(drawing.imagePath!);
          if (await file.exists()) {
            // ✅ Gal을 사용하여 저장 (앨범 이름 지정 가능)
            await Gal.putImage(
              file.path,
              album: 'MindCanvas', // 앨범 이름 설정
            );
            successCount++;
          }
        }
      }

      if (successCount > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리에 그림이 저장되었습니다 📸')),
        );
      }
    } catch (e) {
      print("갤러리 저장 실패: $e");
      // GalException 처리 (권한 거부 등)
      if (e is GalException) {
        print("Gal 에러: ${e.type}");
      }
    }
  }
}
