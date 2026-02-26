// lib/features/htp/presentation/screens/htp_drawing_screen.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/htp/presentation/providers/htp_session_provider.dart';
import 'package:path_provider/path_provider.dart'; // ✅ 추가: getTemporaryDirectory용
import 'package:scribble/scribble.dart';

import '../home/domain/entities/recommended_content_entity.dart';
import 'data/model/dto/htp_data_collector.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_dashboard_screen.dart';

/// HTP 검사 그림 그리기 화면
class HtpDrawingScreen extends StatefulWidget {
  final String drawingType;
  final String title;
  final String? existingSketchJson;

  const HtpDrawingScreen({
    super.key,
    required this.drawingType,
    required this.title,
    this.existingSketchJson,
  });

  @override
  State<HtpDrawingScreen> createState() => _HtpDrawingScreenState();
}

class _HtpDrawingScreenState extends State<HtpDrawingScreen>
    with TickerProviderStateMixin {
  final GlobalKey _canvasKey = GlobalKey();
  // --------------------------------------------------
  // 멤버 변수 선언
  // --------------------------------------------------
  late HtpDataCollector _dataCollector;
  late int _drawingStartTime;
  late ScribbleNotifier _scribbleNotifier;

  // 애니메이션 컨트롤러
  late AnimationController _toolbarAnimationController;
  late AnimationController _colorPaletteController;
  late AnimationController _brushToolController;
  late Animation<double> _toolbarAnimation;
  late Animation<double> _colorPaletteAnimation;
  late Animation<double> _brushToolAnimation;

  // UI 상태
  bool _isColorPaletteExpanded = false;
  bool _isBrushToolExpanded = false;
  bool _isDrawingMode = true;

  // 그림 설정
  double _strokeWidth = 3.0;
  Color _currentColor = const Color(0xFF2D3748);
  BrushType _currentBrushType = BrushType.pen;

  // 최근 사용한 색상
  List<Color> _recentColors = [
    const Color(0xFF2D3748),
    const Color(0xFFE53E3E),
    const Color(0xFF3182CE),
  ];

  // 기본 색상 팔레트
  final List<Color> _basicColorPalette = [
    const Color(0xFF2D3748), const Color(0xFFE53E3E), const Color(0xFF3182CE),
    const Color(0xFF38A169), const Color(0xFFD69E2E), const Color(0xFF805AD5),
    const Color(0xFFD53F8C), const Color(0xFF319795), const Color(0xFF718096),
    const Color(0xFF1A202C), const Color(0xFFED8936), const Color(0xFF4299E1),
  ];

  // 속도/필압 계산용 변수
  int _previousLineCount = 0;
  DateTime? _strokeStartTime;

  // --------------------------------------------------
  // State 라이프사이클 (initState, dispose, build)
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _initializeDataCollector();

    // ✅ 기존 sketch 복원
    _restoreExistingSketch();

    _scribbleNotifier.addListener(_onScribbleUpdate);
  }


// ✅ 추가: 기존 sketch 복원 메서드
  void _restoreExistingSketch() {
    if (widget.existingSketchJson != null && widget.existingSketchJson!.isNotEmpty) {
      try {
        final sketchJson = jsonDecode(widget.existingSketchJson!);
        final sketch = Sketch.fromJson(sketchJson);

        _scribbleNotifier.setSketch(
          sketch: sketch,
          addToUndoHistory: false,
        );

        print('✅ 기존 그림 복원 완료 - 선 개수: ${sketch.lines.length}');
      } catch (e) {
        print('❌ Sketch 복원 실패: $e');
      }
    }
  }


  @override
  void dispose() {
    _scribbleNotifier.removeListener(_onScribbleUpdate);
    _scribbleNotifier.dispose();
    _toolbarAnimationController.dispose();
    _colorPaletteController.dispose();
    _brushToolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;


    // ✅ 시스템 insets 가져오기
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom; // 네비게이션 바 높이
    final topPadding = mediaQuery.padding.top; // 상태바 높이


    return Scaffold(
      // backgroundColor는 이제 배경 이미지에 가려지므로 그대로 두거나 제거해도 됩니다.
      backgroundColor:
      isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(theme, isDarkMode),
      body: Stack(
        children: [
          // ✅ 1. 여기에 배경 이미지 컨테이너를 추가합니다.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // ✅ 2. 이미지 경로를 정확하게 입력해주세요.
                // 예: 'assets/images/backgrounds/your_background.png'
                image: AssetImage('assets/images/background/htp_background_2_high.webp'),

                // ✅ 3. BoxFit.cover를 사용하여 화면을 꽉 채웁니다.
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- 여기부터는 기존의 UI 위젯들입니다 (순서 변경 없음) ---
          _buildDrawingInstruction(isDarkMode, topPadding),
          _buildDrawingArea(isDarkMode, topPadding, bottomPadding),
          _buildModernToolbar(theme, isDarkMode, bottomPadding),
          _buildColorPaletteOverlay(theme, isDarkMode),
          _buildBrushToolOverlay(theme, isDarkMode),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 초기화 및 설정 메서드
  // --------------------------------------------------
  void _initializeControllers() {
    _scribbleNotifier = ScribbleNotifier();
    _toolbarAnimationController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _colorPaletteController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _brushToolController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  void _setupAnimations() {
    _toolbarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _toolbarAnimationController, curve: Curves.elasticOut));
    _colorPaletteAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _colorPaletteController, curve: Curves.easeInOutCubic));
    _brushToolAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _brushToolController, curve: Curves.easeInOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _toolbarAnimationController.forward();
        });
      }
    });
  }

  void _initializeDataCollector() {
    _dataCollector = HtpDataCollector();
    _drawingStartTime = DateTime.now().millisecondsSinceEpoch;
    print('🎨 HTP 데이터 수집 시작: ${widget.drawingType}');
    print('   - 시작 시간: ${DateTime.fromMillisecondsSinceEpoch(_drawingStartTime)}');
  }

  // --------------------------------------------------
  // 핵심 로직 (필압 계산, 상태 업데이트 등)
  // --------------------------------------------------
  void _onScribbleUpdate() {
    final currentLineCount = _scribbleNotifier.currentSketch.lines.length;

    if (currentLineCount > _previousLineCount && _strokeStartTime != null) {
      final durationMs = DateTime.now().difference(_strokeStartTime!).inMilliseconds;
      final lastStroke = _scribbleNotifier.currentSketch.lines.last;
      final speed = _calculateStrokeSpeed(lastStroke.points, durationMs);
      final pressure = HtpDataCollector.calculatePressureFromSpeed(speed);

      _dataCollector.addStroke(pressure);
      print('🖋️ 스트로크 완료: 속도=${speed.toStringAsFixed(2)} pps, 추정 필압=${pressure.toStringAsFixed(2)}');

      if (!_isDrawingMode) {
        _dataCollector.addModification();
        print('Eraser used - Modification count: ${_dataCollector.modificationCount}');
      }
      _strokeStartTime = null;
    }

    _previousLineCount = currentLineCount;
    if (mounted) {
      setState(() {});
    }
  }

  double _calculateStrokeSpeed(List<Point> points, int durationMs) {
    if (points.length < 2 || durationMs <= 0) return 0.0;
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final offset1 = Offset(p1.x, p1.y);
      final offset2 = Offset(p2.x, p2.y);
      totalDistance += (offset2 - offset1).distance;
    }
    return (totalDistance / durationMs) * 1000;
  }

  // --------------------------------------------------
  // 상태 변경 및 로직 처리 메서드
  // --------------------------------------------------
  void _updateBrushSettings() {
    double adjustedWidth = _strokeWidth;
    Color adjustedColor = _currentColor;
    switch (_currentBrushType) {
      case BrushType.pen:
        adjustedWidth = _strokeWidth;
        adjustedColor = _currentColor.withOpacity(1.0);
        break;
      case BrushType.brush:
        adjustedWidth = _strokeWidth * 1.5;
        adjustedColor = _currentColor.withOpacity(0.8);
        break;
      case BrushType.marker:
        adjustedWidth = _strokeWidth * 2.5;
        adjustedColor = _currentColor.withOpacity(0.5);
        break;
      case BrushType.pencil:
        adjustedWidth = _strokeWidth * 0.7;
        adjustedColor = _currentColor.withOpacity(0.9);
        break;
      case BrushType.spray:
        adjustedWidth = _strokeWidth * 3.0;
        adjustedColor = _currentColor.withOpacity(0.3);
        break;
      case BrushType.crayon:
        adjustedWidth = _strokeWidth * 2.2;
        adjustedColor = _currentColor.withOpacity(0.85);
        break;
    }
    _scribbleNotifier.setStrokeWidth(adjustedWidth);
    _scribbleNotifier.setColor(adjustedColor);
  }

  void _selectBrushType(BrushType brushType) {
    setState(() {
      _currentBrushType = brushType;
    });
    _updateBrushSettings();
    _closeBrushTool();
  }

  void _selectColor(Color color) {
    setState(() {
      _currentColor = color;
      _isDrawingMode = true;
      _updateRecentColors(color);
    });
    _updateBrushSettings();
    if (_isColorPaletteExpanded) {
      _closeColorPalette();
    }
  }

  void _updateRecentColors(Color color) {
    _recentColors.removeWhere((c) => c.value == color.value);
    _recentColors.insert(0, color);
    if (_recentColors.length > 4) {
      _recentColors.removeLast();
    }
  }

  void _toggleEraser() {
    setState(() {
      _isDrawingMode = !_isDrawingMode;
    });
    if (_isDrawingMode) {
      _updateBrushSettings();
    } else {
      _scribbleNotifier.setColor(Colors.white);
      _scribbleNotifier.setStrokeWidth(_strokeWidth * 2.0);
    }
  }

  void _toggleColorPalette() {
    setState(() {
      _isColorPaletteExpanded = !_isColorPaletteExpanded;
    });
    if (_isColorPaletteExpanded) {
      _colorPaletteController.forward();
      if (_isBrushToolExpanded) _closeBrushTool();
    } else {
      _colorPaletteController.reverse();
    }
  }

  void _closeColorPalette() {
    setState(() { _isColorPaletteExpanded = false; });
    _colorPaletteController.reverse();
  }

  void _toggleBrushTool() {
    setState(() { _isBrushToolExpanded = !_isBrushToolExpanded; });
    if (_isBrushToolExpanded) {
      _brushToolController.forward();
      if (_isColorPaletteExpanded) _closeColorPalette();
    } else {
      _brushToolController.reverse();
    }
  }

  void _closeBrushTool() {
    setState(() { _isBrushToolExpanded = false; });
    _brushToolController.reverse();
  }

  void _undo() {
    _scribbleNotifier.undo();
    _dataCollector.addModification();
    print('↶ Undo - 수정 횟수: ${_dataCollector.modificationCount}');
  }

  void _redo() {
    _scribbleNotifier.redo();
    _dataCollector.addModification();
    print('↷ Redo - 수정 횟수: ${_dataCollector.modificationCount}');
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            const Text('그림 지우기'),
          ],
        ),
        content: const Text('정말로 그림을 모두 지우시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              _scribbleNotifier.clear();
              _dataCollector.addModification();
              Navigator.pop(context);
              print('🗑️ Clear - 수정 횟수: ${_dataCollector.modificationCount}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('그림이 지워졌습니다'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: const Text('지우기'),
          ),
        ],
      ),
    );
  }

  void _saveDrawing() async {
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final htpType = _getHtpType(widget.drawingType);

    try {
      print('💾 그림 저장 시작: ${widget.drawingType}');

      // 1. ✅ Sketch JSON 생성
      final currentSketch = _scribbleNotifier.currentSketch;
      final sketchJson = jsonEncode(currentSketch.toJson());

      // 2. HtpDrawingEntity 생성
      final drawing = _dataCollector.createDrawing(
        type: htpType,
        startTime: _drawingStartTime,
        endTime: endTime,
        orderIndex: 0,
      );

      print('   - 총 시간: ${drawing.durationSeconds}초');
      print('   - 행동 횟수: ${drawing.strokeCount}회');

      // 3. 이미지 캡처
      final boundary = _canvasKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('캔버스를 찾을 수 없습니다');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('이미지 변환 실패');
      }

      final buffer = byteData.buffer.asUint8List();
      print('✅ 이미지 크기: ${(buffer.length / 1024).toStringAsFixed(2)} KB');

      // 4. 임시 파일로 저장
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File(
        '${tempDir.path}/htp_${htpType.name}_$timestamp.png',
      );
      await tempFile.writeAsBytes(buffer);

      print('✅ 이미지 파일 저장: ${tempFile.path}');

      // 5. ✅ Sketch JSON과 함께 Provider에 저장
      if (!mounted) return;

      final container = ProviderScope.containerOf(context);
      final drawingWithSketch = drawing.copyWith(sketchJson: sketchJson);

      await container.read(htpSessionProvider.notifier).updateDrawing(
        drawingWithSketch, // ✅ Sketch JSON 포함
        tempFile,
      );

      // 6. 성공 다이얼로그
      if (!mounted) return;
      _showSaveSuccessDialog(drawing);

    } catch (e, stackTrace) {
      print('❌ 이미지 저장 실패: $e');
      print('StackTrace: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('저장 중 오류: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }


  // ✅ 다이얼로그를 별도 메서드로 분리 (가독성)
  void _showSaveSuccessDialog(HtpDrawingEntity drawing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF38A169),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '저장되었습니다!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('그리기 시간: ${drawing.durationSeconds}초'),
                  Text('행동 횟수: ${drawing.strokeCount}회'),
                  if (drawing.modificationCount > 0)
                    Text('수정 횟수: ${drawing.modificationCount}회'),
                ],
              ),
            ),
            const Text(
              '✅ 자동 저장되었습니다\n완료 시에도 수정 가능합니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF3182CE),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      '계속 그리기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3182CE),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pop(context); // 그리기 화면 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38A169),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      '완료하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  HtpType _getHtpType(String drawingType) {
    switch (drawingType.toLowerCase()) {
      case 'house': return HtpType.house;
      case 'tree': return HtpType.tree;
      case 'person': return HtpType.person;
      default: return HtpType.house;
    }
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  String _getDrawingInstruction() {
    switch (widget.drawingType) {
      case 'house': return '집을 그려주세요';
      case 'tree': return '나무를 그려주세요';
      case 'person': return '사람을 그려주세요';
      default: return '자유롭게 그려주세요';
    }
  }

  IconData _getDrawingIcon() {
    switch (widget.drawingType) {
      case 'house': return Icons.home_rounded;
      case 'tree': return Icons.park_rounded;
      case 'person': return Icons.person_rounded;
      default: return Icons.brush_rounded;
    }
  }

  void _showCustomColorPicker() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.palette_rounded, color: Theme.of(context).primaryColor, size: 24),
            const SizedBox(width: 8),
            const Text('색상 만들기', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: _CustomColorPicker(
            initialColor: _currentColor,
            onColorChanged: _selectColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _closeColorPalette();
            },
            child: const Text('완료'),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // UI 빌드 헬퍼 메서드
  // --------------------------------------------------
  Widget _buildGradientBackground(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [ const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF334155), ]
              : [ const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1), ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      title: Text(
        widget.title,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B).withOpacity(0.9) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)) ],
          ),
          child: Icon(Icons.arrow_back_ios_new, size: 20, color: isDarkMode ? Colors.white : const Color(0xFF2D3748)),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [ const Color(0xFF1E293B).withOpacity(0.95), const Color(0xFF334155).withOpacity(0.85) ]
                : [ Colors.white.withOpacity(0.95), const Color(0xFFF1F5F9).withOpacity(0.85) ],
          ),
        ),
      ),
      actions: [
        _buildActionButton(icon: Icons.undo_rounded, onPressed: _canUndo ? _undo : null, isEnabled: _canUndo, isDarkMode: isDarkMode, tooltip: '실행 취소'),
        _buildActionButton(icon: Icons.redo_rounded, onPressed: _canRedo ? _redo : null, isEnabled: _canRedo, isDarkMode: isDarkMode, tooltip: '다시 실행'),
        _buildActionButton(icon: Icons.refresh_rounded, onPressed: _clearCanvas, isEnabled: true, isDarkMode: isDarkMode, color: const Color(0xFFE53E3E), tooltip: '지우기'),
        _buildActionButton(icon: Icons.save_rounded, onPressed: _saveDrawing, isEnabled: true, isDarkMode: isDarkMode, color: const Color(0xFF38A169), tooltip: '저장'),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
    required bool isDarkMode,
    required String tooltip,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isEnabled ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)) : Colors.transparent,
                border: Border.all(
                  color: isEnabled ? (color ?? (isDarkMode ? Colors.white24 : Colors.black12)) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isEnabled ? (color ?? (isDarkMode ? Colors.white : Colors.black87)) : (isDarkMode ? Colors.white24 : Colors.black26),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* 캔버스 그리는곳
  * // 캔버스를 더 크게 하고 싶으면 (여유 공간 줄이기):
final topMargin = kToolbarHeight + topPadding + 68;  // 76 → 68
final bottomMargin = bottomPadding + 88;              // 96 → 88

// 캔버스를 약간 작게 하고 싶으면 (여유 공간 늘리기):
final topMargin = kToolbarHeight + topPadding + 84;  // 76 → 84
final bottomMargin = bottomPadding + 104;            // 96 → 104

// 안내문과의 간격만 조정하고 싶으면:
final topMargin = kToolbarHeight + topPadding + 80;  // +4 더 떨어짐

// 툴바와의 간격만 조정하고 싶으면:
final bottomMargin = bottomPadding + 100;            // +4 더 떨어짐
  * */
  Widget _buildDrawingArea(bool isDarkMode, double topPadding, double bottomPadding) {

    final topMargin = kToolbarHeight + topPadding + 81;
    final bottomMargin = bottomPadding + 101;

    return Positioned(
      top: topMargin,
      bottom: bottomMargin,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.8),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: RepaintBoundary(
            key: _canvasKey,
            child: Listener(
              onPointerDown: (event) {
                _strokeStartTime = DateTime.now();
              },
              child: Scribble(
                notifier: _scribbleNotifier,
                drawPen: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingInstruction(bool isDarkMode, double topPadding) {
    String instruction = _getDrawingInstruction();

    // ✅ AppBar 높이(56) + 상태바 + 여유 공간(24)
    final topPosition = kToolbarHeight + topPadding + 24;

    return Positioned(
      top: topPosition,
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [ const Color(0xFF1E293B).withOpacity(0.95), const Color(0xFF334155).withOpacity(0.9) ]
                  : [ Colors.white.withOpacity(0.95), const Color(0xFFF8FAFC).withOpacity(0.9) ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getDrawingIcon(), color: isDarkMode ? Colors.white70 : Colors.black54, size: 22),
              const SizedBox(width: 14),
              Text(
                instruction,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernToolbar(ThemeData theme, bool isDarkMode, double bottomPadding) {
    // ✅ 네비게이션 바 높이 + 여유 공간(20)
    final bottomPosition = bottomPadding + 20;

    return Positioned(
      bottom: bottomPosition,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _toolbarAnimation,
        builder: (context, child) {
          final animationValue = _toolbarAnimation.value.clamp(0.0, 1.0);
          return Transform.scale(
            scale: animationValue,
            child: Opacity(opacity: animationValue, child: _buildToolbarContent(theme, isDarkMode)),
          );
        },
      ),
    );
  }

  Widget _buildToolbarContent(ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [ const Color(0xFF1E293B).withOpacity(0.95), const Color(0xFF334155).withOpacity(0.9) ]
              : [ Colors.white.withOpacity(0.95), const Color(0xFFF8FAFC).withOpacity(0.9) ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 1, child: _buildBrushToolButton(isDarkMode)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildStrokeWidthControl(isDarkMode)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildColorSection(isDarkMode)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildEraserToggle(theme, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildBrushToolButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleBrushTool,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Icon(_currentBrushType.icon, color: isDarkMode ? Colors.white70 : Colors.black54, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            _currentBrushType.name,
            style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.white60 : Colors.black45, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeWidthControl(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.line_weight_rounded, size: 18, color: isDarkMode ? Colors.white70 : Colors.black54),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: _currentColor,
              inactiveTrackColor: isDarkMode ? Colors.white24 : Colors.black12,
              thumbColor: _currentColor,
            ),
            child: Slider(
              value: _strokeWidth,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              onChanged: (value) {
                setState(() => _strokeWidth = value);
                _updateBrushSettings();
              },
            ),
          ),
        ),
        Text(
          '${_strokeWidth.round()}px',
          style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.black45, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildColorSection(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              ..._recentColors.take(2).map((color) => _buildRecentColorItem(color, isDarkMode)),
              _buildColorPaletteButton(isDarkMode),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '색상',
          style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.black45, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildRecentColorItem(Color color, bool isDarkMode) {
    final isSelected = _currentColor == color;
    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : (isDarkMode ? Colors.white24 : Colors.black12),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [ BoxShadow(color: color.withOpacity(0.6), blurRadius: 4, spreadRadius: 1) ]
              : [ BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)) ],
        ),
      ),
    );
  }

  Widget _buildColorPaletteButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleColorPalette,
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.red, Colors.blue, Colors.green, Colors.orange]),
          shape: BoxShape.circle,
          border: Border.all(color: isDarkMode ? Colors.white24 : Colors.black12, width: 1),
          boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)) ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 12),
      ),
    );
  }

  Widget _buildEraserToggle(ThemeData theme, bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleEraser,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: !_isDrawingMode ? const Color(0xFFE53E3E) : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
              shape: BoxShape.circle,
              border: Border.all(
                color: !_isDrawingMode ? const Color(0xFFE53E3E) : (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1)),
                width: 2,
              ),
            ),
            child: Icon(
              !_isDrawingMode ? Icons.cleaning_services_rounded : Icons.auto_fix_high_rounded,
              color: !_isDrawingMode ? Colors.white : (isDarkMode ? Colors.white60 : Colors.black54),
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '지우개',
            style: TextStyle(
              fontSize: 11,
              color: !_isDrawingMode ? const Color(0xFFE53E3E) : (isDarkMode ? Colors.white60 : Colors.black45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrushToolOverlay(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _brushToolAnimation,
      builder: (context, child) {
        if (!_isBrushToolExpanded && _brushToolAnimation.value == 0) return const SizedBox.shrink();
        final animationValue = _brushToolAnimation.value.clamp(0.0, 1.0);
        return Positioned.fill(
          child: GestureDetector(
            onTap: _closeBrushTool,
            child: Container(
              color: Colors.black.withOpacity(0.3 * animationValue),
              child: Center(
                child: Transform.scale(
                  scale: animationValue,
                  child: Opacity(opacity: animationValue, child: _buildBrushToolGrid(isDarkMode)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrushToolGrid(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF334155)]
              : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), width: 1),
        boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15)) ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '브러시 도구',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : Colors.black87, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1),
            itemCount: BrushType.values.length,
            itemBuilder: (context, index) {
              final brushType = BrushType.values[index];
              final isSelected = _currentBrushType == brushType;
              return GestureDetector(
                onTap: () => _selectBrushType(brushType),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3182CE) : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3182CE) : (isDarkMode ? Colors.white24 : Colors.black12),
                      width: 1,
                    ),
                    boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF3182CE).withOpacity(0.3), blurRadius: 8, spreadRadius: 1)] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(brushType.icon, color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black54), size: 28),
                      const SizedBox(height: 8),
                      Text(
                        brushType.name,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black54)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorPaletteOverlay(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _colorPaletteAnimation,
      builder: (context, child) {
        if (!_isColorPaletteExpanded && _colorPaletteAnimation.value == 0) return const SizedBox.shrink();
        final animationValue = _colorPaletteAnimation.value.clamp(0.0, 1.0);
        return Positioned.fill(
          child: GestureDetector(
            onTap: _closeColorPalette,
            child: Container(
              color: Colors.black.withOpacity(0.3 * animationValue),
              child: Center(
                child: Transform.scale(
                  scale: animationValue,
                  child: Opacity(opacity: animationValue, child: _buildColorPaletteGrid(isDarkMode)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPaletteGrid(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF334155)]
              : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), width: 1),
        boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15)) ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '색상 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : Colors.black87, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity, height: 50,
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: _showCustomColorPicker,
              icon: const Icon(Icons.colorize_rounded, size: 20),
              label: const Text('사용자 정의 색상', style: TextStyle(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF805AD5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
            itemCount: _basicColorPalette.length,
            itemBuilder: (context, index) {
              final color = _basicColorPalette[index];
              final isSelected = _currentColor == color;
              return GestureDetector(
                onTap: () => _selectColor(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.white, width: 3) : Border.all(color: isDarkMode ? Colors.white24 : Colors.black12, width: 1),
                    boxShadow: isSelected
                        ? [ BoxShadow(color: color.withOpacity(0.6), blurRadius: 12, spreadRadius: 2) ]
                        : [ BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)) ],
                  ),
                  child: isSelected ? Icon(Icons.check_rounded, color: _getContrastColor(color), size: 24) : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 마지막 Getter
  // --------------------------------------------------
  bool get _canUndo => _scribbleNotifier.canUndo;
  bool get _canRedo => _scribbleNotifier.canRedo;

} // <--- 여기가 `_HtpDrawingScreenState` 클래스의 마지막 닫는 괄호입니다.

// =======================================================
// 파일의 나머지 부분 (다른 클래스와 enum들)
// =======================================================
enum BrushType {
  pen('펜', Icons.edit_rounded),
  brush('붓', Icons.brush_rounded),
  marker('마커', Icons.highlight_rounded),
  pencil('연필', Icons.create_rounded),
  spray('스프레이', Icons.scatter_plot_rounded),
  crayon('크레용', Icons.palette_rounded);

  const BrushType(this.name, this.icon);

  final String name;
  final IconData icon;
}

enum HtpDrawingType {
  house('집'),
  tree('나무'),
  person('사람');

  const HtpDrawingType(this.displayName);

  final String displayName;
}

class _CustomColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const _CustomColorPicker({
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<_CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<_CustomColorPicker> {
  late double _red;
  late double _green;
  late double _blue;

  @override
  void initState() {
    super.initState();
    _red = widget.initialColor.red.toDouble();
    _green = widget.initialColor.green.toDouble();
    _blue = widget.initialColor.blue.toDouble();
  }

  Color get _currentColor =>
      Color.fromARGB(255, _red.round(), _green.round(), _blue.round());

  void _updateColor() {
    widget.onColorChanged(_currentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [ BoxShadow(color: _currentColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 1) ],
          ),
          child: Center(
            child: Text(
              'RGB(${_red.round()}, ${_green.round()}, ${_blue.round()})',
              style: TextStyle(color: _getContrastColor(_currentColor), fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildColorSlider('빨강', _red, Colors.red, (value) {
          setState(() => _red = value);
          _updateColor();
        }),
        _buildColorSlider('초록', _green, Colors.green, (value) {
          setState(() => _green = value);
          _updateColor();
        }),
        _buildColorSlider('파랑', _blue, Colors.blue, (value) {
          setState(() => _blue = value);
          _updateColor();
        }),
      ],
    );
  }

  Widget _buildColorSlider(String label, double value, Color sliderColor, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: sliderColor,
                thumbColor: sliderColor,
                inactiveTrackColor: sliderColor.withOpacity(0.3),
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(value: value, min: 0, max: 255, divisions: 255, onChanged: onChanged),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              value.round().toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class HtpDrawingExample extends StatelessWidget {
  const HtpDrawingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTP 심리검사'),
        backgroundColor: const Color(0xFF3182CE),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'House-Tree-Person 검사',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              const Text(
                '심리검사를 시작해보세요',
                style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HtpDashboardScreen()),
                  ),
                  icon: const Icon(Icons.psychology_rounded, size: 24),
                  label: const Text('HTP 검사 시작', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3182CE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFF3182CE).withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}