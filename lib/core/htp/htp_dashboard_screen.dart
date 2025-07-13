// lib/features/htp/presentation/screens/htp_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'htp_drawing_screen.dart';

/// HTP 검사 중간단계 대시보드 화면
/// 3개 그림(집, 나무, 사람)의 진행상태를 관리하고 표시
class HtpDashboardScreen extends StatefulWidget {
  const HtpDashboardScreen({super.key});

  @override
  State<HtpDashboardScreen> createState() => _HtpDashboardScreenState();
}

class _HtpDashboardScreenState extends State<HtpDashboardScreen>
    with TickerProviderStateMixin {

  // 🎨 3개 그림의 진행 상태
  final Map<String, HtpDrawingStatus> _drawingStatus = {
    'house': HtpDrawingStatus.notStarted,
    'tree': HtpDrawingStatus.notStarted,
    'person': HtpDrawingStatus.notStarted,
  };

  // 🎨 애니메이션 컨트롤러 (카드 애니메이션용)
  late AnimationController _cardAnimationController;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    final completedCount = _drawingStatus.values
        .where((status) => status == HtpDrawingStatus.completed)
        .length;

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
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
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
      {'type': 'house', 'title': '집 그리기', 'icon': Icons.home_rounded, 'color': const Color(0xFF3182CE)},
      {'type': 'tree', 'title': '나무 그리기', 'icon': Icons.park_rounded, 'color': const Color(0xFF38A169)},
      {'type': 'person', 'title': '사람 그리기', 'icon': Icons.person_rounded, 'color': const Color(0xFF805AD5)},
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
  Widget _buildDrawingCard(
    String type,
    String title,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    final status = _drawingStatus[type]!;
    
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
              : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
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
                      color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
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
                  icon: status == HtpDrawingStatus.notStarted ? Icons.play_arrow_rounded : Icons.edit_rounded,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                elevation: 2,
              ),
            ),
    );
  }

  /// 🎨 제출 버튼
  Widget _buildSubmitButton(bool isDarkMode) {
    final completedCount = _drawingStatus.values
        .where((status) => status == HtpDrawingStatus.completed)
        .length;
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

  /// 🎨 그리기 화면으로 이동
  void _navigateToDrawing(String type, String title) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtpDrawingScreen(
          drawingType: type,
          title: 'HTP - $title',
        ),
      ),
    );

    // 그리기 완료 후 돌아왔을 때 상태 업데이트
    if (result == true) {
      setState(() {
        _drawingStatus[type] = HtpDrawingStatus.completed;
      });
    } else if (result == 'saved') {
      setState(() {
        _drawingStatus[type] = HtpDrawingStatus.inProgress;
      });
    }
  }

  /// 🎨 미리보기 표시
  void _showPreview(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_getDrawingTitle(type)} 미리보기'),
        content: const SizedBox(
          width: 300,
          height: 300,
          child: Center(
            child: Text(
              '미리보기 기능\n(실제 그림 썸네일)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF718096)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  /// 🎨 그림 제목 가져오기
  String _getDrawingTitle(String type) {
    switch (type) {
      case 'house': return '집';
      case 'tree': return '나무';
      case 'person': return '사람';
      default: return '그림';
    }
  }

  /// 🎨 검사 제출
  void _submitDrawings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            onPressed: () {
              Navigator.pop(context);
              _performSubmit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38A169),
              foregroundColor: Colors.white,
            ),
            child: const Text('제출하기'),
          ),
        ],
      ),
    );
  }

  /// 🎨 실제 제출 처리
  void _performSubmit() {
    // TODO: 서버에 그림들 업로드 및 검사 제출
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('HTP 검사가 성공적으로 제출되었습니다!'),
          ],
        ),
        backgroundColor: const Color(0xFF38A169),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // 검사 완료 후 이전 화면으로 돌아가기
    Navigator.pop(context);
  }
}

/// HTP 그림 상태 열거형
enum HtpDrawingStatus {
  notStarted,   // 시작 안함
  inProgress,   // 작업중
  completed,    // 완료
}
