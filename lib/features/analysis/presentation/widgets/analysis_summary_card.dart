import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../data/dto/comprehensive_analysis_response.dart';
import '../notifier/comprehensive_analysis_notifier.dart';
import 'comprehensive_analysis_screen.dart';


class AnalysisSummaryCard extends ConsumerWidget {
  const AnalysisSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comprehensiveAnalysisNotifierProvider);

    // 1. 로딩 중
    if (state.isLoading) {
      return _buildContainer(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(S.of(context).analysis_summary_loading, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // 2. 에러 발생 (재시도 버튼)
    if (state.errorMessage != null) {
      return _buildContainer(
        color: Colors.red.shade50,
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 32),
            const SizedBox(height: 8),
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(comprehensiveAnalysisNotifierProvider.notifier).loadAnalysisReport(),
              child: Text(S.of(context).analysis_summary_retry),
            ),
          ],
        ),
      );
    }

    // 3. 데이터 없음 (분석 시작 버튼)
    if (state.report == null) {
      return _buildContainer(
        color: const Color(0xFFF0F4FF), // 연한 파란색 배경
        child: Column(
          children: [
            const Icon(Icons.auto_awesome, size: 40, color: Color(0xFF667EEA)),
            const SizedBox(height: 12),
            Text(
              S.of(context).analysis_summary_nodata_title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              S.of(context).analysis_summary_nodata_content,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 분석 요청 시작!
                _showPurchaseDialog(context, ref, isRefresh: false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child:  Text(S.of(context).analysis_summary_start_btn),
            ),
          ],
        ),
      );
    }

    if (state.report != null) {
      return _buildResultCard(context, ref, state.report!);
    }

    return const SizedBox(); // Fallback
  }

  Widget _buildResultCard(BuildContext context, WidgetRef ref, ComprehensiveAnalysisResponse data) {
    Color themeColor;
    try {
      themeColor = Color(int.parse(data.themeColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      themeColor = const Color(0xFF667EEA);
    }

    final tagBackgroundColor = Colors.white.withOpacity(0.25);
    final tagTextColor = Colors.white;

    return GestureDetector(
      onTap: () {
        context.pushNamed('comprehensive_analysis');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚀 1. 최상단 배치: [나의 심리 분석] 뱃지 & [자세히 보기 >]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, // 위쪽 정렬
              children: [
                // 왼쪽 뱃지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text(
                        S.of(context).analysis_summary_my_psydata,
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // 오른쪽 자세히 보기
                 Padding(
                  padding: EdgeInsets.only(top: 2), // 뱃지와 시각적 중앙 맞춤
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(S.of(context).analysis_summary_show_detail, style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🚀 2. 제목 (뱃지 아래로 이동)
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

            // 3. 캐치프레이즈
            Text(
              '"${data.catchphrase}"',
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 20),

            // 🚀 4. 하단: 태그(1열 강제) + 다시 받기 버튼
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
              children: [
                // 태그 리스트 (가로 스크롤 허용해서 무조건 1줄로 유지)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: data.keywords.take(3).map((k) => Padding(
                        padding: const EdgeInsets.only(right: 6), // 태그 사이 간격
                        child: Container(
                          // 패딩 줄여서 크기 감소
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tagBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            "#$k",
                            // 폰트 크기 13 -> 11로 축소
                            style: TextStyle(
                                color: tagTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 12), // 태그와 버튼 사이 최소 간격

                // 다시 받기 버튼
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showRefreshDialog(context, ref),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // ✅ [수정/통합] 구매 확정 다이얼로그 (초기 분석 & 다시 받기 공용)
  void _showPurchaseDialog(BuildContext context, WidgetRef ref, {required bool isRefresh}) {
    final title = isRefresh ? S.of(context).analysis_summary_retry_analysis : S.of(context).analysis_summary_analysis;
    final message = isRefresh
        ? S.of(context).analysis_summary_info_1
        : S.of(context).analysis_summary_info2;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  S.of(context).analysis_summary_ink,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(S.of(context).analysis_summary_continue, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(S.of(context).analysis_summary_cancel, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기

              // 분기 처리
              if (isRefresh) {
                ref.read(comprehensiveAnalysisNotifierProvider.notifier).refreshAnalysis();
              } else {
                ref.read(comprehensiveAnalysisNotifierProvider.notifier).loadAnalysisReport();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
            ),
            child: Text(isRefresh ? S.of(context).analysis_summary_retry : S.of(context).analysis_summary_start_btn),
          ),
        ],
      ),
    );
  }

  // 🔄 다시 받기 다이얼로그
  void _showRefreshDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).analysis_summary_retry_analysis),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).analysis_summary_info_1),//
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  S.of(context).analysis_summary_ink,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(S.of(context).analysis_summary_continue, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(S.of(context).analysis_summary_cancel, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              // 재분석 요청 실행!
              ref.read(comprehensiveAnalysisNotifierProvider.notifier).refreshAnalysis();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
            ),
            child:  Text(S.of(context).analysis_summary_retry),
          ),
        ],
      ),
    );
  }
  Widget _buildContainer({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(child: child),
    );
  }
}