import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../data/dto/comprehensive_analysis_response.dart';
import '../notifier/comprehensive_analysis_notifier.dart';


class ComprehensiveAnalysisScreen extends ConsumerStatefulWidget {
  const ComprehensiveAnalysisScreen({super.key});

  @override
  ConsumerState<ComprehensiveAnalysisScreen> createState() => _ComprehensiveAnalysisScreenState();
}

class _ComprehensiveAnalysisScreenState extends ConsumerState<ComprehensiveAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(comprehensiveAnalysisNotifierProvider.notifier).loadAnalysisReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(comprehensiveAnalysisNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).analysis_page_title),
        centerTitle: true,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ComprehensiveAnalysisState state) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(S.of(context).analysis_page_loading, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(comprehensiveAnalysisNotifierProvider.notifier).loadAnalysisReport(),
              child: Text(S.of(context).analysis_page_retry),
            ),
          ],
        ),
      );
    }

    if (state.report == null) {
      return Center(child: Text(S.of(context).analysis_page_empty));
    }

    // 데이터가 있을 경우 리포트 UI 렌더링
    return _buildReportContent(state.report!);
  }

  Widget _buildReportContent(ComprehensiveAnalysisResponse data) {
    Color themeColor;
    try {
      themeColor = Color(int.parse(data.themeColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      themeColor = const Color(0xFF667EEA);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 헤더 (기존 유지 or 약간 수정)
          _buildHeaderCard(data, themeColor),
          const SizedBox(height: 32),

          // 2. 종합 분석 본문
          _buildSectionTitle(S.of(context).analysis_page_core_summary, themeColor),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Text(
              data.coreSummary,
              style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 32),

          // 3. ✨ 나의 강점 (세로 리스트 카드)
          _buildSectionTitle(S.of(context).analysis_page_strengths, Colors.green),
          ...data.strengths.map((text) => _buildDetailCard(
            text: text,
            icon: Icons.check_circle_outline,
            accentColor: Colors.green,
          )),

          const SizedBox(height: 32),

          // 4. ⚠️ 주의할 점 (세로 리스트 카드)
          _buildSectionTitle(S.of(context).analysis_page_weakness, Colors.orange),
          ...data.weaknesses.map((text) => _buildDetailCard(
            text: text,
            icon: Icons.warning_amber_rounded,
            accentColor: Colors.orange,
          )),

          const SizedBox(height: 32),

          // 5. 🌿 최적의 환경
          _buildSectionTitle(S.of(context).analysis_page_environment, themeColor),
          _buildDetailCard(
            text: data.idealEnvironment,
            icon: Icons.spa_outlined,
            accentColor: themeColor,
            isHighlight: true, // 배경색 살짝 넣기
          ),

          const SizedBox(height: 32),

          // 6. 🎨 추천 취미 (텍스트 길이에 맞춰지는 카드)
          _buildSectionTitle(S.of(context).analysis_page_hobbies, themeColor),
          Column(
            children: data.recommendedHobbies.map((hobby) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: themeColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.palette_outlined, color: themeColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hobby,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: themeColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // 강점/약점/환경용 카드 위젯
  Widget _buildDetailCard({
    required String text,
    required IconData icon,
    required Color accentColor,
    bool isHighlight = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? accentColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight ? accentColor.withOpacity(0.3) : Colors.grey.shade200,
        ),
        boxShadow: isHighlight
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // --- 🛠️ 내부 위젯 헬퍼 메서드 ---

  Widget _buildHeaderCard(ComprehensiveAnalysisResponse data, Color themeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeColor, // 서버에서 받은 테마 컬러 적용
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keywords (Chips)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: data.keywords.map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  keyword.startsWith('#') ? keyword : '#$keyword',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Catchphrase
          Text(
            '"${data.catchphrase}"',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(color: Colors.grey)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}