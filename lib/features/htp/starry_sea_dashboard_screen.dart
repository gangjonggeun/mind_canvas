// features/starry_sea/presentation/screens/starry_sea_dashboard_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_canvas/features/htp/presentation/providers/starry_sea_session_provider.dart';
import 'package:mind_canvas/features/htp/presentation/psy_dashboard_components.dart';

import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen.dart';



class StarrySeaDashboardScreen extends ConsumerStatefulWidget {
  const StarrySeaDashboardScreen({super.key});

  @override
  ConsumerState<StarrySeaDashboardScreen> createState() => _StarrySeaDashboardScreenState();
}

class _StarrySeaDashboardScreenState extends ConsumerState<StarrySeaDashboardScreen> {
  final ImagePicker _picker = ImagePicker();

  /// 🌊 별바다 설정 (1개)
  final Map<String, dynamic> _config = {
    'starrySea': { // Enum 이름과 매칭 추천
      'title': '별이 빛나는 밤바다',
      'icon': Icons.nights_stay_rounded,
      'color': const Color(0xFF5A67D8)
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ 별바다 세션 시작
      ref.read(starrySeaSessionProvider.notifier).startNewSession('user_123');
    });
  }

  // 📸 업로드
  Future<void> _handleImageUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // ✅ 별바다 타입으로 저장
    await ref.read(starrySeaSessionProvider.notifier)
        .updateDrawingFromGallery(HtpType.starrySea, File(image.path));

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ 별바다 Provider 감시
    final session = ref.watch(starrySeaSessionProvider);
    final drawing = ref.watch(starrySeaSessionProvider.notifier).getDrawing();
    final isCompleted = drawing != null; // 그림 1개 있으면 완료

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("별바다 심리검사"), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 헤더
            PsyHeader(
              title: '별이 빛나는 밤바다',
              description: '밤하늘의 별과 바다를 자유롭게 그려주세요.',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            // 2. 진행바 (0 or 1)
            PsyProgressBar(
              current: isCompleted ? 1 : 0,
              total: 1,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),

            // 3. 카드 (설정값 기반 1개 생성)
            ..._config.entries.map((entry) {
              final config = entry.value;
              final status = isCompleted ? PsyTaskStatus.completed : PsyTaskStatus.notStarted;

              return PsyTaskCard(
                title: config['title'],
                icon: config['icon'],
                color: config['color'],
                status: status,
                isDarkMode: isDarkMode,
                onStart: () => _navigateToDrawing(config['title']),
                onUpload: _handleImageUpload,
                onPreview: _showPreview, // 파라미터 없이 호출 (1개라 명확함)
              );
            }).toList(),

            const SizedBox(height: 30),

            // 4. 제출 버튼
            PsySubmitButton(
              isEnabled: isCompleted,
              isSubmitting: false, // 별바다 분석 상태(Not implemented yet) 연결
              text: "검사 결과 제출하기",
              onPressed: _submitDrawings,
            ),
          ],
        ),
      ),
    );
  }

  // --- 네비게이션 & 프리뷰 (스크린 내부 로직) ---

  void _navigateToDrawing(String title) async {
    // ✅ 기존 그리기 화면 재사용 (Type은 String이나 Enum으로 전달)
    final drawing = ref.read(starrySeaSessionProvider.notifier).getDrawing();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreen( // 이름은 나중에 DrawingScreen으로 변경 추천
          drawingType: 'starrySea', // String으로 전달된다면
          title: title,
          existingSketchJson: drawing?.sketchJson,
        ),
      ),
    );
    setState(() {});
  }

  void _showPreview() {
    final drawing = ref.read(starrySeaSessionProvider.notifier).getDrawing();
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
                    Icons.shield_moon,
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
                        _navigateToDrawing('starrySea');
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
    print("별바다 제출!");
  }
}