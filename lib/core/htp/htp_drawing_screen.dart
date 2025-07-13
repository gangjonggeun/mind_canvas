// lib/features/htp/presentation/screens/htp_drawing_screen.dart

import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'htp_dashboard_screen.dart';

/// HTP 검사 그림 그리기 화면
/// 메모리 효율적이고 트렌디한 디자인의 그림판
class HtpDrawingScreen extends StatefulWidget {
  /// 그림 유형 (house, tree, person)
  final String drawingType;

  /// 그림 제목
  final String title;

  const HtpDrawingScreen({
    super.key,
    required this.drawingType,
    required this.title,
  });

  @override
  State<HtpDrawingScreen> createState() => _HtpDrawingScreenState();
}

class _HtpDrawingScreenState extends State<HtpDrawingScreen>
    with TickerProviderStateMixin {

  // 🎨 그림 그리기 컨트롤러
  late ScribbleNotifier _scribbleNotifier;

  // 🎨 애니메이션 컨트롤러 (메모리 효율적 관리)
  late AnimationController _toolbarAnimationController;
  late AnimationController _colorPaletteController;
  late AnimationController _brushToolController;
  late Animation<double> _toolbarAnimation;
  late Animation<double> _colorPaletteAnimation;
  late Animation<double> _brushToolAnimation;

  // 🎨 UI 상태 관리
  bool _isColorPaletteExpanded = false;
  bool _isBrushToolExpanded = false;
  bool _isDrawingMode = true;

  // 🎨 그림 설정
  double _strokeWidth = 3.0;
  Color _currentColor = const Color(0xFF2D3748);
  BrushType _currentBrushType = BrushType.pen;
  
  // 🎨 브러시 효과를 위한 불투명도 설정
  double _brushOpacity = 1.0;

  // 🎨 최근 사용한 색상 (최대 4개)
  List<Color> _recentColors = [
    const Color(0xFF2D3748),
    const Color(0xFFE53E3E),
    const Color(0xFF3182CE),
  ];

  // 🎨 트렌디한 기본 색상 팔레트 (2024-2025)
  final List<Color> _basicColorPalette = [
    const Color(0xFF2D3748), // 차콜 그레이
    const Color(0xFFE53E3E), // 비브란트 레드
    const Color(0xFF3182CE), // 오션 블루
    const Color(0xFF38A169), // 프레시 그린
    const Color(0xFFD69E2E), // 웜 오렌지
    const Color(0xFF805AD5), // 퍼플
    const Color(0xFFD53F8C), // 핫핑크
    const Color(0xFF319795), // 틸
    const Color(0xFF718096), // 쿨그레이
    const Color(0xFF1A202C), // 딥블랙
    const Color(0xFFED8936), // 선셋오렌지
    const Color(0xFF4299E1), // 스카이블루
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  /// 🧹 컨트롤러 초기화 (메모리 효율적)
  void _initializeControllers() {
    _scribbleNotifier = ScribbleNotifier();
    _toolbarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _colorPaletteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _brushToolController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  /// 🎨 애니메이션 설정
  void _setupAnimations() {
    _toolbarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _toolbarAnimationController,
      curve: Curves.elasticOut,
    ));

    _colorPaletteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _colorPaletteController,
      curve: Curves.easeInOutCubic,
    ));

    _brushToolAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _brushToolController,
      curve: Curves.easeInOutCubic,
    ));

    // 툴바 애니메이션을 지연 시작 (깜빡임 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _toolbarAnimationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // 🧹 메모리 누수 방지를 위한 리소스 정리
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

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(theme, isDarkMode),
      body: Stack(
        children: [
          _buildGradientBackground(isDarkMode),
          _buildDrawingInstruction(isDarkMode),
          _buildDrawingArea(isDarkMode),
          _buildModernToolbar(theme, isDarkMode),
          _buildColorPaletteOverlay(theme, isDarkMode),
          _buildBrushToolOverlay(theme, isDarkMode),
        ],
      ),
    );
  }

  /// 🎨 그라디언트 배경
  Widget _buildGradientBackground(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            const Color(0xFF0F172A),
            const Color(0xFF1E293B),
            const Color(0xFF334155),
          ]
              : [
            const Color(0xFFF8FAFC),
            const Color(0xFFE2E8F0),
            const Color(0xFFCBD5E1),
          ],
        ),
      ),
    );
  }

  /// 🎨 모던 앱바 구성
  PreferredSizeWidget _buildModernAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      title: Text(
        widget.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color(0xFF1E293B).withOpacity(0.9)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
              const Color(0xFF1E293B).withOpacity(0.95),
              const Color(0xFF334155).withOpacity(0.85),
            ]
                : [
              Colors.white.withOpacity(0.95),
              const Color(0xFFF1F5F9).withOpacity(0.85),
            ],
          ),
        ),
      ),
      actions: [
        _buildActionButton(
          icon: Icons.undo_rounded,
          onPressed: _canUndo ? _undo : null,
          isEnabled: _canUndo,
          isDarkMode: isDarkMode,
          tooltip: '실행 취소',
        ),
        _buildActionButton(
          icon: Icons.redo_rounded,
          onPressed: _canRedo ? _redo : null,
          isEnabled: _canRedo,
          isDarkMode: isDarkMode,
          tooltip: '다시 실행',
        ),
        _buildActionButton(
          icon: Icons.refresh_rounded,
          onPressed: _clearCanvas,
          isEnabled: true,
          isDarkMode: isDarkMode,
          color: const Color(0xFFE53E3E),
          tooltip: '지우기',
        ),
        _buildActionButton(
          icon: Icons.save_rounded,
          onPressed: _saveDrawing,
          isEnabled: true,
          isDarkMode: isDarkMode,
          color: const Color(0xFF38A169),
          tooltip: '저장',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// 🎨 액션 버튼
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
                color: isEnabled
                    ? (isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05))
                    : Colors.transparent,
                border: Border.all(
                  color: isEnabled
                      ? (color ?? (isDarkMode ? Colors.white24 : Colors.black12))
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isEnabled
                    ? (color ?? (isDarkMode ? Colors.white : Colors.black87))
                    : (isDarkMode ? Colors.white24 : Colors.black26),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 그림 그리기 영역
  Widget _buildDrawingArea(bool isDarkMode) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 110, 20, 160), // 단순하게 하단 마진만 늘려서 높이 조절
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
          child: Scribble(
            notifier: _scribbleNotifier,
            drawPen: true,
          ),
        ),
      ),
    );
  }

  /// 🎨 그림 지시사항 표시
  Widget _buildDrawingInstruction(bool isDarkMode) {
    String instruction = _getDrawingInstruction();

    return Positioned(
      top: 80, // 앞에서 확인된 위치 유지
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 400,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                const Color(0xFF1E293B).withOpacity(0.95),
                const Color(0xFF334155).withOpacity(0.9),
              ]
                  : [
                Colors.white.withOpacity(0.95),
                const Color(0xFFF8FAFC).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.15) 
                  : Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getDrawingIcon(),
                color: isDarkMode ? Colors.white70 : Colors.black54,
                size: 22,
              ),
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

  /// 🎨 그림 지시사항 텍스트
  String _getDrawingInstruction() {
    switch (widget.drawingType) {
      case 'house':
        return '집을 그려주세요';
      case 'tree':
        return '나무를 그려주세요';
      case 'person':
        return '사람을 그려주세요';
      default:
        return '자유롭게 그려주세요';
    }
  }

  /// 🎨 그림 아이콘
  IconData _getDrawingIcon() {
    switch (widget.drawingType) {
      case 'house':
        return Icons.home_rounded;
      case 'tree':
        return Icons.park_rounded;
      case 'person':
        return Icons.person_rounded;
      default:
        return Icons.brush_rounded;
    }
  }

  /// 🎨 모던 툴바 구성
  Widget _buildModernToolbar(ThemeData theme, bool isDarkMode) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _toolbarAnimation,
        builder: (context, child) {
          // 애니메이션 값 안전성 체크
          final animationValue = _toolbarAnimation.value.clamp(0.0, 1.0);
          
          return Transform.scale(
            scale: animationValue,
            child: Opacity(
              opacity: animationValue,
              child: _buildToolbarContent(theme, isDarkMode),
            ),
          );
        },
      ),
    );
  }

  /// 🎨 툴바 내용
  Widget _buildToolbarContent(ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // padding 더 줄임
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.95),
            const Color(0xFF334155).withOpacity(0.9),
          ]
              : [
            Colors.white.withOpacity(0.95),
            const Color(0xFFF8FAFC).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IntrinsicHeight( // 모든 자식 요소의 높이를 동일하게
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 브러시 도구 선택
            Expanded(
              flex: 1,
              child: _buildBrushToolButton(isDarkMode),
            ),
            
            const SizedBox(width: 8), // 고정 간격
            
            // 브러시 크기 조절
            Expanded(
              flex: 1,
              child: _buildStrokeWidthControl(isDarkMode),
            ),
            
            const SizedBox(width: 8), // 고정 간격
            
            // 색상 선택 (최근 색상 + 팔레트)
            Expanded(
              flex: 1,
              child: _buildColorSection(isDarkMode),
            ),
            
            const SizedBox(width: 8), // 고정 간격
            
            // 지우개 토글
            Expanded(
              flex: 1,
              child: _buildEraserToggle(theme, isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 브러시 도구 버튼
  Widget _buildBrushToolButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleBrushTool,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Icon(
              _currentBrushType.icon,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentBrushType.name,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white60 : Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 브러시 크기 컨트롤
  Widget _buildStrokeWidthControl(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.line_weight_rounded,
          size: 18, // 아이콘 크기 줄임
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        const SizedBox(height: 6), // 간격 줄임
        SizedBox(
          width: 60, // 슬라이더 폭 줄임
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3, // 트랙 높이 줄임
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), // 썸 크기 줄임
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12), // 오버레이 크기 줄임
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
                setState(() {
                  _strokeWidth = value;
                });
                _updateBrushSettings();
              },
            ),
          ),
        ),
        Text(
          '${_strokeWidth.round()}px',
          style: TextStyle(
            fontSize: 10, // 폰트 크기 줄임
            color: isDarkMode ? Colors.white60 : Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 🎨 색상 섹션 (최근 색상 + 팔레트)
  Widget _buildColorSection(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 최근 사용한 색상들 - Wrap으로 오버플로우 방지
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 100, // 최대 폭 제한
          ),
          child: Wrap(
            spacing: 4, // 수평 간격
            runSpacing: 4, // 수직 간격
            alignment: WrapAlignment.center,
            children: [
              // 최근 색상 최대 2개까지만 표시 (공간 절약)
              ..._recentColors.take(2).map((color) => _buildRecentColorItem(color, isDarkMode)),
              _buildColorPaletteButton(isDarkMode),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '색상',
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Colors.white60 : Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 🎨 최근 색상 아이템
  Widget _buildRecentColorItem(Color color, bool isDarkMode) {
    final isSelected = _currentColor == color;

    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 20, // 크기 줄임
        height: 20, // 크기 줄임
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white24 : Colors.black12),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 색상 팔레트 버튼
  Widget _buildColorPaletteButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleColorPalette,
      child: Container(
        width: 20, // 크기 맞춤
        height: 20, // 크기 맞춤
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode ? Colors.white24 : Colors.black12,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 12, // 아이콘 크기도 조정
        ),
      ),
    );
  }

  /// 🎨 지우개 토글
  Widget _buildEraserToggle(ThemeData theme, bool isDarkMode) {
    return GestureDetector(
      onTap: _toggleEraser,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: !_isDrawingMode
                  ? const Color(0xFFE53E3E) // 지우개 모드일 때 빨간색
                  : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
              shape: BoxShape.circle,
              border: Border.all(
                color: !_isDrawingMode
                    ? const Color(0xFFE53E3E)
                    : (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1)),
                width: 2,
              ),
            ),
            child: Icon(
              !_isDrawingMode ? Icons.cleaning_services_rounded : Icons.auto_fix_high_rounded, // 아이콘 변경
              color: !_isDrawingMode
                  ? Colors.white
                  : (isDarkMode ? Colors.white60 : Colors.black54),
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '지우개',
            style: TextStyle(
              fontSize: 11,
              color: !_isDrawingMode 
                  ? const Color(0xFFE53E3E) // 지우개 모드일 때 빨간색 텍스트
                  : (isDarkMode ? Colors.white60 : Colors.black45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 브러시 도구 오버레이
  Widget _buildBrushToolOverlay(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _brushToolAnimation,
      builder: (context, child) {
        if (!_isBrushToolExpanded && _brushToolAnimation.value == 0) {
          return const SizedBox.shrink();
        }
        
        // 애니메이션 값 안전성 체크
        final animationValue = _brushToolAnimation.value.clamp(0.0, 1.0);

        return Positioned.fill(
          child: GestureDetector(
            onTap: _closeBrushTool,
            child: Container(
              color: Colors.black.withOpacity(0.3 * animationValue),
              child: Center(
                child: Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: _buildBrushToolGrid(isDarkMode),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🎨 브러시 도구 그리드
  Widget _buildBrushToolGrid(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B),
            const Color(0xFF334155),
          ]
              : [
            Colors.white,
            const Color(0xFFF8FAFC),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '브러시 도구',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: BrushType.values.length,
            itemBuilder: (context, index) {
              final brushType = BrushType.values[index];
              final isSelected = _currentBrushType == brushType;

              return GestureDetector(
                onTap: () => _selectBrushType(brushType),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3182CE)
                        : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3182CE)
                          : (isDarkMode ? Colors.white24 : Colors.black12),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: const Color(0xFF3182CE).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        brushType.icon,
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode ? Colors.white70 : Colors.black54),
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brushType.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDarkMode ? Colors.white70 : Colors.black54),
                        ),
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

  /// 🎨 색상 팔레트 오버레이
  Widget _buildColorPaletteOverlay(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _colorPaletteAnimation,
      builder: (context, child) {
        if (!_isColorPaletteExpanded && _colorPaletteAnimation.value == 0) {
          return const SizedBox.shrink();
        }
        
        // 애니메이션 값 안전성 체크
        final animationValue = _colorPaletteAnimation.value.clamp(0.0, 1.0);

        return Positioned.fill(
          child: GestureDetector(
            onTap: _closeColorPalette,
            child: Container(
              color: Colors.black.withOpacity(0.3 * animationValue),
              child: Center(
                child: Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: _buildColorPaletteGrid(isDarkMode),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🎨 색상 팔레트 그리드
  Widget _buildColorPaletteGrid(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B),
            const Color(0xFF334155),
          ]
              : [
            Colors.white,
            const Color(0xFFF8FAFC),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '색상 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // 커스텀 색상 선택 버튼
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: _showCustomColorPicker,
              icon: const Icon(Icons.colorize_rounded, size: 20),
              label: const Text(
                '사용자 정의 색상',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF805AD5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          // 기본 색상 팔레트
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
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
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : Border.all(
                      color: isDarkMode ? Colors.white24 : Colors.black12,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check_rounded,
                    color: _getContrastColor(color),
                    size: 24,
                  )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🎨 커스텀 색상 피커 표시
  void _showCustomColorPicker() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.palette_rounded,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              '색상 만들기',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: _CustomColorPicker(
            initialColor: _currentColor,
            onColorChanged: (Color color) {
              _selectColor(color);
            },
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

  /// 🎨 색상 대비 계산 (가독성을 위한 아이콘 색상)
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// 🎨 브러시 도구 토글
  void _toggleBrushTool() {
    setState(() {
      _isBrushToolExpanded = !_isBrushToolExpanded;
    });

    if (_isBrushToolExpanded) {
      _brushToolController.forward();
      // 색상 팔레트가 열려있다면 닫기
      if (_isColorPaletteExpanded) {
        _closeColorPalette();
      }
    } else {
      _brushToolController.reverse();
    }
  }

  /// 🎨 브러시 도구 닫기
  void _closeBrushTool() {
    setState(() {
      _isBrushToolExpanded = false;
    });
    _brushToolController.reverse();
  }

  /// 🎨 브러시 타입 선택
  void _selectBrushType(BrushType brushType) {
    setState(() {
      _currentBrushType = brushType;
    });

    _updateBrushSettings();
    _closeBrushTool();
  }

  /// 🎨 브러시 설정 업데이트 (타입에 따른 실제 효과 적용)
  void _updateBrushSettings() {
    double adjustedWidth = _strokeWidth;
    Color adjustedColor = _currentColor;
    
    // 브러시 타입에 따른 실제 효과 적용
    switch (_currentBrushType) {
      case BrushType.pen:
        // 펜: 선명하고 일정한 선
        adjustedWidth = _strokeWidth;
        adjustedColor = _currentColor;
        _brushOpacity = 1.0;
        break;
        
      case BrushType.brush:
        // 붓: 약간 두껍고 부드러운 느낌
        adjustedWidth = _strokeWidth * 1.3;
        adjustedColor = _currentColor.withOpacity(0.9);
        _brushOpacity = 0.9;
        break;
        
      case BrushType.marker:
        // 마커: 두껍고 반투명한 효과
        adjustedWidth = _strokeWidth * 1.8;
        adjustedColor = _currentColor.withOpacity(0.7);
        _brushOpacity = 0.7;
        break;
        
      case BrushType.pencil:
        // 연필: 얇고 약간 흐린 효과
        adjustedWidth = _strokeWidth * 0.6;
        adjustedColor = _currentColor.withOpacity(0.8);
        _brushOpacity = 0.8;
        break;
        
      case BrushType.spray:
        // 스프레이: 넓고 흐린 효과
        adjustedWidth = _strokeWidth * 2.5;
        adjustedColor = _currentColor.withOpacity(0.5);
        _brushOpacity = 0.5;
        break;
        
      case BrushType.crayon:
        // 크레용: 두껍고 거친 느낌
        adjustedWidth = _strokeWidth * 2.0;
        adjustedColor = _currentColor.withOpacity(0.85);
        _brushOpacity = 0.85;
        break;
    }

    _scribbleNotifier.setStrokeWidth(adjustedWidth);
    _scribbleNotifier.setColor(adjustedColor);
  }

  /// 🎨 색상 팔레트 토글
  void _toggleColorPalette() {
    setState(() {
      _isColorPaletteExpanded = !_isColorPaletteExpanded;
    });

    if (_isColorPaletteExpanded) {
      _colorPaletteController.forward();
      // 브러시 도구가 열려있다면 닫기
      if (_isBrushToolExpanded) {
        _closeBrushTool();
      }
    } else {
      _colorPaletteController.reverse();
    }
  }

  /// 🎨 색상 팔레트 닫기
  void _closeColorPalette() {
    setState(() {
      _isColorPaletteExpanded = false;
    });
    _colorPaletteController.reverse();
  }

  /// 🎨 색상 선택 및 최근 색상 업데이트
  void _selectColor(Color color) {
    setState(() {
      _currentColor = color;
      _isDrawingMode = true;

      // 최근 색상 업데이트
      _updateRecentColors(color);
    });

    // 브러시 설정에 따라 색상 적용
    _updateBrushSettings();
  }

  /// 🎨 최근 사용한 색상 업데이트 (중복 제거 및 순서 관리)
  void _updateRecentColors(Color color) {
    // 이미 있는 색상이면 제거
    _recentColors.removeWhere((c) => c.value == color.value);

    // 맨 앞에 추가
    _recentColors.insert(0, color);

    // 최대 4개까지만 유지
    if (_recentColors.length > 4) {
      _recentColors.removeLast();
    }
  }

  /// 🎨 지우개 토글
  void _toggleEraser() {
    setState(() {
      _isDrawingMode = !_isDrawingMode;
    });

    if (_isDrawingMode) {
      // 그리기 모드로 복귀 (브러시 설정에 맞게 복원)
      _updateBrushSettings();
    } else {
      // 진짜 지우개 모드: 흰색으로 그리기 (배경색과 동일)
      _scribbleNotifier.setColor(Colors.white); // 캔버스 배경색과 동일한 색으로 설정
      _scribbleNotifier.setStrokeWidth(_strokeWidth * 2.0); // 지우개는 브러시보다 두께게
    }
  }

  /// 🎨 실행 취소
  void _undo() {
    _scribbleNotifier.undo();
  }

  /// 🎨 다시 실행
  void _redo() {
    _scribbleNotifier.redo();
  }

  /// 🎨 캔버스 지우기 (확인 다이얼로그 포함)
  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange,
              size: 24,
            ),
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
              Navigator.pop(context);

              // 성공 메시지
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

  /// 🎨 그림 저장
  void _saveDrawing() {
    // 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 체크 아이콘
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF38A169),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            
            // 제목
            const Text(
              '저장되었습니다!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            
            // 설명
            const Text(
              '*완료시에도 수정가능합니다',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            
            // 버튼들
            Row(
              children: [
                // 계속 그리기 버튼
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그만 닫기
                    },
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
                
                // 완료하기 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pop(context, true); // 그리기 화면 닫고 완료 상태로 돌아가기
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

  /// 🎨 실행 취소 가능 여부
  bool get _canUndo => _scribbleNotifier.canUndo;

  /// 🎨 다시 실행 가능 여부
  bool get _canRedo => _scribbleNotifier.canRedo;
}

// 🎨 브러시 타입 열거형
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

// 🎨 HTP 그림 유형 열거형
enum HtpDrawingType {
  house('집'),
  tree('나무'),
  person('사람');

  const HtpDrawingType(this.displayName);

  final String displayName;
}

// 🎨 커스텀 색상 피커 위젯 (메모리 효율적)
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

  Color get _currentColor => Color.fromARGB(255, _red.round(), _green.round(), _blue.round());

  void _updateColor() {
    widget.onColorChanged(_currentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 선택된 색상 미리보기
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: _currentColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'RGB(${_red.round()}, ${_green.round()}, ${_blue.round()})',
              style: TextStyle(
                color: _getContrastColor(_currentColor),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // RGB 슬라이더들
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

  /// 색상 슬라이더 빌더
  Widget _buildColorSlider(
      String label,
      double value,
      Color sliderColor,
      ValueChanged<double> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
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
              child: Slider(
                value: value,
                min: 0,
                max: 255,
                divisions: 255,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              value.round().toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// 색상 대비 계산
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// 🎨 사용 예시 - HTP 대시보드 사용
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
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'House-Tree-Person 검사',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '심리검사를 시작해보세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 40),
              
              // HTP 대시보드로 이동하는 버튼
              Container(
                width: 250,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HtpDashboardScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.psychology_rounded, size: 24),
                  label: const Text(
                    'HTP 검사 시작',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3182CE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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