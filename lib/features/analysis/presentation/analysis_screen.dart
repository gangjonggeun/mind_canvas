import 'package:flutter/material.dart';
import '../domain/entities/analysis_data.dart';
import '../analysis_sample_data.dart';

/// 트렌디하고 깔끔한 분석 화면
/// 완전히 새로운 디자인으로 개선
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final AnalysisData _analysisData = AnalysisSampleData.sampleAnalysisData;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 트렌디한 앱바
            _buildTrendyAppBar(),
            
            // 메인 컨텐츠
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 상단: 트렌디 요약 카드
                  _buildTrendyPersonalityCard(),
                  
                  const SizedBox(height: 20),
                  
                  // 성격 태그들 (더 작게)
                  _buildCompactTags(),
                  
                  const SizedBox(height: 32),
                  
                  // MBTI 슬라이더 (4개)
                  if (_analysisData.mbtiType != null)
                    _buildMbtiSliderSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 인지기능 상위 3개
                  _buildTopCognitiveFunctions(),
                  
                  const SizedBox(height: 24),
                  
                  // Big 5 성격지표 (5개)
                  _buildBigFiveSliders(),
                  
                  const SizedBox(height: 24),
                  
                  // 에니어그램 상위 3개
                  _buildTopEnneagramTypes(),
                  
                  const SizedBox(height: 24),
                  
                  // 핵심 성격 지표
                  _buildCorePersonalityIndicator(),
                  
                  const SizedBox(height: 32),
                  
                  // 추천 컨텐츠
                  _buildRecommendedContent(),
                  
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 개선된 트렌디한 앱바
  Widget _buildTrendyAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFFF8FAFC),
      foregroundColor: const Color(0xFF1E293B),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFF1F5F9),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '나의 성격 분석',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '심리테스트를 할수록 정확해지는',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 개선된 성격 카드
  Widget _buildTrendyPersonalityCard() {
    final strongestDimension = _analysisData.personalityDimensions.reduce(
      (a, b) => a.score > b.score ? a : b,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 헤더
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    strongestDimension.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신의 특징',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '독창적이지만 고집스러운 예술가',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // 평가 텍스트
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '남들과 다른 독특한 시각으로 세상을 바라보며, 자신만의 신념과 가치관이 뚜렷한 사람이에요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '때로는 고집스러워 보일 수 있지만, 그것이 당신만의 매력이자 창작의 원동력입니다.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 더 작은 태그들
  Widget _buildCompactTags() {
    final topTags = _analysisData.personalityTags.take(5).toList();
    
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: topTags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.3),
            ),
          ),
          child: Text(
            '#${tag.name}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(int.parse(tag.color, radix: 16)),
            ),
          ),
        );
      }).toList(),
    );
  }



  /// MBTI 슬라이더 섹션 (이미지와 같은 디자인)
  Widget _buildMbtiSliderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MBTI 성향 분석',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    _analysisData.mbtiType!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 4차원 슬라이더들 (이미지와 동일한 스타일)
          ...(_analysisData.mbtiScores.map((score) {
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: _buildImageStyleSlider(score),
            );
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildMbtiSlider(MbtiScore score) {
    // 기존 함수를 새로운 스타일로 대체
    return _buildImageStyleSlider(score);
  }

  /// 이미지와 같은 스타일의 슬라이더
  Widget _buildImageStyleSlider(MbtiScore score) {
    final isRightDominant = score.score > 0;
    final percentage = score.percentage;
    
    // 색상 정의 (이미지에서 참조)
    Color getSliderColor() {
      switch (score.dimension) {
        case 'E/I': return const Color(0xFFE91E63); // 핀크
        case 'S/N': return const Color(0xFF2196F3); // 블루
        case 'T/F': return const Color(0xFFFFC107); // 오렌지/노랑
        case 'J/P': return const Color(0xFF4CAF50); // 그린
        default: return const Color(0xFF667EEA);
      }
    }
    
    // 각 타입별 설명
    Map<String, String> getTypeDescriptions() {
      switch (score.dimension) {
        case 'E/I':
          return {
            'E': '외향적인',
            'I': '내향적인'
          };
        case 'S/N':
          return {
            'S': '현실적인',
            'N': '직관적인'
          };
        case 'T/F':
          return {
            'T': '논리적인',
            'F': '감정적인'
          };
        case 'J/P':
          return {
            'J': '계획적인',
            'P': '유연한'
          };
        default:
          return {'': '', '': ''};
      }
    }
    
    final sliderColor = getSliderColor();
    final descriptions = getTypeDescriptions();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨들 (이니셜 + 설명)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 왼쪽 라벨
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.leftType,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: !isRightDominant ? sliderColor : const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    descriptions[score.leftType] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: !isRightDominant ? sliderColor.withOpacity(0.8) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            // 오른쪽 라벨
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score.rightType,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isRightDominant ? sliderColor : const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    descriptions[score.rightType] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isRightDominant ? sliderColor.withOpacity(0.8) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 슬라이더 트랙
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              // 진행 바
              FractionallySizedBox(
                alignment: isRightDominant ? Alignment.centerRight : Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: sliderColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              // 슬라이더 노브 (점)
              Positioned(
                left: isRightDominant 
                  ? null
                  : (percentage / 100) * (MediaQuery.of(context).size.width - 88) - 4,
                right: isRightDominant 
                  ? (100 - percentage) / 100 * (MediaQuery.of(context).size.width - 88) - 4
                  : null,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: sliderColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: sliderColor.withOpacity(0.3),
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
        
        const SizedBox(height: 8),
        
        // 퍼센트 표시
        Center(
          child: Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: sliderColor,
            ),
          ),
        ),
      ],
    );
  }

  /// 인지기능 상위 3개
  Widget _buildTopCognitiveFunctions() {
    final topFunctions = _analysisData.cognitiveFunctions
        .where((f) => f.strength > 50)
        .toList()
        ..sort((a, b) => b.strength.compareTo(a.strength));
    
    final displayFunctions = topFunctions.take(3).toList();
    
    // 인지기능 설명 맵
    Map<String, String> getFunctionDescription(String shortName) {
      switch (shortName) {
        case 'Te': return {'name': '외향 사고', 'desc': '효율적 조직화'};
        case 'Ti': return {'name': '내향 사고', 'desc': '논리적 분석'};
        case 'Fe': return {'name': '외향 감정', 'desc': '타인 배려'};
        case 'Fi': return {'name': '내향 감정', 'desc': '개인적 가치'};
        case 'Se': return {'name': '외향 감각', 'desc': '현재 경험'};
        case 'Si': return {'name': '내향 감각', 'desc': '과거 기억'};
        case 'Ne': return {'name': '외향 직관', 'desc': '가능성 탐색'};
        case 'Ni': return {'name': '내향 직관', 'desc': '미래 통찰'};
        default: return {'name': '알 수 없음', 'desc': ''};
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '인지기능 패턴',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          const Text(
            '당신이 가장 자주 사용하는 사고 방식입니다',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 상위 3개 기능 (설명 추가)
          Row(
            children: displayFunctions.map((function) {
              final color = Color(int.parse(function.color, radix: 16));
              final functionInfo = getFunctionDescription(function.shortName);
              
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          function.shortName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      functionInfo['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      functionInfo['desc']!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${function.strength.toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Big 5 성격지표 슬라이더
  Widget _buildBigFiveSliders() {
    // Big 5를 위한 더미 데이터 (기존 personalityDimensions를 변환)
    final bigFiveData = [
      {
        'name': '신경성',
        'leftLabel': '안정적인',
        'rightLabel': '불안한',
        'score': 35.0, // 안정적
        'color': const Color(0xFFEF5350),
      },
      {
        'name': '외향성',
        'leftLabel': '내향적인',
        'rightLabel': '외향적인',
        'score': 32.0, // 내향적
        'color': const Color(0xFF42A5F5),
      },
      {
        'name': '개방성',
        'leftLabel': '보수적인',
        'rightLabel': '개방적인',
        'score': 85.0, // 개방적
        'color': const Color(0xFFAB47BC),
      },
      {
        'name': '친화성',
        'leftLabel': '경쟁적인',
        'rightLabel': '협력적인',
        'score': 70.0, // 협력적
        'color': const Color(0xFF66BB6A),
      },
      {
        'name': '성실성',
        'leftLabel': '자유분방',
        'rightLabel': '책임감 있는',
        'score': 55.0, // 보통
        'color': const Color(0xFFFF7043),
      },
    ];
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7043), Color(0xFFE64A19)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assessment_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Big 5 성격 지표',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Big 5 슬라이더들
          ...bigFiveData.map((data) {
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: _buildBigFiveSlider(
                data['name'] as String,
                data['leftLabel'] as String,
                data['rightLabel'] as String,
                data['score'] as double,
                data['color'] as Color,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBigFiveSlider(
    String name,
    String leftLabel,
    String rightLabel,
    double score,
    Color color,
  ) {
    final isRightDominant = score > 50;
    final percentage = isRightDominant ? score : (100 - score);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이름
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 라벨들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: !isRightDominant ? color : const Color(0xFF94A3B8),
              ),
            ),
            Text(
              rightLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isRightDominant ? color : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 슬라이더
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                alignment: isRightDominant ? Alignment.centerRight : Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 4),
        
        // 퍼센트
        Text(
          '${score.toInt()}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 에니어그램 상위 3개
  Widget _buildTopEnneagramTypes() {
    final topTypes = _analysisData.enneagramTypes.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '에니어그램 유형',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 상위 3개 유형
          Row(
            children: topTypes.map((type) {
              final color = Color(int.parse(type.color, radix: 16));
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              type.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${type.score.toInt()}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${type.number}번',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      type.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 핵심 성격 지표
  Widget _buildCorePersonalityIndicator() {
    final strongestDimension = _analysisData.personalityDimensions.reduce(
      (a, b) => a.score > b.score ? a : b,
    );
    
    final color = Color(int.parse(strongestDimension.color, radix: 16));
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '핵심 성격 지표',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 메인 지표
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      strongestDimension.icon,
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
                        strongestDimension.shortName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strongestDimension.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${strongestDimension.score.toInt()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// MBTI 8기능 차트
  Widget _buildCognitiveFunctionsChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '인지 기능 패턴',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          
          // 원형 차트 스타일로 8기능 표시
          Row(
            children: [
              Expanded(
                child: _buildCognitiveFunctionCircle(_analysisData.cognitiveFunctions[0]),
              ),
              Expanded(
                child: _buildCognitiveFunctionCircle(_analysisData.cognitiveFunctions[1]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCognitiveFunctionCircle(_analysisData.cognitiveFunctions[2]),
              ),
              Expanded(
                child: _buildCognitiveFunctionCircle(_analysisData.cognitiveFunctions[3]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCognitiveFunctionCircle(CognitiveFunction function) {
    final color = Color(int.parse(function.color, radix: 16));
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              function.shortName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${function.strength.toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          function.type.displayName,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// 에니어그램 차트
  Widget _buildEnneagramChart() {
    final topTypes = _analysisData.enneagramTypes.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '에니어그램 유형',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          
          // 상위 3개 타입을 도넛 차트 스타일로
          Row(
            children: topTypes.map((type) {
              final color = Color(int.parse(type.color, radix: 16));
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              type.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${type.score.toInt()}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${type.number}번',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      type.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 추천 컨텐츠
  Widget _buildRecommendedContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🎬', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                '맞춤 추천',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _analysisData.recommendedContents.length,
              itemBuilder: (context, index) {
                final content = _analysisData.recommendedContents[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getContentIcon(content.type),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${content.matchPercentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getContentIcon(String type) {
    switch (type) {
      case '영화':
        return '🎬';
      case '드라마':
        return '📺';
      case '도서':
        return '📚';
      case '음악':
        return '🎵';
      default:
        return '⭐';
    }
  }
}
