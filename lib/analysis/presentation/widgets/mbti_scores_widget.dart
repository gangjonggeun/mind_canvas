import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// MBTI 4차원 점수 시각화 위젯
/// 슬라이더 바 형태로 각 차원의 성향을 표시
class MbtiScoresWidget extends StatefulWidget {
  final List<MbtiScore> mbtiScores;
  final String? mbtiType;

  const MbtiScoresWidget({
    super.key,
    required this.mbtiScores,
    this.mbtiType,
  });

  @override
  State<MbtiScoresWidget> createState() => _MbtiScoresWidgetState();
}

class _MbtiScoresWidgetState extends State<MbtiScoresWidget>
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

    _animations = List.generate(widget.mbtiScores.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
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
        // MBTI 타입 결과 헤더
        if (widget.mbtiType != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                '당신의 MBTI 유형',
                style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.mbtiType!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                _getMbtiDescription(widget.mbtiType!),
                style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
                ),
                textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 24),
        
        // 4차원 점수 시각화
        ...widget.mbtiScores.asMap().entries.map((entry) {
          final index = entry.key;
          final score = entry.value;
          
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: _buildScoreSlider(score, _animations[index].value),
              );
            },
          );
        }).toList(),
        
        // 성향 해석 카드
        _buildInterpretationCard(),
      ],
    );
  }

  /// MBTI 점수 슬라이더
  Widget _buildScoreSlider(MbtiScore score, double animationValue) {
    final isLeftDominant = score.score < 0;
    final percentage = score.percentage;
    final intensity = score.intensity;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          // 차원 제목과 현재 성향
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${score.leftType} / ${score.rightType}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getIntensityColor(intensity).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.currentType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _getIntensityColor(intensity),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      intensity,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getIntensityColor(intensity),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 양방향 슬라이더
          SizedBox(
            height: 60,
            child: Stack(
              children: [
                // 배경 트랙
                Positioned(
                  left: 0,
                  right: 0,
                  top: 20,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                
                // 왼쪽 타입 라벨
                Positioned(
                  left: 0,
                  top: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isLeftDominant 
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            score.leftType,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isLeftDominant ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 오른쪽 타입 라벨
                Positioned(
                  right: 0,
                  top: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: !isLeftDominant 
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            score.rightType,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: !isLeftDominant ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 점수 인디케이터
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: _calculateIndicatorPosition(score.score, animationValue),
                  top: 15,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${percentage.toInt()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 설명
          Text(
            score.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 인디케이터 위치 계산
  double _calculateIndicatorPosition(double score, double animationValue) {
    // score: -100 ~ 100
    // 화면 너비에서 양쪽 여백 40px씩 제외
    const double totalWidth = 320; // 대략적인 컨테이너 너비
    const double margin = 40;
    const double usableWidth = totalWidth - (margin * 2);
    
    // 중앙(0)에서 시작해서 점수에 따라 좌우로 이동
    final double normalizedScore = (score / 100) * animationValue; // -1 ~ 1
    final double centerPosition = usableWidth / 2;
    final double offset = normalizedScore * (usableWidth / 2);
    
    return margin + centerPosition + offset - 15; // 인디케이터 크기의 절반
  }

  /// 강도별 색상
  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case '강함':
        return const Color(0xFF10B981);
      case '보통':
        return const Color(0xFF3B82F6);
      case '약함':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF64748B);
    }
  }

  /// MBTI 타입별 설명
  String _getMbtiDescription(String type) {
    const descriptions = {
      'INFP': '열정적이고 상상력이 풍부한 몽상가, 언제나 새로운 가능성을 모색합니다.',
      'INFJ': '선의의 옹호자, 이상주의적이지만 실천력도 갖춘 완벽주의자입니다.',
      'ENFP': '자유로운 영혼의 활동가, 상상력이 풍부하고 사교적입니다.',
      'ENFJ': '카리스마 넘치는 지도자, 듣는 이들을 감화시키고 의욕을 불어넣습니다.',
      'INTJ': '용의주도한 전략가, 혼자서도 목표를 달성해내는 추진력을 지닙니다.',
      'INTP': '논리적인 사색가, 지식에 대한 끝없는 갈증을 가진 혁신가입니다.',
      'ENTJ': '대담한 통솔자, 목표 달성을 위해서라면 어떤 장애물도 넘어섭니다.',
      'ENTP': '뜨거운 논쟁을 즐기는 변론가, 새로운 아이디어에 불타는 열정을 지닙니다.',
    };
    
    return descriptions[type] ?? '독특하고 매력적인 성격의 소유자입니다.';
  }

  /// 성향 해석 카드
  Widget _buildInterpretationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF667EEA).withOpacity(0.2),
        ),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '성향 해석',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '당신의 MBTI 분석 결과, 각 차원에서 균형잡힌 성향을 보이고 있어요. '
            '이는 다양한 상황에 유연하게 적응할 수 있는 능력을 의미합니다. '
            '특히 강하게 나타난 성향들을 잘 활용한다면 더욱 만족스러운 삶을 살 수 있을 거예요.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
