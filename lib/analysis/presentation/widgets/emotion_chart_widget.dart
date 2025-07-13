import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/entities/analysis_data.dart';

/// 감정 상태 원형 차트 위젯
/// 도넛 차트 형태로 감정 분포를 시각화
class EmotionChartWidget extends StatefulWidget {
  final List<EmotionState> emotionStates;

  const EmotionChartWidget({
    super.key,
    required this.emotionStates,
  });

  @override
  State<EmotionChartWidget> createState() => _EmotionChartWidgetState();
}

class _EmotionChartWidgetState extends State<EmotionChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 도넛 차트
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                children: [
                  // 차트 배경
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: EmotionChartPainter(
                      emotionStates: widget.emotionStates,
                      animationValue: _animation.value,
                      selectedIndex: _selectedIndex,
                    ),
                  ),
                  
                  // 중앙 정보
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedIndex != null 
                                ? widget.emotionStates[_selectedIndex!].emoji
                                : '😊',
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedIndex != null 
                                ? '${widget.emotionStates[_selectedIndex!].percentage.toInt()}%'
                                : '감정 분석',
                            style: TextStyle(
                              fontSize: _selectedIndex != null ? 16 : 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          if (_selectedIndex != null)
                            Text(
                              widget.emotionStates[_selectedIndex!].name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // 감정 리스트
        ...widget.emotionStates.asMap().entries.map((entry) {
          final index = entry.key;
          final emotion = entry.value;
          final isSelected = _selectedIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = _selectedIndex == index ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Color(int.parse(emotion.color, radix: 16)).withOpacity(0.1)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Color(int.parse(emotion.color, radix: 16)).withOpacity(0.3)
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // 이모지와 색상 인디케이터
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(int.parse(emotion.color, radix: 16)).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        emotion.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // 감정명과 퍼센티지
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emotion.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: (emotion.percentage / 100) * _animation.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(emotion.color, radix: 16)),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${emotion.percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(int.parse(emotion.color, radix: 16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

/// 감정 차트 페인터
class EmotionChartPainter extends CustomPainter {
  final List<EmotionState> emotionStates;
  final double animationValue;
  final int? selectedIndex;

  EmotionChartPainter({
    required this.emotionStates,
    required this.animationValue,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 25.0;

    double startAngle = -math.pi / 2; // 12시 방향부터 시작

    for (int i = 0; i < emotionStates.length; i++) {
      final emotion = emotionStates[i];
      final sweepAngle = (emotion.percentage / 100) * 2 * math.pi * animationValue;
      final isSelected = selectedIndex == i;

      final paint = Paint()
        ..color = Color(int.parse(emotion.color, radix: 16))
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.round;

      // 선택된 섹션은 약간 바깥으로
      final currentRadius = isSelected ? radius + 3 : radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
