import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../domain/models/taro_card.dart';
import '../../domain/models/TaroResultEntity.dart';
import '../../domain/models/taro_spread_type.dart';
import '../providers/taro_analysis_notifier.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/taro_background.dart';

/// 향상된 타로 결과 페이지
/// TaroResultEntity를 사용하여 구조화된 결과 표시
class TaroResultPage extends ConsumerWidget {
  const TaroResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: TaroBackground(
        child: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              // ✅ 수정 1: ConsultationNotifier 대신 AnalysisNotifier 구독
              // AsyncValue<TaroResultEntity?> 타입입니다.
              final analysisState = ref.watch(taroAnalysisProvider);

              return analysisState.when(
                // 1. 데이터가 있을 때 (성공)
                data: (result) {
                  if (result == null) return _buildErrorState(context, '분석 결과가 없습니다.');

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader(context, result)),
                      SliverToBoxAdapter(child: _buildCardSpread(result)),
                      SliverToBoxAdapter(child: _buildOverallInterpretation(result)),
                      SliverToBoxAdapter(child: _buildDetailedInterpretations(result)),
                      SliverToBoxAdapter(child: _buildBottomActions(context, result)),
                      SliverToBoxAdapter(child: SizedBox(height: 32.h)),
                    ],
                  );
                },
                // 2. 에러 발생 시
                error: (err, stack) => _buildErrorState(context, err.toString()),
                // 3. 로딩 중일 때 (사실 이 페이지 들어오기 전에 로딩이 끝나지만 안전장치)
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
  //
  // /// 임시 결과 데이터 생성 (실제로는 AI 서버에서 받아올 데이터)
  // TaroResultEntity? _generateMockResult(TaroConsultationState state) {
  //   if (state.selectedSpreadType == null ||
  //       state.selectedCards.every((c) => c == null)) {
  //     return null;
  //   }
  //
  //   final selectedCards = state.selectedCards
  //       .where((id) => id != null)
  //       .map((id) => TaroCards.findById(id!))
  //       .whereType<TaroCard>()
  //       .toList();
  //
  //   if (selectedCards.isEmpty) return null;
  //
  //   // 위치별 의미 매핑
  //   final positionNames = _getPositionNames(state.selectedSpreadType!);
  //
  //   final cardInterpretations = selectedCards.asMap().entries.map((entry) {
  //     final index = entry.key;
  //     final card = entry.value;
  //     final positionName = index < positionNames.length
  //         ? positionNames[index]
  //         : '카드 ${index + 1}';
  //
  //     // 역카드 확률 50% (실제 타로처럼)
  //     final isReversed = (index.hashCode % 2 == 0); // 50% 확률로 역카드
  //
  //     return InterpretedCard(
  //       cardId: card.id,
  //       cardName: card.name,
  //       positionName: positionName,
  //       isReversed: isReversed,
  //       subtitle: _generateSubtitle(card, positionName, isReversed),
  //       detailedText: _generateDetailedText(card, positionName, isReversed),
  //     );
  //   }).toList();
  //
  //   return TaroResultEntity(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     date: DateTime.now(),
  //     theme: state.theme,
  //     spreadName: state.selectedSpreadType!.name,
  //     overallInterpretation: _generateOverallInterpretation(selectedCards, state.selectedSpreadType!),
  //     cardInterpretations: cardInterpretations,
  //   );
  // }

  /// 스프레드 타입별 위치 이름 반환
  List<String> _getPositionNames(TaroSpreadType spreadType) {
    switch (spreadType.cardCount) {
      case 3:
        return ['과거', '현재', '미래'];
      case 5:
        return ['현재', '목표', '과거', '미래', '결과'];
      case 7:
        return ['과거의 사건', '현재 상태', '가까운 미래', '문제해결 방법', '주변환경', '장애물', '결과'];
      case 10:
        return ['현재', '장애물', '문제의 이유', '과거의 사건', '목표', '가까운미래', '나의 모습', '남이 보는\n나의 모습', '희망/두려움', '최종 결과'];
      default:
        return List.generate(spreadType.cardCount, (i) => '카드 ${i + 1}');
    }
  }

  /// AI 생성 소제목 (실제로는 AI 서버에서 생성)
  String _generateSubtitle(TaroCard card, String positionName, bool isReversed) {
    final baseSubtitles = {
      '과거': '${card.name}가 말하는 과거로부터의 메시지',
      '현재': '${card.name}가 보여주는 현재 상황',
      '미래': '${card.name}가 예고하는 미래의 가능성',
      '목표': '${card.name}와 함께하는 목표 달성',
      '결과': '${card.name}가 가져다줄 최종 결과',
      '장애물': '${card.name}가 경고하는 주의사항',
      '문제해결 방법': '${card.name}가 제시하는 해결책',
    };

    final baseSubtitle = baseSubtitles[positionName] ?? '${card.name}의 지혜';

    // 역카드인 경우 부제목 수정
    if (isReversed) {
      return '$baseSubtitle (역방향의 숨겨진 의미)';
    }

    return baseSubtitle;
  }
  //
  // /// AI 생성 상세 텍스트 (실제로는 AI 서버에서 생성)
  // String _generateDetailedText(TaroCard card, String positionName, bool isReversed) {
  //   final baseText = card.description;
  //
  //   final contextualText = {
  //     '과거': '과거에 당신이 경험했던 일들이 현재 상황에 중요한 영향을 미치고 있습니다.',
  //     '현재': '현재 당신이 처해있는 상황을 명확히 보여주며, 이를 통해 앞으로의 방향성을 제시합니다.',
  //     '미래': '앞으로 다가올 가능성과 기회를 암시하며, 당신이 준비해야 할 것들을 알려줍니다.',
  //     '목표': '당신이 추구하는 목표와 관련된 에너지와 방향성을 나타냅니다.',
  //     '결과': '현재의 상황과 노력이 가져다줄 최종적인 결과를 예시합니다.',
  //     '장애물': '앞으로 마주할 수 있는 어려움과 이를 극복하기 위한 준비사항을 제시합니다.',
  //     '문제해결 방법': '현재 상황을 개선하고 발전시키기 위한 구체적인 방법을 제안합니다.',
  //   };
  //
  //   final contextText = contextualText[positionName] ?? '이 카드는 당신의 여정에서 중요한 의미를 지니고 있습니다.';
  //
  //   // 역카드인 경우 해석 수정
  //   if (isReversed) {
  //     final reversedMeaning = _getReversedMeaning(card);
  //     return '$reversedMeaning\n\n$contextText\n\n역방향 카드는 내면의 변화나 잠재된 가능성을 나타냅니다. 현재 상황에서 다른 관점으로 접근해보거나, 내적 성장에 집중할 때임을 의미할 수 있습니다.';
  //   }
  //
  //   return '$baseText\n\n$contextText\n\n주의깊게 살펴보고 내면의 목소리에 귀를 기울여보세요. 카드가 전하는 메시지는 당신의 직관과 만나 더욱 깊은 통찰을 가져다줄 것입니다.';
  // }
  //
  // /// 역카드 의미 생성
  // String _getReversedMeaning(TaroCard card) {
  //   // 실제로는 각 카드별로 정의된 역방향 의미를 사용
  //   final reversedMeanings = {
  //     'major_00': '무모함, 경솔함, 준비 부족',
  //     'major_01': '조작, 속임수, 집중력 부족',
  //     'major_02': '직감 무시, 내면의 목소리 차단',
  //     'major_03': '창조성 부족, 과잉보호, 의존성',
  //     'major_04': '독재, 경직성, 권위 남용',
  //     'major_05': '전통 거부, 독립적 사고, 새로운 방법',
  //     'major_06': '불화, 잘못된 선택, 관계 문제',
  //     'major_07': '통제력 상실, 방향성 부족',
  //     'major_08': '내적 갈등, 자신감 부족, 억압',
  //     'major_09': '고립, 외로움, 조언 거부',
  //     'major_10': '불운, 좌절, 변화 저항',
  //     'major_11': '불공정, 편견, 균형 상실',
  //     'major_12': '정체, 희생 거부, 이기심',
  //     'major_13': '변화 거부, 정체성 위기',
  //     'major_14': '불균형, 극단, 조화 부족',
  //     'major_15': '해방, 자유, 속박에서 벗어남',
  //     'major_16': '변화 저항, 내적 파괴',
  //     'major_17': '실망, 절망, 희망 상실',
  //     'major_18': '진실 공개, 명확성, 착각에서 벗어남',
  //     'major_19': '과도함, 자만, 에너지 부족',
  //     'major_20': '자기 비판, 과거에 얽매임',
  //     'major_21': '미완성, 지연, 목표 달성 어려움',
  //   };
  //
  //   return reversedMeanings[card.id] ?? '${card.description}의 반대되는 에너지나 내면의 측면';
  // }

  /// AI 생성 종합 해석 (실제로는 AI 서버에서 생성)
//   String _generateOverallInterpretation(List<TaroCard> cards, TaroSpreadType spreadType) {
//     final cardNames = cards.map((c) => c.name).join(', ');
//     return '''선택된 카드들(${cardNames})은 현재 당신의 상황에서 새로운 변화와 기회가 다가오고 있음을 의미합니다. 과거의 경험들이 현재 상황의 기반이 되고 있으며, 미래에 대한 희망적인 전망을 보여줍니다.
//
// ${spreadType.name} 스프레드를 통해 볼 때, 당신은 지금 중요한 전환점에 서 있습니다. 카드가 전하는 메시지를 바탕으로 균형잡힌 시각으로 상황을 바라보고, 미래를 위한 실질적인 계획을 세워보시길 권합니다.
//
// 주제: "${cards.first.description}"에 대한 답변이 곧 명확해질 것입니다. 인내심을 갖고 기다리며, 직감에 따라 행동하시기 바랍니다.''';
//   }

  // ✅ 수정 2: 에러 화면 메시지 파라미터 추가
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
          Gap(16.h),
          Text('결과를 불러올 수 없습니다',
              style: TextStyle(fontSize: 18.sp, color: Colors.white)),
          Gap(8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.7))),
          ),
          Gap(24.h),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('돌아가기'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TaroResultEntity result) {
    return Padding(
      padding: EdgeInsets.all(20.w).copyWith(bottom: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
              ),
              Text('타로 결과',
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                onPressed: () => _shareResult(context, result),
                icon: Icon(Icons.share, color: Colors.white, size: 24.sp),
              ),
            ],
          ),
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  '주제: ${result.theme}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.9)),
                  textAlign: TextAlign.center,
                ),
                Gap(4.h),
                Text(
                  '${result.spreadName} • ${result.date.year}.${result.date.month.toString().padLeft(2, '0')}.${result.date.day.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSpread(TaroResultEntity result) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택된 카드 (${result.spreadName})',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 16.h,
            alignment: WrapAlignment.center,
            // result.cardInterpretations 리스트를 그대로 사용
            children: result.cardInterpretations.map((interpretation) {
              final card = TaroCards.findById(interpretation.cardId);
              if (card == null) return const SizedBox.shrink();

              return _buildRevealedCard(
                card: card,
                interpretation: interpretation, // 이미 해석된 정보(역방향, 위치이름 등) 포함
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedCard({
    required TaroCard card,
    required InterpretedCard interpretation,
  }) {
    final cardWidth = 100.w;

    return Column(
      children: [
        // 카드 상단에 카드 이름 표시
        Container(
          width: cardWidth,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: interpretation.isReversed
                ? Colors.purple.shade600.withOpacity(0.8)  // 역카드는 보라색
                : Colors.amber.shade600.withOpacity(0.8),   // 정방향은 호박색
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            interpretation.isReversed ? '${card.name} (역방향)' : card.name,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Gap(4.h),
        // 카드 이미지
        Container(
          width: cardWidth,
          height: cardWidth * 1.55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Transform(
              alignment: Alignment.center,
              transform: interpretation.isReversed
                  ? Matrix4.rotationZ(3.14159)  // 역카드는 180도 회전
                  : Matrix4.identity(),
              child: Image.asset(
                card.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로딩 실패 시 기본 카드 UI 표시
                  return _buildCardFallback(card, cardWidth);
                },
              ),
            ),
          ),
        ),
        Gap(8.h),
        // 위치 정보 표시
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            interpretation.positionName,
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCardFallback(TaroCard card, double width) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade100],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            ),
            child: Text(
              card.nameEn,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                _getCardIcon(card),
                size: width * 0.4,
                color: Colors.indigo.shade600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w).copyWith(bottom: 6.h),
            child: Text(
              _getCardKeywords(card),
              style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallInterpretation(TaroResultEntity result) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.amber.shade300.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber.shade300, size: 22.sp),
              Gap(8.w),
              Text('AI 종합 해석',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Gap(16.h),
          Text(
            result.overallInterpretation,
            style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.9), height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInterpretations(TaroResultEntity result) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 16.h),
            child: Text(
              '카드별 상세 의미',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ...result.cardInterpretations.map((interpretation) {
            final card = TaroCards.findById(interpretation.cardId);
            if (card == null) return SizedBox.shrink();

            return _buildDetailedCardInterpretation(card, interpretation);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDetailedCardInterpretation(TaroCard card, InterpretedCard interpretation) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 왼쪽: 카드 이미지
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
                child: Transform(
                  alignment: Alignment.center,
                  transform: interpretation.isReversed
                      ? Matrix4.rotationZ(3.14159)  // 역카드는 180도 회전
                      : Matrix4.identity(),
                  child: Image.asset(
                    card.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: interpretation.isReversed
                            ? Matrix4.rotationZ(3.14159)  // fallback도 회전
                            : Matrix4.identity(),
                        child: _buildCardFallback(card, 100.w),
                      );
                    },
                  ),
                ),
              ),
            ),
            // 오른쪽: 카드 설명
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${interpretation.positionName}: ${card.name}${interpretation.isReversed ? ' (역방향)' : ''}',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: interpretation.isReversed
                              ? Colors.purple.shade300  // 역카드는 보라색
                              : Colors.amber.shade300   // 정방향은 호박색
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      '(${card.nameEn})',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.6)),
                    ),
                    Gap(12.h),
                    // AI 생성 소제목
                    Text(
                      interpretation.subtitle,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
                    ),
                    Divider(color: Colors.white.withOpacity(0.2), height: 20.h),
                    // AI 생성 상세 내용
                    Text(
                      interpretation.detailedText,
                      style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.8), height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, TaroResultEntity result) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text('홈으로', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            ),
          ),
          Gap(16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _saveResult(context, result),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text('결과 저장', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _shareResult(BuildContext context, TaroResultEntity result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.theme} 결과가 공유되었습니다'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _saveResult(BuildContext context, TaroResultEntity result) {
    // 실제로는 로컬 저장소나 서버에 저장
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.date.month}/${result.date.day} 결과가 저장되었습니다'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  // 카드 아이콘 및 키워드 헬퍼 메소드들
  IconData _getCardIcon(TaroCard card) {
    if (card.type == TaroCardType.majorArcana) {
      final number = int.tryParse(card.id.split('_').last) ?? 0;
      switch (number) {
        case 0: return Icons.brightness_1;
        case 1: return Icons.auto_fix_high;
        case 2: return Icons.nightlight;
        case 3: return Icons.favorite;
        case 4: return Icons.account_balance;
        case 5: return Icons.church;
        case 6: return Icons.favorite_border;
        case 7: return Icons.directions_car;
        case 8: return Icons.pets;
        case 9: return Icons.lightbulb;
        case 10: return Icons.sync;
        case 11: return Icons.balance;
        case 12: return Icons.person_outline;
        case 13: return Icons.dangerous;
        case 14: return Icons.local_bar;
        case 15: return Icons.warning;
        case 16: return Icons.flash_on;
        case 17: return Icons.star;
        case 18: return Icons.brightness_3;
        case 19: return Icons.wb_sunny;
        case 20: return Icons.music_note;
        case 21: return Icons.public;
        default: return Icons.auto_awesome;
      }
    } else {
      switch (card.type) {
        case TaroCardType.cups: return Icons.local_drink;
        case TaroCardType.wands: return Icons.whatshot;
        case TaroCardType.swords: return Icons.flash_on;
        case TaroCardType.pentacles: return Icons.monetization_on;
        default: return Icons.circle;
      }
    }
  }

  String _getCardKeywords(TaroCard card) {
    switch (card.type) {
      case TaroCardType.majorArcana: return '운명, 변화, 성장';
      case TaroCardType.cups: return '감정, 사랑, 관계';
      case TaroCardType.pentacles: return '물질, 돈, 직업';
      case TaroCardType.swords: return '생각, 갈등, 결정';
      case TaroCardType.wands: return '의지, 창조, 열정';
    }
  }
}