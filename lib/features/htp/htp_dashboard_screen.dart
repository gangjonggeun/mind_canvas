// lib/features/htp/presentation/screens/htp_dashboard_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/htp/presentation/notifier/htp_analysis_notifier.dart';
import 'package:mind_canvas/features/htp/presentation/providers/htp_session_provider.dart';

import '../psy_result/domain/entities/psy_result.dart';
import '../psy_result/presentation/psy_result_screen.dart';
import 'data/model/request/htp_basic_request.dart';
import 'data/model/response/htp_response.dart';
import 'domain/entities/htp_session_entity.dart';
import 'htp_drawing_screen.dart';

/// HTP 검사 중간단계 대시보드 화면
/// 3개 그림(집, 나무, 사람)의 진행상태를 관리하고 표시
///
///
class HtpDashboardScreen extends ConsumerStatefulWidget {
  const HtpDashboardScreen({super.key});

  @override
  ConsumerState<HtpDashboardScreen> createState() => _HtpDashboardScreenState();
}

class _HtpDashboardScreenState extends ConsumerState<HtpDashboardScreen>
    with TickerProviderStateMixin {


  // 🎨 애니메이션 컨트롤러 (카드 애니메이션용)
  late AnimationController _cardAnimationController;
  late Animation<double> _cardAnimation;



  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // ✅ Provider에서 세션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(htpSessionProvider);
      if (session == null) {
        ref.read(htpSessionProvider.notifier).startNewSession('user_123');
      }
    });
  }

  /// 🎨 애니메이션 설정
  void _setupAnimations() {
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // 화면 진입시 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _cardAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // ✅ Provider에서 상태 가져오기
    final session = ref.watch(htpSessionProvider);
    final completedCount = ref.watch(htpCompletedCountProvider);
    final canComplete = ref.watch(htpCanCompleteProvider);

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(theme, isDarkMode),
      body: _buildBody(isDarkMode),
    );
  }

  /// 🎨 앱바 구성
  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      title: Text(
        'HTP 심리검사',
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
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black
                  .withOpacity(0.1),
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
    );
  }

  /// 🎨 메인 바디
  Widget _buildBody(bool isDarkMode) {
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(isDarkMode),
              const SizedBox(height: 30),
              _buildProgressIndicator(isDarkMode),
              const SizedBox(height: 30),
              Expanded(child: _buildDrawingCards(isDarkMode)),
              _buildSubmitButton(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 헤더 섹션
  Widget _buildHeader(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'House-Tree-Person 검사',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
            letterSpacing: -0.8,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '각 그림을 원하는 순서대로 그려주세요\n완료 후에도 언제든 수정할 수 있습니다',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 🎨 진행률 표시기
  Widget _buildProgressIndicator(bool isDarkMode) {
    // ✅ Provider에서 실시간 상태 가져오기
    final session = ref.watch(htpSessionProvider);
    final completedCount = session?.drawings.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF334155).withOpacity(0.6),
          ]
              : [
            Colors.white.withOpacity(0.9),
            const Color(0xFFF8FAFC).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black
              .withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행 상황',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              Text(
                '$completedCount / 3',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: completedCount == 3
                      ? const Color(0xFF38A169)
                      : (isDarkMode ? Colors.white70 : const Color(0xFF718096)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completedCount / 3,
            backgroundColor: isDarkMode ? Colors.white24 : Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(
              completedCount == 3
                  ? const Color(0xFF38A169)
                  : const Color(0xFF3182CE),
            ),
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  /// 🎨 그리기 카드들
  Widget _buildDrawingCards(bool isDarkMode) {
    final drawingTypes = [
      {
        'type': 'house',
        'title': '집 그리기',
        'icon': Icons.home_rounded,
        'color': const Color(0xFF3182CE)
      },
      {
        'type': 'tree',
        'title': '나무 그리기',
        'icon': Icons.park_rounded,
        'color': const Color(0xFF38A169)
      },
      {
        'type': 'person',
        'title': '사람 그리기',
        'icon': Icons.person_rounded,
        'color': const Color(0xFF805AD5)
      },
    ];

    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: drawingTypes.length,
          itemBuilder: (context, index) {
            final drawing = drawingTypes[index];
            final delay = index * 0.2;
            final cardAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: _cardAnimationController,
              curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
            ));

            return Transform.translate(
              offset: Offset(0, 50 * (1 - cardAnimation.value)),
              child: Opacity(
                opacity: cardAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildDrawingCard(
                    drawing['type'] as String,
                    drawing['title'] as String,
                    drawing['icon'] as IconData,
                    drawing['color'] as Color,
                    isDarkMode,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 🎨 개별 그리기 카드
  Widget _buildDrawingCard(String type,
      String title,
      IconData icon,
      Color color,
      bool isDarkMode,) {
    // ✅ Provider에서 해당 타입의 그림 가져오기
    final htpType = _getHtpType(type);
    final drawing = ref.watch(htpSessionProvider.notifier).getDrawing(htpType);
    final status = drawing != null
        ? HtpDrawingStatus.completed
        : HtpDrawingStatus.notStarted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF334155).withOpacity(0.6),
          ]
              : [
            Colors.white.withOpacity(0.9),
            const Color(0xFFF8FAFC).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == HtpDrawingStatus.completed
              ? const Color(0xFF38A169).withOpacity(0.3)
              : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black
              .withOpacity(0.1)),
          width: status == HtpDrawingStatus.completed ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 아이콘 및 상태
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),

            // 제목 및 상태 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : const Color(
                          0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(status, isDarkMode),
                ],
              ),
            ),

            // 액션 버튼들
            Column(
              children: [
                _buildActionButton(
                  text: status == HtpDrawingStatus.notStarted ? '시작하기' : '수정하기',
                  icon: status == HtpDrawingStatus.notStarted ? Icons
                      .play_arrow_rounded : Icons.edit_rounded,
                  color: color,
                  onPressed: () => _navigateToDrawing(type, title),
                ),
                if (status == HtpDrawingStatus.completed) ...[
                  const SizedBox(height: 8),
                  _buildActionButton(
                    text: '미리보기',
                    icon: Icons.visibility_rounded,
                    color: const Color(0xFF718096),
                    onPressed: () => _showPreview(type),
                    isSecondary: true,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  HtpType _getHtpType(String typeString) {
    switch (typeString) {
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


  /// 🎨 상태 칩
  Widget _buildStatusChip(HtpDrawingStatus status, bool isDarkMode) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case HtpDrawingStatus.notStarted:
        text = '시작 안함';
        color = isDarkMode ? Colors.white60 : const Color(0xFF718096);
        icon = Icons.radio_button_unchecked;
        break;
      case HtpDrawingStatus.inProgress:
        text = '작업중';
        color = const Color(0xFFD69E2E);
        icon = Icons.edit_rounded;
        break;
      case HtpDrawingStatus.completed:
        text = '완료';
        color = const Color(0xFF38A169);
        icon = Icons.check_circle_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 액션 버튼
  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: 100,
      height: 36,
      child: isSecondary
          ? OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5), width: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      )
          : ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 2,
        ),
      ),
    );
  }

  /// 🎨 제출 버튼
  Widget _buildSubmitButton(bool isDarkMode) {
    // ✅ Provider에서 실시간 상태 가져오기
    final session = ref.watch(htpSessionProvider);
    final completedCount = session?.drawings.length ?? 0;
    final canSubmit = completedCount == 3;

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton.icon(
        onPressed: canSubmit ? _submitDrawings : null,
        icon: Icon(
          canSubmit ? Icons.send_rounded : Icons.lock_rounded,
          size: 20,
        ),
        label: Text(
          canSubmit ? 'HTP 검사 제출하기' : '모든 그림을 완료해주세요 ($completedCount/3)',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: canSubmit
              ? const Color(0xFF38A169)
              : (isDarkMode ? Colors.white24 : Colors.black12),
          foregroundColor: canSubmit
              ? Colors.white
              : (isDarkMode ? Colors.white38 : Colors.black38),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: canSubmit ? 4 : 0,
        ),
      ),
    );
  }

  void _navigateToDrawing(String type, String title) async {
    // ✅ 기존 그림 데이터 가져오기
    final htpType = _getHtpType(type);
    final drawing = ref.read(htpSessionProvider.notifier).getDrawing(htpType);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreen(
          drawingType: type,
          title: 'HTP - $title',
          existingSketchJson: drawing?.sketchJson, // ✅ Sketch JSON 전달
        ),
      ),
    );
  }

// 📍 _showPreview 메서드 수정 (실제 이미지 표시)
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
      builder: (context) =>
          Dialog(
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
                    color: Theme
                        .of(context)
                        .primaryColor
                        .withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getDrawingIconByType(type),
                        color: Theme
                            .of(context)
                            .primaryColor,
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
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.6,
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
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
                      _buildInfoRow(
                        '소요 시간',
                        '${drawing.durationSeconds}초',
                        Icons.timer_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        '행동 횟수',
                        '${drawing.strokeCount}회',
                        Icons.gesture_rounded,
                      ),
                      if (drawing.modificationCount > 0) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          '수정 횟수',
                          '${drawing.modificationCount}회',
                          Icons.edit_rounded,
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


// 📍 정보 행 위젯 헬퍼
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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


// 📍 성공 다이얼로그 (메서드 분리)
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                  '제출 완료!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'HTP 심리검사가 성공적으로 제출되었습니다.\n결과는 마이페이지에서 확인하실 수 있습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pop(context); // 대시보드 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38A169),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

// 📍 에러 다이얼로그 (메서드 분리)
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('제출 실패'),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  /// 🎨 실제 제출 처리 (Notifier 사용)
  Future<void> _performSubmit() async {
    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    '검사 결과를 전송중입니다...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      final session = ref.read(htpSessionProvider)!;

      // 1. 이미지 파일 수집
      final imageFiles = <File>[];
      final imagePaths = <String, String>{};

      for (final type in [HtpType.house, HtpType.tree, HtpType.person]) {
        final drawing = session.drawings.firstWhere((d) => d.type == type);
        if (drawing.imagePath == null) {
          throw Exception('${type.name} 이미지를 찾을 수 없습니다');
        }
        imageFiles.add(File(drawing.imagePath!));
        imagePaths[type.name] = drawing.imagePath!;
      }

      print('📤 서버 전송 시작 - 이미지 ${imageFiles.length}개');

      // 2. DrawingProcess 생성
      final drawingProcess = DrawingProcess(
        drawOrder: _getDrawOrder(session.drawings),
        timeTaken: _getTotalTime(session),
        pressure: _getAveragePressure(session.drawings),
      );

      // 3. ✅ Notifier를 통한 분석 실행 (결과 직접 받기)
      print('🔄 분석 시작...');
      final result = await ref.read(htpAnalysisProvider.notifier).analyzeBasic(
        imageFiles: imageFiles,
        drawingProcess: drawingProcess,
      );
      print('✅ 분석 완료! result: ${result != null ? "존재함" : "null"}');

      // 로딩 다이얼로그 닫기
      if (!mounted) {
        print('⚠️ Widget dispose됨');
        return;
      }
      Navigator.pop(context);
      print('✅ 로딩 다이얼로그 닫힘');

      // 4. ✅ 결과 처리 (상태 확인 없이 직접 result 사용!)
      if (result != null) {
        print('✅ 서버 전송 성공!');
        print('📄 resultTag: ${result.resultTag}');
        print('📝 resultDetails: ${result.resultDetails.length}개');

        // ✅ HtpResponse → PsyResult 변환
        print('🔄 PsyResult 변환 시작...');
        final psyResult = _convertHtpResponseToPsyResult(result);
        print('✅ PsyResult 변환 완료');
        print('📌 psyResult.title: ${psyResult.title}');
        print('📌 psyResult.sections: ${psyResult.sections.length}개');

        // 세션 완료 처리
        await ref.read(htpSessionProvider.notifier).completeSession();
        await ref.read(htpSessionProvider.notifier).clearSession();
        print('✅ 세션 정리 완료');

        if (!mounted) {
          print('⚠️ Widget dispose됨 - Navigator 호출 불가');
          return;
        }

        // ✅ 결과 화면으로 이동
        print('🚀 결과 화면으로 이동 시작...');
        print('📍 localImagePaths: ${imagePaths.keys.toList()}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              print('🏗️ PsyResultScreen 빌드 중...');
              return PsyResultScreen(
                result: psyResult,
                localImagePaths: imagePaths,
              );
            },
          ),
        ).then((_) {
          print('✅ 결과 화면 이동 완료');
        }).catchError((error) {
          print('❌ Navigator 오류: $error');
        });
      } else {
        print('❌ 결과가 null입니다');
        if (mounted) {
          _showErrorDialog('분석 결과를 받지 못했습니다');
        }
      }
    } catch (e, stackTrace) {
      print('❌ 제출 중 예외 발생: $e');
      print('📚 StackTrace: $stackTrace');

      // 로딩 다이얼로그가 열려있으면 닫기
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (!mounted) return;

      _showErrorDialog('예상치 못한 오류가 발생했습니다:\n${e.toString()}');
    }
  }

  /// 🔄 HtpResponse를 PsyResult로 변환
  PsyResult _convertHtpResponseToPsyResult(HtpResponse htpResponse) {
    return PsyResult(
      // ✅ 필수 필드
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: htpResponse.resultTag,
      subtitle: htpResponse.briefDescription, // ✅ briefDescription 사용 (빈 문자열 X)
      description: '', // ✅ 사용 안 함
      backgroundColor: 'E8EAFF',

      // ✅ 섹션 변환
      sections: htpResponse.resultDetails.map((detail) {
        return PsyResultSection(
          title: detail.title,
          content: detail.content,
          imageUrl: detail.imageUrl,
          highlights: [],
        );
      }).toList(),

      type: PsyResultType.other,
      createdAt: DateTime.now(),
      tags: ['HTP 검사', '심리 분석', '투사 검사'],

      imageUrl: null,
      dimensionScores: null,
      subjectiveAnswer: null,
      totalScore: null,
    );
  }

  /// 🎨 섹션 제목에 따른 이모지 선택
  String _getSectionEmoji(String title) {
    if (title.contains('총평') || title.contains('통찰')) {
      return '💡';
    } else if (title.contains('갈등') || title.contains('고충')) {
      return '😔';
    } else if (title.contains('집')) {
      return '🏠';
    } else if (title.contains('나무')) {
      return '🌳';
    } else if (title.contains('사람')) {
      return '👤';
    } else if (title.contains('조언')) {
      return '💪';
    } else if (title.contains('격려') || title.contains('응원')) {
      return '✨';
    } else {
      return '📝';
    }
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

  String _getAveragePressure(List<HtpDrawingEntity> drawings) {
    if (drawings.isEmpty) return 'medium';

    final avgPressure = drawings
        .map((d) => d.averagePressure)
        .reduce((a, b) => a + b) / drawings.length;

    if (avgPressure < 0.3) return 'light';
    if (avgPressure < 0.7) return 'medium';
    return 'heavy';
  }


}



/// HTP 그림 상태 열거형
enum HtpDrawingStatus {
  /// 시작 안함
  notStarted,

  /// 작업중
  inProgress,

  /// 완료
  completed,
}