import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/analysis/presentation/widgets/analysis_summary_card.dart';
import '../../../core/widgets/common_sliver_app_bar.dart';
import '../../../generated/l10n.dart';
import '../data/dto/psychological_profile_response.dart';
import '../domain/entities/analysis_data.dart';
import 'notifier/user_analysis_notifier.dart';

/// 트렌디하고 깔끔한 분석 화면
/// 완전히 새로운 디자인으로 개선
class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // final AnalysisData _analysisData = AnalysisSampleData.sampleAnalysisData;

  // 에니어그램 UI 메타데이터 (유형 1~9)
   Map<int, Map<String, dynamic>> get _enneagramMetadata => {
    1: {'name': S.of(context).analysis_eneagram_type1, 'emoji': Icons.balance, 'color': Color(0xFFEF5350)}, // 완벽, 균형
    2: {'name': S.of(context).analysis_eneagram_type2, 'emoji': Icons.favorite, 'color': Color(0xFFAB47BC)}, // 사랑, 도움
    3: {'name': S.of(context).analysis_eneagram_type3, 'emoji': Icons.emoji_events, 'color': Color(0xFFFFA726)}, // 성취, 트로피
    4: {'name': S.of(context).analysis_eneagram_type4, 'emoji': Icons.palette, 'color': Color(0xFF7E57C2)}, // 독창성
    5: {'name': S.of(context).analysis_eneagram_type5, 'emoji': Icons.psychology, 'color': Color(0xFF42A5F5)}, // 지식, 뇌
    6: {'name': S.of(context).analysis_eneagram_type6, 'emoji': Icons.security, 'color': Color(0xFF26C6DA)}, // 안전, 보호
    7: {'name': S.of(context).analysis_eneagram_type7, 'emoji': Icons.rocket_launch, 'color': Color(0xFFD4E157)}, // 모험, 재미
    8: {'name': S.of(context).analysis_eneagram_type8, 'emoji': Icons.local_fire_department, 'color': Color(0xFFFF7043)}, // 힘, 불
    9: {'name': S.of(context).analysis_eneagram_type9, 'emoji': Icons.spa, 'color': Color(0xFF66BB6A)}, // 평화, 잎
  };

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
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // 🚀 [해결책] 화면 진입 시 강제로 Provider를 초기화하여
    // 1. 상태를 초기 상태(isLoading: false, profile: null)로 돌리고
    // 2. 자동으로 build()가 실행되며 로딩바가 돌고
    // 3. 데이터를 새로 가져오게 합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 기존 데이터를 날리고 초기 상태로 리셋
      ref.invalidate(userAnalysisNotifierProvider);

      // 그 다음 데이터 요청 실행
      ref.read(userAnalysisNotifierProvider.notifier).loadMyProfile();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // 3. 상태 구독 (State Watching)
    final state = ref.watch(userAnalysisNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // 4. 상태에 따른 화면 분기
      body: _buildBody(state),
    );
  }

  Widget _buildBody(UserAnalysisState state) {
    // 1. 로딩 중 (데이터가 아예 없을 때만 로딩 표시)
    if (state.isLoading && state.profile == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF667EEA)),
      );
    }

    // 2. 에러 발생
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(state.errorMessage!),
            TextButton(
              onPressed: () => ref
                  .read(userAnalysisNotifierProvider.notifier)
                  .loadMyProfile(),
              child: Text(S.of(context).analysis_retry),
            ),
          ],
        ),
      );
    }

    final profile = state.profile;

    // 🚀 [수정] RefreshIndicator로 감싸서 당겨서 새로고침 구현
    return RefreshIndicator(
      color: const Color(0xFF667EEA),
      backgroundColor: Colors.white,
      onRefresh: () async {
        // 새로고침 시 실행될 로직
        await ref.read(userAnalysisNotifierProvider.notifier).loadMyProfile();
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          // 🚀 [중요] 내용이 짧아도 당겨서 새로고침이 되도록 물리 효과 설정 필수
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CommonSliverAppBar(
              title: S.of(context).analysis_mydata,
              subtitle: '심리테스트를 할수록 정확해지는 분석',
              icon: Icons.pie_chart_rounded,
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  const AnalysisSummaryCard(),

                  const SizedBox(height: 32),

                  // 1️⃣ MBTI 섹션
                  _buildMbtiTypeSection(profile),

                  const SizedBox(height: 32),

                  // 3️⃣ Big5 섹션
                  _buildBig5Section(profile),

                  const SizedBox(height: 32),

                  // 4️⃣ Enneagram 섹션
                  _buildEnneagramSection(profile),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1️⃣ MBTI 성향 분석 섹션 (4글자 결과)
  Widget _buildMbtiTypeSection(PsychologicalProfileResponse? profile) {
    // hasMbti 체크: resultType이 있는지 확인
    if (profile != null && profile.hasMbti) {
      return _buildMbtiSliderSection(profile.mbti!);
    }
    // 데이터 없음 -> 검사 유도
    else {
      return _buildEmptyStateCard(
        title: S.of(context).analysis_mbti_title,
        description: S.of(context).analysis_description,
        icon: Icons.psychology_outlined,
        buttonText: S.of(context).analysis_mbti_btn,
        colors: [const Color(0xFF667EEA), Color(0xFF764BA2)],
        onTap: () {
          print("16인지 분석 이동");
        },
      );
    }
  }


  /// Big5 섹션
  Widget _buildBig5Section(PsychologicalProfileResponse? profile) {
    // 데이터가 있고 유효한 경우
    if (profile != null && profile.hasBig5) {
      return _buildBigFiveSliders(profile.big5!);
    }
    // 데이터가 없는 경우
    else {
      return _buildEmptyStateCard(
        title: S.of(context).analysis_big5_title,
        description: S.of(context).analysis_big5_description,
        icon: Icons.pie_chart_outline,
        buttonText: S.of(context).analysis_big5_btn,
        colors: [const Color(0xFFFF7043), Color(0xFFE64A19)],
        onTap: () {
          // TODO: Big5 검사 페이지로 이동
          print("Big5 검사 이동");
        },
      );
    }
  }

  /// Enneagram 섹션
  Widget _buildEnneagramSection(PsychologicalProfileResponse? profile) {
    if (profile != null && profile.hasEnneagram) {
      // ✅ 실제 데이터 연결
      return _buildTopEnneagramTypes(profile.enneagram!);
    } else {
      return _buildEmptyStateCard(
        title: S.of(context).analysis_eneagram_title,
        description: S.of(context).analysis_eneagram_description,
        icon: Icons.people_outline,
        buttonText: S.of(context).analysis_eneagram_btn,
        colors: [const Color(0xFF4CAF50), Color(0xFF388E3C)],
        onTap: () {
          // TODO: 에니어그램 검사 페이지로 이동
          print("에니어그램 검사 이동");
        },
      );
    }
  }

  // =================================================================
  // 🎨 공통 검사 유도 카드 디자인 (빈 상태 UI)
  // =================================================================
  Widget _buildEmptyStateCard({
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
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
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.first),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: colors.first,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // ➕ 추가된 부분: 데이터가 없을 때 보여줄 Empty State UI
  // =================================================================
  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 64,
                color: Color(0xFF667EEA),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '아직 분석 데이터가 없어요',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '심리 검사를 진행하고 나만의\n정밀한 분석 리포트를 받아보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            // 검사 하러 가기 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 검사 화면으로 이동하는 네비게이션 로직 추가
                  print('검사 화면으로 이동');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: const Color(0xFF667EEA).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '지금 검사하러 가기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // /// 개선된 성격 카드
  // Widget _buildTrendyPersonalityCard() {
  //
  //
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF667EEA).withOpacity(0.25),
  //           blurRadius: 20,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // 상단 헤더
  //         Row(
  //           children: [
  //             Container(
  //               width: 52,
  //               height: 52,
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(14),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   // strongestDimension.icon,
  //                   style: const TextStyle(fontSize: 24),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             const Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     '당신의 특징',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.white70,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(height: 4),
  //                   Text(
  //                     '독창적이지만 고집스러운 예술가',
  //                     style: TextStyle(
  //                       fontSize: 17,
  //                       fontWeight: FontWeight.w700,
  //                       color: Colors.white,
  //                       height: 1.2,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 18),
  //
  //         // 평가 텍스트
  //         Container(
  //           padding: const EdgeInsets.all(18),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(14),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 '남들과 다른 독특한 시각으로 세상을 바라보며, 자신만의 신념과 가치관이 뚜렷한 사람이에요.',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.white,
  //                   height: 1.4,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               const SizedBox(height: 6),
  //               Text(
  //                 '때로는 고집스러워 보일 수 있지만, 그것이 당신만의 매력이자 창작의 원동력입니다.',
  //                 style: TextStyle(
  //                   fontSize: 13,
  //                   color: Colors.white.withOpacity(0.9),
  //                   height: 1.4,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // /// 더 작은 태그들
  // Widget _buildCompactTags() {
  //   final topTags = _analysisData.personalityTags.take(5).toList();
  //
  //   return Wrap(
  //     spacing: 6,
  //     runSpacing: 6,
  //     children: topTags.map((tag) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //         decoration: BoxDecoration(
  //           color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.12),
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(
  //             color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.3),
  //           ),
  //         ),
  //         child: Text(
  //           '#${tag.name}',
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: Color(int.parse(tag.color, radix: 16)),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  /// MBTI 슬라이더 섹션 (이미지와 같은 디자인)
  Widget _buildMbtiSliderSection(MbtiStats mbti) {
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
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // 1. 제목
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 24),
               Text(
                S.of(context).analysis_mbti_data,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4), // 제목과 결과 사이 간격

          // 2. 결과 타입 표시 (아래로 이동됨)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // 내용물 크기만큼만 차지
              children: [

                Text(
                  mbti.resultType!, // ✅ 실제 데이터 (예: INFP)
                  style: const TextStyle(
                    fontSize: 15, // 강조를 위해 폰트 살짝 키움
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF667EEA),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4가지 지표 수동 호출 (DTO 필드 -> 슬라이더)
          // 점수(0~100)를 그대로 전달
          // 1. E vs I (서버값: E점수) -> 그대로 사용
          _buildImageStyleSlider('E', 'I', mbti.energyScore, 'E/I'),

// 2. S vs N (서버값: N점수) -> 100에서 빼서 S점수로 변환
          _buildImageStyleSlider('S', 'N', 100 - mbti.informationScore, 'S/N'),

// 3. T vs F (서버값: F점수) -> 100에서 빼서 T점수로 변환
          _buildImageStyleSlider('T', 'F', 100 - mbti.decisionScore, 'T/F'),

// 4. J vs P (서버값: P점수) -> 100에서 빼서 J점수로 변환
          _buildImageStyleSlider('J', 'P', 100 - mbti.lifestyleScore, 'J/P'),
        ],
      ),
    );
  }

  Widget _buildImageStyleSlider(
      String left,
      String right,
      int score, // ⚠️ 왼쪽(left) 성향의 점수 (0~100)
      String dimension,
      ) {
    // 1. 로직 계산
    // 점수가 50 이상이면 왼쪽(left) 성향이 우세, 미만이면 오른쪽(right) 성향이 우세
    final bool isLeftDominant = score >= 50;

    // 2. 화면에 표시할 퍼센트 (항상 50% 이상으로 표시)
    // 예: 70점 -> 70% (왼쪽), 30점 -> 70% (오른쪽이 70이니까)
    final int displayPercent = isLeftDominant ? score : (100 - score);

    // 3. 중앙(50)에서 얼마나 떨어져 있는지 비율 계산 (0.0 ~ 1.0)
    // 예: 70점 -> 차이 20 -> 20/50 = 0.4 (40% 길이)
    final double fillRatio = (score - 50).abs() / 50.0;

    // 색상 정의 (기존 유지)
    Color getSliderColor() {
      switch (dimension) {
        case 'E/I': return const Color(0xFFE91E63);
        case 'S/N': return const Color(0xFF2196F3);
        case 'T/F': return const Color(0xFFFFC107);
        case 'J/P': return const Color(0xFF4CAF50);
        default: return const Color(0xFF667EEA);
      }
    }

    // 타입 설명 맵핑 (기존 유지)
    String getTypeDesc(String type) {
       final map = {
        'E': S.of(context).analysis_mbti_e, 'I': S.of(context).analysis_mbti_i,
        'S': S.of(context).analysis_mbti_s, 'N': S.of(context).analysis_mbti_n,
        'T': S.of(context).analysis_mbti_t, 'F': S.of(context).analysis_mbti_f,
        'J': S.of(context).analysis_mbti_j, 'P': S.of(context).analysis_mbti_p,
      };
      return map[type] ?? '';
    }

    final activeColor = getSliderColor();
    final inactiveColor = const Color(0xFFE2E8F0); // 회색 (비활성 트랙)
    final labelInactiveColor = const Color(0xFF94A3B8); // 회색 (비활성 텍스트)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 라벨들 (좌우 배치)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 왼쪽 라벨
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isLeftDominant ? activeColor : labelInactiveColor,
                    ),
                  ),
                  Text(
                    getTypeDesc(left),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isLeftDominant ? activeColor.withOpacity(0.8) : labelInactiveColor,
                    ),
                  ),
                ],
              ),
            ),

            // 중앙 퍼센트 (선택사항: 중앙에 점수 표시)
            Text(
              '$displayPercent%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: activeColor,
              ),
            ),

            // 오른쪽 라벨
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: !isLeftDominant ? activeColor : labelInactiveColor,
                    ),
                  ),
                  Text(
                    getTypeDesc(right),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: !isLeftDominant ? activeColor.withOpacity(0.8) : labelInactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 2. 중앙 기준 슬라이더 (핵심 변경 부분)
        Container(
          height: 10, // 기존 6보다 약간 키워서 잘 보이게
          width: double.infinity,
          decoration: BoxDecoration(
            color: inactiveColor, // 배경 트랙 색상
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              // 중앙선 (기준점)
              Align(
                alignment: Alignment.center,
                child: Container(width: 2, color: Colors.white),
              ),

              // 게이지 바 (Row로 반반 나눠서 처리)
              Row(
                children: [
                  // [왼쪽 영역] (0~50 구간)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight, // 오른쪽(중앙)에서 시작해서 왼쪽으로 뻗음
                      child: FractionallySizedBox(
                        // 왼쪽이 우세할 때만 길이 가짐
                        widthFactor: isLeftDominant ? fillRatio.clamp(0.0, 1.0) : 0.0,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: activeColor,
                            // 왼쪽 끝만 둥글게
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // [오른쪽 영역] (50~100 구간)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, // 왼쪽(중앙)에서 시작해서 오른쪽으로 뻗음
                      child: FractionallySizedBox(
                        // 오른쪽이 우세할 때만 길이 가짐
                        widthFactor: !isLeftDominant ? fillRatio.clamp(0.0, 1.0) : 0.0,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: activeColor,
                            // 오른쪽 끝만 둥글게
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // }

  /// Big 5 성격지표 슬라이더
  Widget _buildBigFiveSliders(Big5Stats big5) {
    // Big 5를 위한 더미 데이터 (기존 personalityDimensions를 변환)
    final bigFiveData = [
      {
        'name': '신경성 (Neuroticism)',
        'leftLabel': S.of(context).analysis_big5_n_low,
        'rightLabel': S.of(context).analysis_big5_n_high,
        'score': big5.neuroticism.toDouble(),
        'color': const Color(0xFFEF5350),
      },
      {
        'name': '외향성 (Extraversion)',
        'leftLabel': S.of(context).analysis_big5_e_low,
        'rightLabel': S.of(context).analysis_big5_n_high,
        'score': big5.extraversion.toDouble(),
        'color': const Color(0xFF42A5F5),
      },
      {
        'name': '개방성 (Openness)',
        'leftLabel': S.of(context).analysis_big5_o_low,
        'rightLabel': S.of(context).analysis_big5_n_high,
        'score': big5.openness.toDouble(),
        'color': const Color(0xFFAB47BC),
      },
      {
        'name': '친화성 (Agreeableness)',
        'leftLabel': S.of(context).analysis_big5_a_low,
        'rightLabel': S.of(context).analysis_big5_a_high,
        'score': big5.agreeableness.toDouble(),
        'color': const Color(0xFF66BB6A),
      },
      {
        'name': '성실성 (Conscientiousness)',
        'leftLabel': S.of(context).analysis_big5_c_low,
        'rightLabel': S.of(context).analysis_big5_c_high,
        'score': big5.conscientiousness.toDouble(),
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
              ),
              const SizedBox(width: 12),
              Text(
                S.of(context).analysis_big5_data,
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
                alignment: isRightDominant
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
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

  Widget _buildTopEnneagramTypes(EnneagramStats stats) {
    // ⚠️ 매개변수 변경

    print("애니어 그램 프로필에 도착했음");
    // 1. 데이터를 리스트로 변환 (번호, 점수)
    List<Map<String, dynamic>> typeScores = [
      {'num': 1, 'score': stats.type1},
      {'num': 2, 'score': stats.type2},
      {'num': 3, 'score': stats.type3},
      {'num': 4, 'score': stats.type4},
      {'num': 5, 'score': stats.type5},
      {'num': 6, 'score': stats.type6},
      {'num': 7, 'score': stats.type7},
      {'num': 8, 'score': stats.type8},
      {'num': 9, 'score': stats.type9},
    ];

    // 2. 점수 높은 순으로 정렬
    typeScores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    // 3. 상위 3개 추출
    final top3 = typeScores.take(3).toList();

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
          // 헤더 (기존 동일)
          Row(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9575CD), Color(0xFF5E35B1)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        S.of(context).analysis_eneagram_data,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  // 결과 타입 표시 (예: 7w6)
                  Text(
                    S.of(context).analysis_eneagram_mydata(stats.resultType!), //"나의 유형: ${stats.resultType}"
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🚀 [수정] 상위 3개 유형 렌더링 (포디움 배치: 2위 - 1위 - 3위)
          if (top3.length >= 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              crossAxisAlignment: CrossAxisAlignment.end,  // 바닥 라인 기준 정렬
              children: [
                // 🥈 왼쪽: 2순위 (Wing 후보) - 중간 크기
                _buildTypeItem(top3[1], size: 60, label: "Wing"),

                const SizedBox(width: 24), // 간격

                // 🥇 가운데: 1순위 (Main) - 가장 큼 & 위로 솟음
                Transform.translate(
                  offset: const Offset(0, -15), // 위로 살짝 올림
                  child: _buildTypeItem(top3[0], size: 85, isMain: true, label: "Main"),
                ),

                const SizedBox(width: 24), // 간격

                // 🥉 오른쪽: 3순위 - 중간 크기
                _buildTypeItem(top3[2], size: 60, label: "3rd"),
              ],
            ),
        ],
      ),
    );
  }
  Widget _buildTypeItem(Map<String, dynamic> data, {
    required double size,
    bool isMain = false,
    String? label,
  }) {
    final int typeNum = data['num'];
    final int score = data['score'];

    // 🚀 1. 메타데이터 안전하게 가져오기 (타입 오류 수정)
    final meta = _enneagramMetadata[typeNum] ?? {};
    final Color color = meta['color'] as Color? ?? Colors.grey;
    final String name = meta['name'] as String? ?? '알 수 없음';

    // 💡 핵심 수정: String이 아닌 IconData로 변환해서 받습니다.
    final IconData iconData = meta['emoji'] as IconData? ?? Icons.help_outline;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 라벨 (Main/Wing 표시)
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isMain ? color : Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ),

        // 2. 원형 그래프
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: isMain ? 12 : 6,
                offset: Offset(0, isMain ? 6 : 3),
              ),
            ],
            // 메인이면 테두리 추가해서 강조
            border: isMain ? Border.all(color: Colors.white, width: 3) : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🚀 2. Text 위젯을 Icon 위젯으로 변경
                Icon(
                  iconData,
                  size: size * 0.35, // 크기에 비례
                  color: Colors.white, // 배경이 그라데이션 컬러이므로 아이콘은 흰색이 예쁩니다
                ),

                const SizedBox(height: 2), // 아이콘과 퍼센트 사이 간격 살짝 추가

                Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: size * 0.18, // 크기에 비례
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 3. 유형 번호
        Text(
          '${typeNum} type',
          style: TextStyle(
            fontSize: isMain ? 14 : 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),

        // 4. 유형 이름
        Text(
          name,
          style: TextStyle(
            fontSize: isMain ? 12 : 11,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
          '${function.strength.toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          function.type.displayName,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );
  }



}
