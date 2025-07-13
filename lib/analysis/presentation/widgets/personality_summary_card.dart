import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 성격 분석 요약 카드 (상단)
/// 핵심 정보를 한눈에 보여주는 카드
class PersonalitySummaryCard extends StatelessWidget {
  final AnalysisData analysisData;

  const PersonalitySummaryCard({
    super.key,
    required this.analysisData,
  });

  @override
  Widget build(BuildContext context) {
    final strongestDimension = analysisData.personalityDimensions.reduce(
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
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    strongestDimension.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '당신의 특징',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strongestDimension.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${strongestDimension.score.toInt()}점',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 한줄 평가
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getPersonalityInsight(strongestDimension),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 분석 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                '완성도',
                '${analysisData.completionPercentage.toInt()}%',
                Icons.pie_chart_outline,
              ),
              _buildInfoItem(
                '정확도',
                '${analysisData.averageAccuracy.toInt()}%',
                Icons.verified_outlined,
              ),
              _buildInfoItem(
                '마지막 업데이트',
                _formatDate(analysisData.lastUpdated),
                Icons.update_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  String _getPersonalityInsight(PersonalityDimension strongest) {
    if (strongest.shortName == '창의성') {
      return '새로운 아이디어를 잘 생각해내는 창의적인 사람이에요';
    } else if (strongest.shortName == '열정') {
      return '에너지가 넘치고 새로운 도전을 즐기는 적극적인 성향이에요';
    } else if (strongest.shortName == '안정감') {
      return '감정이 안정적이고 스트레스 상황에서도 차분함을 유지해요';
    } else if (strongest.shortName == '사교성') {
      return '사람들과의 관계를 즐기고 소통 능력이 뛰어나요';
    } else if (strongest.shortName == '이성') {
      return '논리적 사고력이 뛰어나고 객관적인 판단을 잘해요';
    } else {
      return '균형 잡힌 성격으로 다양한 상황에 잘 적응하는 편이에요';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else {
      return '방금 전';
    }
  }
}
