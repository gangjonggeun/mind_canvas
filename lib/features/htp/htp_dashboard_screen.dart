// ... imports
// lib/features/htp/presentation/screens/htp_dashboard_screen.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/htp_analysis_notifier.dart';
import 'package:mind_canvas/features/htp/presentation/providers/htp_session_provider.dart';
import 'package:mind_canvas/features/htp/presentation/psy_dashboard_components.dart'; // ✅ 이미지 피커 추가

import '../../core/utils/ai_analysis_helper.dart';
import 'data/model/request/htp_basic_request.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen.dart';

class HtpDashboardScreen extends ConsumerStatefulWidget {
  const HtpDashboardScreen({super.key});

  @override
  ConsumerState<HtpDashboardScreen> createState() => _HtpDashboardScreenState();
}

class _HtpDashboardScreenState extends ConsumerState<HtpDashboardScreen> {
  final ImagePicker _picker = ImagePicker();

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
    'person': {
      'title': '사람 그리기',
      'icon': Icons.person_rounded,
      'color': const Color(0xFF805AD5)
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(htpSessionProvider);
      if (session == null) {
        ref.read(htpSessionProvider.notifier).startNewSession('user_123');
      }
    });
  }

  /// 📸 갤러리 이미지 업로드 핸들러
  Future<void> _handleImageUpload(String typeKey) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final htpType = _getHtpType(typeKey);
    await ref
        .read(htpSessionProvider.notifier)
        .updateDrawingFromGallery(htpType, File(image.path));

    if (mounted) setState(() {}); // UI 갱신
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final session = ref.watch(htpSessionProvider);
    final analysisState = ref.watch(htpAnalysisProvider);
    final completedCount = session?.drawings.length ?? 0;

    // ✅ [핵심 1] 분석/FCM 리스너 복구
    ref.listen<HtpTestState>(htpAnalysisProvider, (previous, next) {
      if (next.errorMessage != null && !next.isSubmitting) {
        AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
        return;
      }
      if (next.isCompleted && next.result?.resultKey == "PENDING_AI") {
        AiAnalysisHelper.showPendingDialog(context);
        ref.read(htpSessionProvider.notifier).clearSession();
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
              description: '순서에 상관없이 3가지 그림을 그려주세요.',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            // 2. 진행바 (공용 컴포넌트)
            PsyProgressBar(
              current: completedCount,
              total: 3,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            // 3. 카드 리스트 (설정값 기반으로 반복 생성)
            ..._htpConfig.entries.map((entry) {
              final typeKey = entry.key; // 'house'
              final config = entry.value;

              final htpType = _getHtpType(typeKey);
              final drawing =
                  ref.watch(htpSessionProvider.notifier).getDrawing(htpType);
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

            const SizedBox(height: 30),

            // 4. 제출 버튼 (공용 컴포넌트)
            PsySubmitButton(
              isEnabled: completedCount == 3,
              isSubmitting: analysisState.isSubmitting, // ✅ 로딩 상태 연결
              text: "검사 결과 제출하기 ($completedCount/3)",
              onPressed: _submitDrawings,
            ),
          ],
        ),
      ),
    );
  }

  // --- 기존 헬퍼 메서드들 (네비게이션 등) ---

  void _navigateToDrawing(String type, String title) async {
    final htpType = _getHtpType(type);
    final drawing = ref.read(htpSessionProvider.notifier).getDrawing(htpType);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreen(
          drawingType: type,
          title: title,
          existingSketchJson: drawing?.sketchJson,
        ),
      ),
    );
    setState(() {});
  }

  void _showPreview(String type) {
    final htpType = _getHtpType(type);
    final drawing = ref.read(htpSessionProvider.notifier).getDrawing(htpType);

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


// // 📍 정보 행 위젯 헬퍼
//   Widget _buildInfoRow(String label, String value, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
  /// 🎨 그림 제목 가져오기
  String _getDrawingTitle(String type) {
    switch (type) {
      case 'house':
        return '집';
      case 'tree':
        return '나무';
      case 'person':
        return '사람';
      default:
        return '그림';
    }
  }

  /// 🎨 검사 제출
  void _submitDrawings() {
    final session = ref.read(htpSessionProvider);
    if (session == null || session.drawings.length != 3) {
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
      final session = ref.read(htpSessionProvider)!;
      final imageFiles = <File>[];

      for (final type in [HtpType.house, HtpType.tree, HtpType.person]) {
        final drawing = session.drawings.firstWhere((d) => d.type == type);
        imageFiles.add(File(drawing.imagePath!));
      }

      final drawingProcess = DrawingProcess(
        drawOrder: _getDrawOrder(session.drawings),
        timeTaken: _getTotalTime(session),
        pressure: _getAveragePressure(session.drawings),
      );

      // ✅ 무거운 showDialog()를 삭제합니다.
      // 전송 중에는 버튼이 '전송중...'으로 바뀌어 중복 클릭을 막아줍니다.
      await ref.read(htpAnalysisProvider.notifier).analyzeBasic(
        imageFiles: imageFiles,
        drawingProcess: drawingProcess,
      );

      // 업로드가 완료되면 (서버에서 200 OK를 받으면)
      // 아래 build() 메서드의 ref.listen 이 자동으로 다이얼로그를 띄웁니다.

    } catch (e) {
      AiAnalysisHelper.showErrorSnackBar(context, '전송 중 오류: $e');
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
      case 'person':
        return HtpType.person;
      default:
        return HtpType.house;
    }
  }
}
