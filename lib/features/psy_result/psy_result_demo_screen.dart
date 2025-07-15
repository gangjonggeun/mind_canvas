import 'package:flutter/material.dart';
import 'presentation/psy_result_screen.dart';
import 'psy_result_sample_data.dart';

/// 심리테스트 결과 데모 화면
/// 개발 및 테스트용 샘플 결과 확인
class PsyResultDemoScreen extends StatelessWidget {
  const PsyResultDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '심리테스트 결과 미리보기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌸 감성적인 심리테스트 결과 UI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              '여성 사용자들이 선호하는 따뜻하고 부드러운 디자인\n'
              '결과 길이에 따라 자동으로 최적화된 레이아웃',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            Expanded(
              child: ListView(
                children: [
                  // 짧은 결과 샘플
                  _buildSampleCard(
                    context,
                    title: '💕 연애 성향 테스트',
                    subtitle: '짧은 결과 레이아웃',
                    description: '카드 기반의 간결하고 감성적인 디자인',
                    gradient: const LinearGradient(
                    colors: [Color(0xFFFF8FA3), Color(0xFFFFC1CC)],
                    ),
                    onTap: () => _showResult(context, PsyResultSampleData.shortLoveResult),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 긴 결과 샘플
                  _buildSampleCard(
                    context,
                    title: '🌸 성격 분석 테스트',
                    subtitle: '긴 결과 레이아웃',
                    description: '섹션 기반의 읽기 친화적 디자인\n진행률 표시 및 하이라이트 기능',
                    gradient: const LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFFD1C4E9)],
                    ),
                    onTap: () => _showResult(context, PsyResultSampleData.longPersonalityResult),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 컬러 테라피 샘플
                  _buildSampleCard(
                    context,
                    title: '🌿 컬러 테라피',
                    subtitle: '중간 길이 결과',
                    description: '색상 중심의 신비로운 분위기',
                    gradient: const LinearGradient(
                    colors: [Color(0xFF8B9AFF), Color(0xFFC5CAE9)],
                    ),
                    onTap: () => _showResult(context, PsyResultSampleData.colorTherapyResult),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 기술적 특징 안내
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('⚡', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text(
                              '기술적 특징',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        ...[
                          '🔄 적응형 레이아웃 (결과 길이 자동 감지)',
                          '💾 메모리 최적화 (lazy loading, RepaintBoundary)',
                          '📱 부드러운 애니메이션 (햅틱 피드백)',
                          '🎨 감성적 디자인 (그라데이션, 부드러운 모서리)',
                          '📊 읽기 진행률 표시 (긴 결과용)',
                          '🔖 북마크 및 공유 기능',
                        ].map((feature) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4A5568),
                                height: 1.5,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
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

  Widget _buildSampleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, dynamic result) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PsyResultScreen(result: result);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
