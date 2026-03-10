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
import '../../generated/l10n.dart';
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

  List<PdiQuestion> get _pdiQuestions => [
    // Step 1: 기초 정보 (분석의 기준점 설정)
    PdiQuestion(id: 'q1', questionText: S.of(context).htp_premium_q1),

    // Step 2: 투사 질문 (집, 나무, 사람에 대한 무의식 탐색)
    PdiQuestion(id: 'q2', questionText: S.of(context).htp_premium_q2),
    PdiQuestion(id: 'q3', questionText: S.of(context).htp_premium_q3),
    PdiQuestion(id: 'q4', questionText: S.of(context).htp_premium_q4),

    PdiQuestion(id: 'q5', questionText: S.of(context).htp_premium_q5),
    PdiQuestion(id: 'q6', questionText: S.of(context).htp_premium_q6),
    PdiQuestion(id: 'q7', questionText: S.of(context).htp_premium_q7),

    PdiQuestion(id: 'q8', questionText: S.of(context).htp_premium_q8),
    PdiQuestion(id: 'q9', questionText: S.of(context).htp_premium_q9),

    // Step 3: 메타 인지 (자신의 그림 과정을 돌아보는 마무리 질문)
    PdiQuestion(id: 'q10', questionText: S.of(context).htp_premium_q10),
    PdiQuestion(id: 'q11', questionText: S.of(context).htp_premium_q11),
  ];

  /// 🎨 HTP 화면 설정값 (여기에만 HTP 관련 UI 정보가 있음)
  Map<String, dynamic> get _htpConfig => {
    'house': {
      'title': S.of(context).htp_premium_config1,
      'icon': Icons.home_rounded,
      'color': const Color(0xFF3182CE)
    },
    'tree': {
      'title': S.of(context).htp_premium_config2,
      'icon': Icons.park_rounded,
      'color': const Color(0xFF38A169)
    },
    'man': {
      'title': S.of(context).htp_premium_config3,
      'icon': Icons.face,
      'color': const Color(0xFF5A67D8)
    },
    'woman': {
      'title': S.of(context).htp_premium_config4,
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
          title:  Text(S.of(context).htp_premium_app_title),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 헤더 (공용 컴포넌트)
            PsyHeader(
              title: 'House-Tree-Person',
              description: S.of(context).htp_premium_header,
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
              title: S.of(context).htp_premium_pdi_title,
              icon: Icons.assignment_rounded,
              color: const Color(0xFFD69E2E),
              status: hasPdi ? PsyTaskStatus.completed : PsyTaskStatus.notStarted,
              isDarkMode: isDarkMode,

              // 커스텀 설정
              actionText: S.of(context).htp_premium_pdi_write,
              completedActionText: S.of(context).htp_premium_edit,
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
            text: S.of(context).htp_premium_submit(totalProgress), //"검사 결과 제출하기 ($totalProgress/5)"
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
        title: S.of(context).htp_premium_pdi_title,
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
          content:  Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text(S.of(context).htp_premium_image_fail),
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
          content:  Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text(S.of(context).htp_premium_image_empty),
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
                    S.of(context).htp_premium_preview(_getDrawingTitle(type)),
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
                    label: S.of(context).drawing_info_time,
                    value: '${drawing.durationSeconds}s',
                    icon: Icons.timer_outlined,
                  ),
                  const SizedBox(height: 8),

                  // ✅ 컴포넌트 사용
                  PsyInfoRow(
                    label: S.of(context).drawing_info_num,
                    value: '${drawing.strokeCount}',
                    icon: Icons.gesture_rounded,
                  ),

                  if (drawing.modificationCount > 0) ...[
                    const SizedBox(height: 8),
                    // ✅ 컴포넌트 사용
                    PsyInfoRow(
                      label: S.of(context).drawing_info_edit,
                      value: '${drawing.modificationCount}',
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
                      label: Text(S.of(context).htp_premium_edit),
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
                      label:  Text(S.of(context).htp_premium_confirm),
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
        return S.of(context).house;
      case 'tree':
        return S.of(context).tree;
      case 'man':
        return S.of(context).man;
      case 'woman':
        return S.of(context).woman;
      default:
        return S.of(context).painting;
    }
  }

  /// 🎨 검사 제출
  Future<void> _submitDrawings() async {
    final session = ref.read(htpPremiumSessionProvider); // 또는 singleTestSessionProvider
    if (session == null || session.drawings.isEmpty) return;

    // 1️⃣ 갤러리 저장 여부 묻기
    bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:  Row(
          children: [
            Icon(Icons.collections_rounded, color: Color(0xFF38A169)),
            SizedBox(width: 10),
            Text(S.of(context).drawing_save),
          ],
        ),
        content:Text(
          S.of(context).drawing_save_content,
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // 저장 안 함
            child: Text(S.of(context).drawing_no, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // 저장함
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38A169),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(S.of(context).drawing_save_yes, style: TextStyle(color: Colors.white)),
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
        title:  Text(S.of(context).drawing_submit),
        content: Text(S.of(context).drawing_submit_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(S.of(context).drawing_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSubmit(); // 실제 서버 전송 로직 실행
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38A169)),
            child:  Text(S.of(context).drawing_submit_agree, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _performSubmit() async {
    try {
      // 1. 세션 상태 가져오기
      final session = ref.read(htpPremiumSessionProvider);

      // 방어 로직: 세션이 없거나, 그림 4개가 다 안 그려졌거나, PDI가 없는 경우 튕겨냄
      if (session == null || session.drawings.length < 4 || session.pdiAnswers == null) {
        AiAnalysisHelper.showErrorSnackBar(context, S.of(context).drawing_submit_check);
        return;
      }

      // 2. 이미지 파일 리스트 추출
      // (만약 서버에서 집->나무->남자->여자 순서를 엄격히 요구한다면 아래 주석처리된 방식을 사용하세요)
      final imageFiles = session.drawings.map((d) => File(d.imagePath!)).toList();
      // 순서 보장형 추출이 필요하다면:
      // final imageFiles = <File>[];
      // for (final type in[HtpType.house, HtpType.tree, HtpType.man, HtpType.woman]) {
      //   final drawing = session.drawings.firstWhere((d) => d.type == type);
      //   imageFiles.add(File(drawing.imagePath!));
      // }

      // 3. 🚀 데이터 가공 로직 (아까 만든 공통 팩토리 재사용!)
      // 프리미엄의 그림 4개를 던져주면 알아서 총 시간, 획수, 평균 필압을 뽑아줍니다.
      final drawingProcess = DrawingProcess.fromEntities(session.drawings);

      // 4. AI 분석 요청 (프리미엄 전용 Notifier)
      await ref.read(htpAnalysisProvider.notifier).analyzePremium(
        imageFiles: imageFiles,              // 그림 4장
        pdiAnswers: session.pdiAnswers!,     // ✅ 프리미엄 핵심: PDI 답변 포함!
        drawingProcess: drawingProcess,      // 깔끔하게 가공된 메타데이터
      );

      // (참고: 로딩 다이얼로그나 결과창 이동은 ref.listen에서 처리)

    } catch (e) {
      debugPrint("❌ 프리미엄 제출 중 에러 발생: $e");
      AiAnalysisHelper.showErrorSnackBar(context, S.of(context).drawing_submit_error);
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
           SnackBar(content: Text(S.of(context).drawing_save_image)),
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
