// ... imports
// lib/features/htp/presentation/screens/htp_dashboard_premium_screen.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/htp_analysis_notifier.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/psy_analysis_state.dart';
import 'package:mind_canvas/features/htp/presentation/providers/htp_premium_session_provider.dart';
import 'package:mind_canvas/features/htp/presentation/psy_dashboard_components.dart'; // ✅ 이미지 피커 추가

import '../../core/utils/ai_analysis_helper.dart';
import 'data/model/request/htp_basic_request.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen.dart';
import 'htp_drawing_screen_v2.dart';

class HtpDashboardPremiumScreen extends ConsumerStatefulWidget {
  const HtpDashboardPremiumScreen({super.key});

  @override
  ConsumerState<HtpDashboardPremiumScreen> createState() => _HtpDashboardPremiumScreenState();
}

class _HtpDashboardPremiumScreenState extends ConsumerState<HtpDashboardPremiumScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<PdiQuestion> _pdiQuestions = [
    // Step 1: 기초 정보 (분석의 기준점 설정)
    PdiQuestion(id: 'q1', questionText: '사용자님의 성별과 나이는 어떻게 되나요? 답변하기 어렵다면 대략적으로 작성해 주세요.'),

    // Step 2: 투사 질문 (집, 나무, 사람에 대한 무의식 탐색)
    PdiQuestion(id: 'q2', questionText: '이 집에는 누가 살고 있으며, 집안에 들어갔을 때 전체적인 분위기는 어떤가요?'),
    PdiQuestion(id: 'q3', questionText: '이 집에서 가장 마음에 드는 곳이나, 추가로 필요한 것은 무엇인가요?'),
    PdiQuestion(id: 'q4', questionText: '이 집에서 사용자님이 가장 좋아하거나 머물고 싶은 공간은 어디인가요?'),

    PdiQuestion(id: 'q5', questionText: '이 나무는 어디에 서 있나요? 혼자 있나요, 아니면 다른 나무들과 함께 있나요?'),
    PdiQuestion(id: 'q6', questionText: '나무 기둥에 상처나 옹이가 있다면, 그것은 왜 생겼을까요?'),
    PdiQuestion(id: 'q7', questionText: '이 나무가 더 튼튼하고 행복하게 자라려면 무엇이 가장 필요할까요?'),

    PdiQuestion(id: 'q8', questionText: '그림 속의 남성과 여성은 사용자님과 어떤 관계인가요?'),
    PdiQuestion(id: 'q9', questionText: '이 사람들은 지금 각각 어떤 생각을 하고 있나요?'),

    // Step 3: 메타 인지 (자신의 그림 과정을 돌아보는 마무리 질문)
    PdiQuestion(id: 'q10', questionText: '그림을 그릴 때 지우개를 많이 썼거나, 망설였던 부분이 있나요? 있다면 어느 부분인가요?'),
    PdiQuestion(id: 'q11', questionText: '그림을 그리면서 특히 강조하고 싶었거나, 가장 기억에 남는 부분은 무엇인가요?'),
  ];

  /// 🎨 HTP 화면 설정값 (여기에만 HTP 관련 UI 정보가 있음)
  final Map<String, dynamic> _htpConfig = {
    'house': {
      'title': '집 그리기',
      'icon': Icons.home_rounded,
      'color': const Color(0xFF3182CE)
    },
    'tree': {
      'title': '나무 그리기',
      'icon': Icons.park_rounded,
      'color': const Color(0xFF38A169)
    },
    'man': {
      'title': '남성 그리기',
      'icon': Icons.face,
      'color': const Color(0xFF5A67D8)
    },
    'woman': {
      'title': '여성 그리기',
      'icon': Icons.face_3,
      'color': const Color(0xFF9F7AEA)
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(htpPremiumSessionProvider);
      if (session == null) {
        ref.read(htpPremiumSessionProvider.notifier).startNewSession('user_123');
      }
    });
  }

  /// 📸 갤러리 이미지 업로드 핸들러
  Future<void> _handleImageUpload(String typeKey) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final htpType = _getHtpType(typeKey);
    await ref
        .read(htpPremiumSessionProvider.notifier)
        .updateDrawingFromGallery(htpType, File(image.path));

    // 2️⃣ setState(() {}); 👈 이 줄은 삭제하세요! (ref.watch가 알아서 화면을 새로고침해줍니다)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final session = ref.watch(htpPremiumSessionProvider);

    // 1. 상태 계산
    final int drawingCount = session?.drawings.length ?? 0;
    final bool hasPdi = session?.pdiAnswers != null && session!.pdiAnswers!.isNotEmpty;

    // 2. 전체 진행률 (그림 4개 + PDI 1개 = 총 5단계)
    final int totalProgress = drawingCount + (hasPdi ? 1 : 0);

    // 3. 제출 가능 여부 (그림 4개 다 그리고 && PDI도 완료해야 함)
    final bool canSubmit = drawingCount == 4 && hasPdi;

    // ✅ [핵심 1] 분석/FCM 리스너 복구
    ref.listen<PsyAnalysisState>(htpAnalysisProvider, (previous, next) {
      if (next.errorMessage != null && !next.isSubmitting) {
        AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
        return;
      }
      if (next.isCompleted && next.result?.resultKey == "PENDING_AI") {
        AiAnalysisHelper.showPendingDialog(context);
        ref.read(htpPremiumSessionProvider.notifier).clearSession();
      }
    });

    return Scaffold(
      backgroundColor:
      isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
          title: const Text("HTP 심리검사"),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 헤더 (공용 컴포넌트)
            PsyHeader(
              title: 'House-Tree-Person',
              description: '순서에 상관없이 진행해주세요.',
              isDarkMode: isDarkMode,
              icon: Icons.home,
            ),
            const SizedBox(height: 30),

            // 2. 진행바 (공용 컴포넌트)
            PsyProgressBar(
              current: totalProgress,
              total: 5,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            // 3. 카드 리스트 (설정값 기반으로 반복 생성)
            ..._htpConfig.entries.map((entry) {
              final typeKey = entry.key; // 'house'
              final config = entry.value;

              final htpType = _getHtpType(typeKey);
              final drawing =
              ref.watch(htpPremiumSessionProvider.notifier).getDrawing(htpType);
              final status = drawing != null
                  ? PsyTaskStatus.completed
                  : PsyTaskStatus.notStarted;

              return PsyTaskCard(
                title: config['title'],
                icon: config['icon'],
                color: config['color'],
                status: status,
                isDarkMode: isDarkMode,
                // ✅ 동작 연결
                onStart: () => _navigateToDrawing(typeKey, config['title']),
                onUpload: () => _handleImageUpload(typeKey),
                onPreview: () => _showPreview(typeKey),
              );
            }).toList(),

            PsyTaskCard(
              title: '질문지 작성 (PDI)',
              icon: Icons.assignment_rounded,
              color: const Color(0xFFD69E2E),
              status: hasPdi ? PsyTaskStatus.completed : PsyTaskStatus.notStarted,
              isDarkMode: isDarkMode,

              // 커스텀 설정
              actionText: '작성하기',
              completedActionText: '수정하기',
              actionIcon: Icons.edit_document, // 붓 대신 문서 작성 아이콘
              showUpload: false,

              onStart: _openPdiDialog,
              onUpload: () {}, // showUpload가 false라 화면에 렌더링 안됨
              onPreview: _openPdiDialog,
            ),
            //
            // // 4. 제출 버튼 (공용 컴포넌트)
            // PsySubmitButton(
            //   isEnabled: completedCount == 3,
            //   isSubmitting: analysisState.isSubmitting, // ✅ 로딩 상태 연결
            //   text: "검사 결과 제출하기 ($completedCount/3)",
            //   onPressed: _submitDrawings,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: PsySubmitButton(
            isEnabled: canSubmit,
            isSubmitting: false,
            text: "검사 결과 제출하기 ($totalProgress/5)",
            onPressed: _submitDrawings,
          ),
        ),
      ),
    );
  }

  // --- 기존 헬퍼 메서드들 (네비게이션 등) ---
  void _openPdiDialog() {
    // 1. 기존 작성한 답변이 있는지 확인
    final session = ref.read(htpPremiumSessionProvider);
    final initialAnswers = session?.pdiAnswers;

    // 2. 다이얼로그 띄우기
    showDialog(
      context: context,
      barrierDismissible: false, // 작성 중 실수로 닫히는 것 방지
      builder: (context) => PsyPdiDialog(
        title: '그림 완성 후',
        questions: _pdiQuestions,
        initialAnswers: initialAnswers,
        onSubmit: (answers) {
          // 3. Provider에 저장
          ref.read(htpPremiumSessionProvider.notifier).savePdiAnswers(answers);
        },
      ),
    );
  }
  void _navigateToDrawing(String type, String title) async {
    final htpType = _getHtpType(type);
    final drawing = ref.read(htpPremiumSessionProvider.notifier).getDrawing(htpType);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreenV2(
          drawingType: type,
          title: title,
          existingSketchJson: drawing?.sketchJson,
          // 4️⃣ 👈 [핵심 추가] 닫히기 전에 Premium Provider에 저장하도록 연결!
          onSave: (newDrawing, file) async {
            await ref.read(htpPremiumSessionProvider.notifier).updateDrawing(newDrawing, file);
          },
        ),
      ),
    );
  }

  void _showPreview(String type) {
    final htpType = _getHtpType(type);
    final drawing = ref.read(htpPremiumSessionProvider.notifier).getDrawing(htpType);

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

    final imageFile = File(drawing.imagePath!);
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
                    _getDrawingIconByType(type),
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_getDrawingTitle(type)} 미리보기',
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
                        _navigateToDrawing(type, _getDrawingTitle(type));
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

// 📍 아이콘 헬퍼 메서드
  IconData _getDrawingIconByType(String type) {
    switch (type) {
      case 'house':
        return Icons.home_rounded;
      case 'tree':
        return Icons.park_rounded;
      case 'person':
        return Icons.person_rounded;
      default:
        return Icons.image_rounded;
    }
  }


  /// 🎨 그림 제목 가져오기
  String _getDrawingTitle(String type) {
    switch (type) {
      case 'house':
        return '집';
      case 'tree':
        return '나무';
      case 'man':
        return '남성';
      case 'woman':
        return '여성';
      default:
        return '그림';
    }
  }

  /// 🎨 검사 제출
  void _submitDrawings() {
    final session = ref.read(htpPremiumSessionProvider);
    if (session == null || session.drawings.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('모든 그림을 완성해주세요'),
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
      barrierDismissible: false, // 외부 클릭 방지
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.send_rounded, color: Color(0xFF38A169)),
                SizedBox(width: 8),
                Text('검사 제출'),
              ],
            ),
            content: const Text(
              'HTP 심리검사를 제출하시겠습니까?\n제출 후에는 수정할 수 없습니다.',
              style: TextStyle(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // 다이얼로그 닫기
                  await _performSubmit(); // 실제 제출 수행
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38A169),
                ),
                child: const Text('제출하기'),
              ),
            ],
          ),
    );
  }
  Future<void> _performSubmit() async {
    try {
      final session = ref.read(htpPremiumSessionProvider)!;
      final imageFiles = <File>[];

      for (final type in[HtpType.house, HtpType.tree, HtpType.man, HtpType.woman]) {
        final drawing = session.drawings.firstWhere((d) => d.type == type);
        imageFiles.add(File(drawing.imagePath!));
      }

      // ✅ 1. 메타데이터 생성 (기존에 작성해두신 헬퍼 메서드 사용)
      final drawingProcess = DrawingProcess(
        drawOrder: _getDrawOrder(session.drawings),
        timeTaken: _getTotalTime(session),
        pressure: _getAveragePressure(session.drawings),
        strokeCount: _getTotalStrokeCount(session.drawings),
        modificationCount: _getTotalModificationCount(session.drawings),
      );

      // ✅ 2. 갤러리 저장 (선택)
      await _saveImagesToGallery(session.drawings);

      // ✅ 3. Notifier 호출 시 drawingProcess도 같이 넘겨줌!
      await ref.read(htpAnalysisProvider.notifier).analyzePremium(
        imageFiles: imageFiles,
        pdiAnswers: session.pdiAnswers!,
        drawingProcess: drawingProcess, // 여기 추가!
      );

    } catch (e) {
      AiAnalysisHelper.showErrorSnackBar(context, '전송 중 오류: $e');
    }
  }

  int _getTotalStrokeCount(List<HtpDrawingEntity> drawings) {
    return drawings.fold(0, (sum, d) => sum + d.strokeCount);
  }

  int _getTotalModificationCount(List<HtpDrawingEntity> drawings) {
    return drawings.fold(0, (sum, d) => sum + d.modificationCount);
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

  String _getAveragePressure(List<HtpDrawingEntity> drawings) {
    if (drawings.isEmpty) return 'medium';

    final avgPressure = drawings
        .map((d) => d.averagePressure)
        .reduce((a, b) => a + b) / drawings.length;

    if (avgPressure < 0.3) return 'light';
    if (avgPressure < 0.7) return 'medium';
    return 'heavy';
  }


// 📍 헬퍼 메서드들 (기존과 동일)
  String _getDrawOrder(List<HtpDrawingEntity> drawings) {
    final sortedDrawings = List<HtpDrawingEntity>.from(drawings)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return sortedDrawings.map((d) => d.type.name).join('-');
  }

  String _getTotalTime(HtpSessionEntity session) {
    if (session.endTime == null) {
      return '측정 불가';
    }

    final totalSeconds = ((session.endTime! - session.startTime) / 1000)
        .round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '$minutes분 $seconds초';
  }

  HtpType _getHtpType(String type) {
    switch (type) {
      case 'house':
        return HtpType.house;
      case 'tree':
        return HtpType.tree;
      case 'man':
        return HtpType.man;     // 👈 [추가] 프리미엄용 남성
      case 'woman':
        return HtpType.woman;   // 👈[추가] 프리미엄용 여성
      case 'person':
        return HtpType.person;  // (베이직 하위호환용)
      default:
        return HtpType.house;
    }
  }
}
