import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 성격 차원 분석 위젯 (스트레스, 안정감, 열정, 사교성, 이성 등)
/// 프로그레스 바와 레이더 차트 형태로 시각화
class PersonalityDimensionsWidget extends StatefulWidget {
  final List<PersonalityDimension> dimensions;

  const PersonalityDimensionsWidget({
    super.key,
    required this.dimensions,
  });

  @override
  State<PersonalityDimensionsWidget> createState() => _PersonalityDimensionsWidgetState();
}

class _PersonalityDimensionsWidgetState extends State<PersonalityDimensionsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 각 차원별로 약간씩 다른 타이밍으로 애니메이션
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
    return Column(
      children: [
        // 각 성격 차원 리스트
        ...widget.dimensions.asMap().entries.map((entry) {
          final index = entry.key;
          final dimension = entry.value;
          
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: _buildDimensionItem(dimension, _animations[index].value),
              );
            },
          );
        }).toList(),
        
        const SizedBox(height: 16),
        
        // 종합 분석 요약
        _buildSummaryCard(),
      ],
    );
  }

  /// 개별 성격 차원 아이템
  Widget _buildDimensionItem(PersonalityDimension dimension, double animationValue) {
    final scoreLevel = _getScoreLevel(dimension.score);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(int.parse(dimension.color, radix: 16)).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(int.parse(dimension.color, radix: 16)).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (아이콘, 이름, 점수)
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(int.parse(dimension.color, radix: 16)).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    dimension.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dimension.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${dimension.score.toInt()}점',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(int.parse(dimension.color, radix: 16)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getScoreLevelColor(scoreLevel).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            scoreLevel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getScoreLevelColor(scoreLevel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 프로그레스 바
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (dimension.score / 100) * animationValue,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(dimension.color, radix: 16)),
                      Color(int.parse(dimension.color, radix: 16)).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Color(int.parse(dimension.color, radix: 16)).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 설명
          Text(
            dimension.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 종합 분석 요약 카드
  Widget _buildSummaryCard() {
    final strongestDimension = widget.dimensions.reduce(
      (a, b) => a.score > b.score ? a : b,
    );
    
    final averageScore = widget.dimensions
        .map((d) => d.score)
        .reduce((a, b) => a + b) / widget.dimensions.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'AI 분석 요약',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '당신의 가장 강한 특성은 "${strongestDimension.shortName}"이며, '
            '전체 평균 점수는 ${averageScore.toInt()}점입니다. '
            '${_getPersonalityInsight(strongestDimension, averageScore)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 점수 레벨 반환
  String _getScoreLevel(double score) {
    if (score >= 80) return '매우 높음';
    if (score >= 60) return '높음';
    if (score >= 40) return '보통';
    if (score >= 20) return '낮음';
    return '매우 낮음';
  }

  /// 점수 레벨 색상
  Color _getScoreLevelColor(String level) {
    switch (level) {
      case '매우 높음':
        return const Color(0xFF10B981);
      case '높음':
        return const Color(0xFF3B82F6);
      case '보통':
        return const Color(0xFF6366F1);
      case '낮음':
        return const Color(0xFFF59E0B);
      case '매우 낮음':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  /// 성격 통찰 메시지
  String _getPersonalityInsight(PersonalityDimension strongest, double average) {
    if (strongest.shortName == '창의성') {
      return '창의적 사고가 뛰어나 새로운 아이디어를 잘 생각해내는 편이에요.';
    } else if (strongest.shortName == '열정') {
      return '에너지가 넘치고 새로운 도전을 즐기는 적극적인 성향이에요.';
    } else if (strongest.shortName == '안정감') {
      return '감정이 안정적이고 스트레스 상황에서도 차분함을 유지해요.';
    } else if (strongest.shortName == '사교성') {
      return '사람들과의 관계를 즐기고 소통 능력이 뛰어나요.';
    } else if (strongest.shortName == '이성') {
      return '논리적 사고력이 뛰어나고 객관적인 판단을 잘해요.';
    } else {
      return '균형 잡힌 성격으로 다양한 상황에 잘 적응하는 편이에요.';
    }
  }
}
