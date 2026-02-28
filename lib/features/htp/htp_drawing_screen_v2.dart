// lib/features/htp/presentation/screens/htp_drawing_screen_v2.dart

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_freehand/perfect_freehand.dart'; // ✅ 새로운 드로잉 엔진
import 'package:path_provider/path_provider.dart';

import 'package:mind_canvas/features/htp/presentation/providers/htp_session_provider.dart';
import 'data/model/dto/htp_data_collector.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_dashboard_screen.dart';

// --------------------------------------------------
// 1. 상태 관리를 위한 드로잉 모델 정의
// --------------------------------------------------

// 1. 펜 종류 Enum 정의
enum PenType {
  pen('펜', Icons.edit, 1.0, 0.5), // 기본 펜 (속도에 따라 적당히 얇아짐)
  brush('붓', Icons.brush, 1.5, 0.8), // 붓 (속도에 따라 확 얇아짐 -> 붓글씨 느낌)
  marker('마커', Icons.highlight, 2.5, 0.0), // 마커 (굵기 일정)
  pencil('연필', Icons.create, 0.6, 0.1), // 연필 (얇고 거의 일정함)
  spray('스프레이', Icons.scatter_plot, 3.0, 0.0);

  final String name;
  final IconData icon;
  final double sizeMultiplier; // 굵기 배수
  final double thinning; // 얇아지는 정도 (0~1)

  const PenType(this.name, this.icon, this.sizeMultiplier, this.thinning);
}

// 2. Stroke 클래스 수정
class Stroke {
  final List<PointVector> points;
  final Color color;
  final double baseSize;
  final PenType penType; // 👈 펜 종류 추가

  Stroke(this.points, this.color, this.baseSize, this.penType);

  Map<String, dynamic> toJson() => {
        'color': color.value,
        'size': baseSize,
        'penType': penType.name,
        'points': points.map((p) => {'x': p.x, 'y': p.y}).toList(),
      };

  static Stroke fromJson(Map<String, dynamic> json) {
    final pts = (json['points'] as List)
        .map((p) => PointVector(p['x'], p['y']))
        .toList();
    final type = PenType.values.firstWhere((e) => e.name == json['penType'],
        orElse: () => PenType.pen);
    return Stroke(pts, Color(json['color']), json['size'], type);
  }
}

// --------------------------------------------------
// 2. 화면 클래스 (A/B 테스트용 V2)
// --------------------------------------------------
class HtpDrawingScreenV2 extends StatefulWidget {
  final String drawingType;
  final String title;
  final String? existingSketchJson;

  final Future<void> Function(HtpDrawingEntity drawing, File imageFile)? onSave;

  const HtpDrawingScreenV2({
    super.key,
    required this.drawingType,
    required this.title,
    this.existingSketchJson,
    this.onSave,
  });

  @override
  State<HtpDrawingScreenV2> createState() => _HtpDrawingScreenV2State();
}

class _HtpDrawingScreenV2State extends State<HtpDrawingScreenV2>
    with TickerProviderStateMixin {
  final GlobalKey _canvasKey = GlobalKey();
  late HtpDataCollector _dataCollector;
  late int _drawingStartTime;
  PenType _currentPenType = PenType.pen;
  Color _currentColor = const Color(0xFF2D3748); // 기본 검정/차콜
  bool _isEraserMode = false;
  double _baseStrokeWidth = 4.0;
  double _transparency = 0.0;


  // ✅ HTP 필수 색상 팔레트 (살구색 포함 14색)
  final List<Color> _presetColors = [
    const Color(0xFF2D3748), // 먹색/검정
    const Color(0xFF718096), // 회색
    const Color(0xFFFFFFFF), // 흰색
    const Color(0xFF8B4513), // 갈색
    const Color(0xFFD2B48C), // 밝은 갈색
    const Color(0xFFFFCBA4), // 🍑 살구색 (피부색)
    const Color(0xFFE53E3E), // 빨강
    const Color(0xFFED8936), // 주황
    const Color(0xFFECC94B), // 노랑
    const Color(0xFFFEFCBF), // 연노랑
    const Color(0xFF38A169), // 초록
    const Color(0xFF9AE6B4), // 연초록
    const Color(0xFF319795), // 청록
    const Color(0xFF3182CE), // 파랑
    const Color(0xFF90CDF4), // 하늘색
    const Color(0xFF000080), // 남색
    const Color(0xFF805AD5), // 보라
    const Color(0xFFD6BCFA), // 연보라
    const Color(0xFFD53F8C), // 핑크
    // 20번째 칸은 '커스텀 색상' 버튼으로 UI에서 처리합니다.
  ];

  // ✅ V2 드로잉 상태 관리
  final ValueNotifier<List<Stroke>> _strokes = ValueNotifier([]); // 전체 선
  final ValueNotifier<Stroke?> _currentStroke =
      ValueNotifier(null); // 현재 긋고 있는 선
  final List<Stroke> _undoHistory = []; // Redo를 위한 히스토리

  // 브러시 설정
  double _strokeWidth = 3.0;


  @override
  void initState() {
    super.initState();
    _initializeDataCollector();
    _restoreExistingSketch();
  }

  void _initializeDataCollector() {
    _dataCollector = HtpDataCollector();
    _drawingStartTime = DateTime.now().millisecondsSinceEpoch;
  }

  void _restoreExistingSketch() {
    if (widget.existingSketchJson != null &&
        widget.existingSketchJson!.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(widget.existingSketchJson!);
        _strokes.value = decoded.map((e) => Stroke.fromJson(e)).toList();
      } catch (e) {
        print('❌ Sketch 복원 실패: $e');
      }
    }
  }

  @override
  void dispose() {
    _strokes.dispose();
    _currentStroke.dispose();
    super.dispose();
  }

  Widget _buildWoodenToolbar() {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Container(
        height: 110, // 👈 슬라이더를 위해 높이 증가
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8D6E63), Color(0xFF5D4037), Color(0xFF4E342E)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF3E2723), width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
            BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 1, offset: const Offset(0, -1)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 💡 1층: 도구 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolBtn(
                  icon: _currentPenType.icon,
                  color: _isEraserMode ? Colors.white54 : _currentColor.withOpacity(1.0),
                  isActive: !_isEraserMode,
                  onTap: () => setState(() => _isEraserMode = false),
                ),
                Container(width: 2, height: 24, color: const Color(0xFF3E2723)), // 구분선
                _buildToolBtn(
                  icon: Icons.cleaning_services_rounded,
                  color: _isEraserMode ? Colors.white : Colors.white54,
                  isActive: _isEraserMode,
                  onTap: () => setState(() => _isEraserMode = true),
                ),
                Container(width: 2, height: 24, color: const Color(0xFF3E2723)), // 구분선
                _buildToolBtn(
                  icon: Icons.settings_rounded,
                  color: Colors.white,
                  isActive: false,
                  onTap: _showSettingsBottomSheet,
                ),
              ],
            ),

            // 💡 2층: 선 굵기 슬라이더
            Row(
              children: [
                const Icon(Icons.line_weight_rounded, size: 18, color: Colors.white70),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.white.withOpacity(0.8),
                      thumbColor: Colors.white,
                      inactiveTrackColor: Colors.black.withOpacity(0.3),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      value: _baseStrokeWidth,
                      min: 1.0, max: 20.0,
                      onChanged: (val) => setState(() => _baseStrokeWidth = val),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${_baseStrokeWidth.toInt()}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolBtn(
      {required IconData icon,
      required Color color,
      required bool isActive,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  // --------------------------------------------------
  // ⚙️ 붓 & 색상 설정 바텀시트
  // --------------------------------------------------
  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Container(
            height: MediaQuery.of(context).size.height * 0.65, // 높이 살짝 증가
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 5, margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                // --- 브러시 종류 ---
                const Text('브러시 도구', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: PenType.values.map((pen) {
                      final isSelected = _currentPenType == pen;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => _currentPenType = pen);
                          setState(() { _currentPenType = pen; _isEraserMode = false; });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: isSelected ? const Color(0xFF38A169) : Colors.grey.withOpacity(0.2),
                                child: Icon(pen.icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 24),
                              ),
                              const SizedBox(height: 6),
                              Text(pen.name, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF38A169) : Colors.grey, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),

                // --- 🎚️ 투명도 조절 ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('투명도 (수채화 효과)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${_transparency.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                      activeTrackColor: Colors.blue,
                      thumbColor: Colors.blue,
                      inactiveTrackColor: Colors.blue.withOpacity(0.2)
                  ),
                  child: Slider(
                    value: _transparency,
                    min: 0,
                    max: 100, // 0~100% 직관적 조절
                    onChanged: (val) {
                      setModalState(() => _transparency = val);
                      setState(() => _transparency = val);
                    },
                  ),
                ),

                const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),

                // --- 🎨 색상 팔레트 (20칸) ---
                const Text('색상 팔레트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, crossAxisSpacing: 10, mainAxisSpacing: 10,
                    ),
                    itemCount: 20, // 19 프리셋 + 1 커스텀
                    itemBuilder: (context, index) {
                      // 💡 20번째 칸: 커스텀 색상 피커 버튼
                      if (index == 19) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // 바텀시트 닫고
                            _showCustomColorPicker(); // 커스텀 다이얼로그 열기
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.red]),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        );
                      }

                      // 💡 1~19번째 칸: 프리셋 색상
                      final color = _presetColors[index];
                      // 현재 선택된 색상인지 확인 (R,G,B 비교, 투명도는 제외)
                      final isSelected = _currentColor.value & 0xFFFFFF == color.value & 0xFFFFFF;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {});
                          setState(() {
                            // 선택한 색상에 현재 투명도를 적용하여 저장!
                            _currentColor = color.withOpacity(_transparency);
                            _isEraserMode = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color, shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6, spreadRadius: 2)] : null,
                          ),
                          child: isSelected ? Icon(Icons.check, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white, size: 18) : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
            const Text('나만의 색상 만들기', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: _CustomColorPicker(
            initialColor: _currentColor.withOpacity(1.0), // 투명도 제외하고 전달
            onColorChanged: (newColor) {
              setState(() {
                // 커스텀 색상을 선택하면 투명도(_opacity)를 입혀서 적용합니다.
                _currentColor = newColor.withOpacity(_transparency);
                _isEraserMode = false;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('완료', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 3. 제스처 핸들링 (그리기 로직)
  // --------------------------------------------------
  void _onPanStart(DragStartDetails details) {
    RenderBox box = _canvasKey.currentContext?.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);

    // 👇 [핵심] 투명도 0이면 opacity 1.0(불투명), 100이면 opacity 0.05(거의 투명)
    double actualOpacity = 1.0 - (_transparency / 100.0);
    actualOpacity = actualOpacity.clamp(0.05, 1.0); // 완전히 안 보이는 현상 방지

    // 색상에 투명도 적용
    final activeColor = _isEraserMode ? Colors.white : _currentColor.withOpacity(actualOpacity);

    _currentStroke.value = Stroke(
      [PointVector(point.dx, point.dy)],
      activeColor,
      _isEraserMode ? _baseStrokeWidth * 4.0 : _baseStrokeWidth * _currentPenType.sizeMultiplier,
      _isEraserMode ? PenType.marker : _currentPenType,
    );
    _undoHistory.clear();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStroke.value == null) return;
    RenderBox box = _canvasKey.currentContext?.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);

    final points = List<PointVector>.from(_currentStroke.value!.points)..add(PointVector(point.dx, point.dy));
    // 👈 penType 정보도 같이 업데이트
    _currentStroke.value = Stroke(points, _currentStroke.value!.color, _currentStroke.value!.baseSize, _currentStroke.value!.penType);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke.value != null) {
      // 완료된 선을 전체 목록에 추가
      _strokes.value = [..._strokes.value, _currentStroke.value!];
      _currentStroke.value = null;

      // HTP 분석용 데이터 기록
      _dataCollector.addStroke(0.5); // 필압 기본값 처리
      if (_isEraserMode) _dataCollector.addModification();
    }
  }

  // --------------------------------------------------
  // 4. 액션 버튼 로직 (Undo, Redo, Clear, Save)
  // --------------------------------------------------
  void _undo() {
    if (_strokes.value.isNotEmpty) {
      final strokes = List<Stroke>.from(_strokes.value);
      _undoHistory.add(strokes.removeLast());
      _strokes.value = strokes;
      _dataCollector.addModification();
    }
  }

  void _redo() {
    if (_undoHistory.isNotEmpty) {
      final strokes = List<Stroke>.from(_strokes.value);
      strokes.add(_undoHistory.removeLast());
      _strokes.value = strokes;
      _dataCollector.addModification();
    }
  }

  void _clearCanvas() {
    _strokes.value = [];
    _undoHistory.clear();
    _dataCollector.addModification();
  }

  void _toggleEraser() {
    setState(() => _isEraserMode = !_isEraserMode);
  }

  Future<void> _saveDrawing() async {
    try {
      // 1. JSON 저장
      final sketchJson =
          jsonEncode(_strokes.value.map((s) => s.toJson()).toList());

      // 2. 이미지 캡처
      final boundary = _canvasKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      final image = await boundary!.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/htp_v2_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(buffer);

      // 3. Entity 생성 (기존 코드와 동일)
      final drawing = _dataCollector
          .createDrawing(
        type: _getHtpType(widget.drawingType),
        startTime: _drawingStartTime,
        endTime: DateTime.now().millisecondsSinceEpoch,
        orderIndex: 0,
      )
          .copyWith(sketchJson: sketchJson);

      // 3️⃣ 👈 [수정] 콜백이 전달되었다면 프리미엄/싱글테스트 등에 저장, 없다면 기존 베이직에 저장!
      if (widget.onSave != null)
        await widget.onSave!(drawing, tempFile);


      Navigator.pop(context);
    } catch (e) {
      print("저장 에러: $e");
    }
  }

  HtpType _getHtpType(String typeString) {
    switch (typeString) {
    // Basic & Premium
      case 'house': return HtpType.house;
      case 'tree': return HtpType.tree;
      case 'person': return HtpType.person;
      case 'man': return HtpType.man;
      case 'woman': return HtpType.woman;
      case 'starrySea': return HtpType.starrySea;
      case 'pitr': return HtpType.pitr;
      case 'fishbowl': return HtpType.fishbowl;

    // 예외 처리
      default:
        print("⚠️ 알 수 없는 타입: $typeString -> 기본값 house로 처리됨");
        return HtpType.house;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.title}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _strokes.value.isNotEmpty ? _undo : null),
          IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _undoHistory.isNotEmpty ? _redo : null),
          IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _clearCanvas),
          IconButton(
              icon: const Icon(Icons.save, color: Colors.green),
              onPressed: _saveDrawing),
        ],
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background/htp_background_2_high.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🎨 그리기 영역 (핵심 최적화 부분)
          Positioned(
            top: 100,
            bottom: 160, // 슬라이더와 툴바가 가리지 않도록 여백 확보
            left: 20, right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: RepaintBoundary( // 캡처를 위한 바운더리
                  key: _canvasKey,
                  // 👇 [여기가 핵심] 터치 이벤트를 감지하는 곳입니다
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: Stack(
                      children: [
                        // 투명한 배경을 깔아둬야 터치가 빈 공간에서도 먹힙니다.
                        Container(color: Colors.transparent),

                        // 1. 이미 그려진 완료된 획들
                        ValueListenableBuilder<List<Stroke>>(
                          valueListenable: _strokes,
                          builder: (context, strokes, _) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: FreehandPainter(strokes: strokes),
                            );
                          },
                        ),
                        // 2. 현재 긋고 있는 획
                        ValueListenableBuilder<Stroke?>(
                          valueListenable: _currentStroke,
                          builder: (context, stroke, _) {
                            if (stroke == null) return const SizedBox.shrink();
                            return CustomPaint(
                              size: Size.infinite,
                              painter: FreehandPainter(strokes: [stroke]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),


          _buildWoodenToolbar(),
          //
          //
          // Positioned(
          //   bottom: 110, // 나무 툴바(40) + 높이(64) + 간격
          //   left: 40,
          //   right: 40,
          //   child: Container(
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.85),
          //       borderRadius: BorderRadius.circular(20),
          //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          //     ),
          //     child: Row(
          //       children: [
          //         const SizedBox(width: 16),
          //         Icon(Icons.line_weight_rounded, size: 20, color: Colors.grey.shade700),
          //         Expanded(
          //           child: SliderTheme(
          //             data: SliderThemeData(
          //               activeTrackColor: _currentColor.withOpacity(1.0),
          //               thumbColor: _currentColor.withOpacity(1.0),
          //               inactiveTrackColor: Colors.grey.shade300,
          //               trackHeight: 4,
          //               thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          //             ),
          //             child: Slider(
          //               value: _baseStrokeWidth,
          //               min: 1.0, max: 20.0,
          //               onChanged: (val) => setState(() => _baseStrokeWidth = val),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 30,
          //           child: Text(
          //             '${_baseStrokeWidth.toInt()}',
          //             style: const TextStyle(fontWeight: FontWeight.bold),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }
}

// --------------------------------------------------
// 5. Perfect Freehand용 커스텀 페인터
// --------------------------------------------------
class FreehandPainter extends CustomPainter {
  final List<Stroke> strokes;

  FreehandPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color // 투명도가 이미 포함된 색상
        ..style = PaintingStyle.fill;

      // 💦 [핵심] 스프레이 렌더링 로직
      if (stroke.penType == PenType.spray) {
        final double radius = stroke.baseSize * 1.5;

        for (var p in stroke.points) {
          // 좌표값을 시드로 사용하여 화면 갱신 시 입자가 떨리지 않게 고정!
          final random = Random((p.x * 1000).toInt() ^ (p.y * 1000).toInt());

          for (int i = 0; i < 8; i++) { // 1좌표당 8개의 입자
            final offsetX = (random.nextDouble() * 2 - 1) * radius;
            final offsetY = (random.nextDouble() * 2 - 1) * radius;
            // 입자가 원형 범위를 벗어나지 않게 커팅 (옵션)
            if (offsetX * offsetX + offsetY * offsetY <= radius * radius) {
              canvas.drawCircle(Offset(p.x + offsetX, p.y + offsetY), 1.0, paint);
            }
          }
        }
        continue; // 스프레이는 밑의 perfect_freehand 선 그리기를 건너뜀
      }

      // 🖋️ 기존 일반 펜/붓 렌더링 로직 (수정 없음)
      final options = StrokeOptions(
        size: stroke.baseSize,
        thinning: stroke.penType.thinning,
        smoothing: 0.6,
        streamline: 0.6,
      );
      final outlinePoints = getStroke(stroke.points, options: options);
      if (outlinePoints.isEmpty) continue;

      final path = Path();
      path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
      for (int i = 1; i < outlinePoints.length - 1; i++) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FreehandPainter oldDelegate) => true;
}

// =======================================================
// 커스텀 색상 피커 위젯 (RGB 조절기)
// =======================================================
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
        // 현재 만들어진 색상 미리보기
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [ BoxShadow(color: _currentColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 1) ],
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
}