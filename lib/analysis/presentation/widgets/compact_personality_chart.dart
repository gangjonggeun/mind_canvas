import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 간결한 성격 차트 위젯
/// 이미지 스타일처럼 깔끔한 막대 그래프
class CompactPersonalityChart extends StatefulWidget {
  final List<PersonalityDimension> dimensions;

  const CompactPersonalityChart({
    super.key,
    required this.dimensions,
  });

  @override
  State<CompactPersonalityChart> createState() => _CompactPersonalityChartState();
}

class _CompactPersonalityChartState extends State<CompactPersonalityChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animations = List.generate(widget.dimensions.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 상위 5개 차원만 표시
    final topDimensions = widget.dimensions.take(5).toList();
    
    return Column(
      children: topDimensions.asMap().entries.map((entry) {
        final index = entry.key;
        final dimension = entry.value;
        
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: _buildDimensionBar(dimension, _animations[index].value),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDimensionBar(PersonalityDimension dimension, double animationValue) {
    final color = Color(int.parse(dimension.color, radix: 16));
    
    return Column(
      children: [
        // 상단: 이름과 점수
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  dimension.icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  dimension.shortName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${dimension.score.toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getScoreLevel(dimension.score),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 프로그레스 바 (이미지 스타일)
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // 배경
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              // 진행 바
              FractionallySizedBox(
                widthFactor: (dimension.score / 100) * animationValue,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 점수 위치 마커
              Positioned(
                left: (MediaQuery.of(context).size.width - 80) * 
                      (dimension.score / 100) * animationValue - 4,
                top: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getScoreLevel(double score) {
    if (score >= 80) return '높음';
    if (score >= 60) return '보통';
    if (score >= 40) return '보통';
    if (score >= 20) return '낮음';
    return '낮음';
  }
}
