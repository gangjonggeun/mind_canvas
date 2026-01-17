import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dto/psychological_profile_response.dart';
import '../domain/entities/analysis_data.dart';
import '../analysis_sample_data.dart';
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

  final AnalysisData _analysisData = AnalysisSampleData.sampleAnalysisData;

  // 에니어그램 UI 메타데이터 (유형 1~9)
  final Map<int, Map<String, dynamic>> _enneagramMetadata = {
    1: {'name': '개혁가', 'emoji': '📏', 'color': Color(0xFFEF5350)}, // Red
    2: {'name': '조력가', 'emoji': '❤️', 'color': Color(0xFFAB47BC)}, // Purple
    3: {'name': '성취가', 'emoji': '🏆', 'color': Color(0xFFFFA726)}, // Orange
    4: {
      'name': '예술가',
      'emoji': '🎨',
      'color': Color(0xFF7E57C2),
    }, // Deep Purple
    5: {'name': '탐구자', 'emoji': '🔍', 'color': Color(0xFF42A5F5)}, // Blue
    6: {'name': '충실가', 'emoji': '🛡️', 'color': Color(0xFF26C6DA)}, // Cyan
    7: {'name': '열정가', 'emoji': '🎉', 'color': Color(0xFFD4E157)}, // Lime
    8: {
      'name': '도전가',
      'emoji': '🔥',
      'color': Color(0xFFFF7043),
    }, // Deep Orange
    9: {'name': '평화주의자', 'emoji': '🌿', 'color': Color(0xFF66BB6A)}, // Green
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
              child: const Text('다시 시도'),
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
            _buildTrendyAppBar(),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1️⃣ MBTI 섹션
                  _buildMbtiTypeSection(profile),

                  const SizedBox(height: 32),

                  // 2️⃣ 8기능 섹션
                  _buildCognitiveSection(profile),

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
        title: "16인지 분석",
        description: "나의 에너지는 어디로 향할까요?\n4가지 지표를 통해 나의 성격 유형을 알아보세요.",
        icon: Icons.psychology_outlined,
        buttonText: "성향 분석 하러가기",
        colors: [const Color(0xFF667EEA), Color(0xFF764BA2)],
        onTap: () {
          print("MBTI 성향 검사 이동");
        },
      );
    }
  }

  /// 2️⃣ 8기능(인지기능) 분석 섹션 (Se, Si, Ne...)
  Widget _buildCognitiveSection(PsychologicalProfileResponse? profile) {
    // hasCognitiveFunctions 체크: 8기능 점수 합이 0보다 큰지 확인
    if (profile != null && profile.hasCognitiveFunctions) {
      // ⚠️ 변경점: mbti 객체가 아닌 cognitiveFunctions 객체를 전달
      return _buildTopCognitiveFunctions(profile.cognitiveFunctions!);
    }
    // 데이터 없음 -> 검사 유도
    else {
      return _buildEmptyStateCard(
        title: "페르소나 테스트",
        description: "내가 무의식적으로 사용하는 기능은 무엇일까요?\n나의 사고 방식과 행동 패턴의 원인을 찾아보세요.",
        icon: Icons.lightbulb_outline,
        buttonText: "페르소나 테스트 하러가기",
        colors: [const Color(0xFF9C27B0), Color(0xFF673AB7)],
        // 보라색 계열
        onTap: () {
          print("8기능 검사 이동");
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
        title: "Big 5 성격 분석",
        description: "심리학계에서 가장 신뢰받는 5가지 성격 요인을 통해\n나의 본질적인 성향을 파악해보세요.",
        icon: Icons.pie_chart_outline,
        buttonText: "Big 5 검사하기",
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
        title: "9가지 성격 유형",
        description: "9가지 성격 유형 중 나는 어디에 속할까요?\n나의 무의식적인 동기와 행동 패턴을 발견하세요.",
        icon: Icons.people_outline,
        buttonText: "9가지 성격 유형 검사하기",
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

  /// 개선된 트렌디한 앱바
  Widget _buildTrendyAppBar() {
    return SliverAppBar(
      expandedHeight: 120, // 아이콘이 빠져서 높이를 살짝 줄임 (140 -> 120)
      floating: false,
      pinned: true,
      elevation: 0,
      // 배경색 (다크모드 대응 필요시 조건문 추가)
      backgroundColor: const Color(0xFFF8FAFC),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ 아이콘 제거됨, 텍스트만 깔끔하게 배치
                Text(
                  '나의 성격 분석',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '심리테스트를 할수록 정확해지는 분석',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
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
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
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
          const Text(
            '16 인지기능 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
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
      const map = {
        'E': '외향형', 'I': '내향형',
        'S': '감각형', 'N': '직관형',
        'T': '사고형', 'F': '감정형',
        'J': '판단형', 'P': '인식형',
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

  // Widget _buildMbtiSlider(MbtiScore score) {
  //   // 기존 함수를 새로운 스타일로 대체
  //   return _buildImageStyleSlider(score);
  // }
  //
  // /// 이미지와 같은 스타일의 슬라이더
  // Widget _buildImageStyleSlider(
  //   String left,
  //   String right,
  //   int score,
  //   String dimension,
  // ) {
  //   // 점수가 50보다 크면 오른쪽 성향이 우세하다고 판단
  //   final isRightDominant = score > 50;
  //   // 시각적 퍼센트 (오른쪽 우세면 점수 그대로, 왼쪽 우세면 100-점수)
  //   final percentage = isRightDominant
  //       ? score.toDouble()
  //       : (100 - score).toDouble();
  //
  //   // 색상 정의
  //   Color getSliderColor() {
  //     switch (dimension) {
  //       case 'E/I':
  //         return const Color(0xFFE91E63); // 핑크
  //       case 'S/N':
  //         return const Color(0xFF2196F3); // 블루
  //       case 'T/F':
  //         return const Color(0xFFFFC107); // 옐로우
  //       case 'J/P':
  //         return const Color(0xFF4CAF50); // 그린
  //       default:
  //         return const Color(0xFF667EEA);
  //     }
  //   }
  //
  //   // 타입 설명 맵핑
  //   String getTypeDesc(String type) {
  //     const map = {
  //       'E': '외향형',
  //       'I': '내향형',
  //       'S': '감각형',
  //       'N': '직관형',
  //       'T': '사고형',
  //       'F': '감정형',
  //       'J': '판단형',
  //       'P': '인식형',
  //     };
  //     return map[type] ?? '';
  //   }
  //
  //   final sliderColor = getSliderColor();
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // 라벨들 (이니셜 + 설명)
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           // 왼쪽 라벨
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   left,
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w700,
  //                     color: !isRightDominant
  //                         ? sliderColor
  //                         : const Color(0xFF94A3B8),
  //                   ),
  //                 ),
  //                 Text(
  //                   getTypeDesc(left),
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: !isRightDominant
  //                         ? sliderColor.withOpacity(0.8)
  //                         : const Color(0xFF94A3B8),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // 오른쪽 라벨
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   right,
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w700,
  //                     color: isRightDominant
  //                         ? sliderColor
  //                         : const Color(0xFF94A3B8),
  //                   ),
  //                 ),
  //                 Text(
  //                   getTypeDesc(right),
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: isRightDominant
  //                         ? sliderColor.withOpacity(0.8)
  //                         : const Color(0xFF94A3B8),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       const SizedBox(height: 16),
  //
  //       // 슬라이더 트랙
  //       Container(
  //         height: 6,
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFE2E8F0),
  //           borderRadius: BorderRadius.circular(3),
  //         ),
  //         child: Stack(
  //           children: [
  //             // 진행 바
  //             FractionallySizedBox(
  //               alignment: isRightDominant
  //                   ? Alignment.centerRight
  //                   : Alignment.centerLeft,
  //               widthFactor: percentage / 100,
  //               child: Container(
  //                 height: 6,
  //                 decoration: BoxDecoration(
  //                   color: sliderColor,
  //                   borderRadius: BorderRadius.circular(3),
  //                 ),
  //               ),
  //             ),
  //             // 슬라이더 노브 (점)
  //             Positioned(
  //               left: isRightDominant
  //                   ? null
  //                   : (percentage / 100) *
  //                             (MediaQuery.of(context).size.width - 88) -
  //                         4,
  //               right: isRightDominant
  //                   ? (100 - percentage) /
  //                             100 *
  //                             (MediaQuery.of(context).size.width - 88) -
  //                         4
  //                   : null,
  //               top: -2,
  //               child: Container(
  //                 width: 10,
  //                 height: 10,
  //                 decoration: BoxDecoration(
  //                   color: sliderColor,
  //                   shape: BoxShape.circle,
  //                   border: Border.all(color: Colors.white, width: 2),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: sliderColor.withOpacity(0.3),
  //                       blurRadius: 4,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //       const SizedBox(height: 8),
  //
  //       // 퍼센트 표시
  //       Center(
  //         child: Text(
  //           '${percentage.toInt()}%',
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: sliderColor,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildImageStyleSlider(
  //     String leftType,
  //     String rightType,
  //     int leftScore, // 무조건 왼쪽 타입(E,S,T,J)의 점수 (0~100)
  //     String dimension,
  //     ) {
  //   // 1. 누가 우세한지 판단
  //   final bool isLeftDominant = leftScore >= 50;
  //
  //   // 2. 화면에 표시할 숫자 (큰 쪽 점수)
  //   // 예: 70점 -> 70%, 30점 -> 70%(I가 70이니까)
  //   final int displayPercent = isLeftDominant ? leftScore : (100 - leftScore);
  //
  //   // 3. 중앙(50)에서 얼마나 떨어져 있는지 계산 (그래프 길이용)
  //   // 예: 70점 -> 20차이, 100점 -> 50차이
  //   final int difference = (leftScore - 50).abs();
  //
  //   // 4. 반쪽짜리 트랙 안에서의 비율 계산 (최대 50이니까 50으로 나눔)
  //   // 예: 차이가 20이면 -> 20/50 = 0.4 (40% 채움)
  //   final double fillPercent = (difference / 50.0).clamp(0.0, 1.0);
  //
  //   // 색상 정의
  //   Color getSliderColor() {
  //     switch (dimension) {
  //       case 'E/I': return const Color(0xFFE91E63);
  //       case 'S/N': return const Color(0xFF2196F3);
  //       case 'T/F': return const Color(0xFFFFC107);
  //       case 'J/P': return const Color(0xFF4CAF50);
  //       default: return const Color(0xFF667EEA);
  //     }
  //   }
  //
  //   final activeColor = getSliderColor();
  //   final inactiveColor = const Color(0xFFE2E8F0); // 트랙 배경색
  //
  //   return Column(
  //     children: [
  //       // 상단 라벨 (텍스트)
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(leftType,
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isLeftDominant ? activeColor : Colors.grey)),
  //           Text('$displayPercent%',
  //               style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                   color: activeColor)),
  //           Text(rightType,
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: !isLeftDominant ? activeColor : Colors.grey)),
  //         ],
  //       ),
  //
  //       const SizedBox(height: 8),
  //
  //       // 🔥 중앙 기준 그래프
  //       Container(
  //         height: 10,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: inactiveColor,
  //           borderRadius: BorderRadius.circular(5),
  //         ),
  //         child: Stack(
  //           children: [
  //             // 중앙선 (기준점)
  //             Align(
  //               alignment: Alignment.center,
  //               child: Container(width: 2, color: Colors.white),
  //             ),
  //
  //             // 게이지 (Row로 반반 나눠서 처리)
  //             Row(
  //               children: [
  //                 // [왼쪽 영역]
  //                 Expanded(
  //                   child: Align(
  //                     alignment: Alignment.centerRight, // 중앙에서 시작
  //                     child: FractionallySizedBox(
  //                       // 왼쪽 우세일 때만 길이 있음
  //                       widthFactor: isLeftDominant ? fillPercent : 0.0,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: activeColor,
  //                           borderRadius: const BorderRadius.horizontal(
  //                               left: Radius.circular(5)),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 // [오른쪽 영역]
  //                 Expanded(
  //                   child: Align(
  //                     alignment: Alignment.centerLeft, // 중앙에서 시작
  //                     child: FractionallySizedBox(
  //                       // 오른쪽 우세일 때만 길이 있음
  //                       widthFactor: !isLeftDominant ? fillPercent : 0.0,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: activeColor,
  //                           borderRadius: const BorderRadius.horizontal(
  //                               right: Radius.circular(5)),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // /// 인지기능 상위 3개
  // Widget _buildTopCognitiveFunctions() {
  //   final topFunctions = _analysisData.cognitiveFunctions
  //       .where((f) => f.strength > 50)
  //       .toList()
  //       ..sort((a, b) => b.strength.compareTo(a.strength));
  //
  //   final displayFunctions = topFunctions.take(3).toList();
  //
  //   // 인지기능 설명 맵
  //   Map<String, String> getFunctionDescription(String shortName) {
  //     switch (shortName) {
  //       case 'Te': return {'name': '외향 사고', 'desc': '효율적 조직화'};
  //       case 'Ti': return {'name': '내향 사고', 'desc': '논리적 분석'};
  //       case 'Fe': return {'name': '외향 감정', 'desc': '타인 배려'};
  //       case 'Fi': return {'name': '내향 감정', 'desc': '개인적 가치'};
  //       case 'Se': return {'name': '외향 감각', 'desc': '현재 경험'};
  //       case 'Si': return {'name': '내향 감각', 'desc': '과거 기억'};
  //       case 'Ne': return {'name': '외향 직관', 'desc': '가능성 탐색'};
  //       case 'Ni': return {'name': '내향 직관', 'desc': '미래 통찰'};
  //       default: return {'name': '알 수 없음', 'desc': ''};
  //     }
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 20,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                 gradient: const LinearGradient(
  //                   colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
  //                 ),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(
  //                 Icons.lightbulb_outline,
  //                 color: Colors.white,
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             const Text(
  //               '인지기능 패턴',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w700,
  //                 color: Color(0xFF1E293B),
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 4),
  //         const Text(
  //           '당신이 가장 자주 사용하는 사고 방식입니다',
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: Color(0xFF64748B),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 20),
  //
  //         // 상위 3개 기능 (설명 추가)
  //         Row(
  //           children: displayFunctions.map((function) {
  //             final color = Color(int.parse(function.color, radix: 16));
  //             final functionInfo = getFunctionDescription(function.shortName);
  //
  //             return Expanded(
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     width: 60,
  //                     height: 60,
  //                     decoration: BoxDecoration(
  //                       color: color.withOpacity(0.1),
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: color, width: 3),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         function.shortName,
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w700,
  //                           color: color,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     functionInfo['name']!,
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w600,
  //                       color: color,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   Text(
  //                     functionInfo['desc']!,
  //                     style: const TextStyle(
  //                       fontSize: 10,
  //                       color: Color(0xFF64748B),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     '${function.strength.toInt()}%',
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w700,
  //                       color: color,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopCognitiveFunctions(CognitiveStats cognitive) {
    // 1. DTO 필드를 리스트로 변환
    final allFunctions = [
      {'code': 'Se', 'score': cognitive.se, 'color': '0xFFF44336'},
      {'code': 'Si', 'score': cognitive.si, 'color': '0xFFE91E63'},
      {'code': 'Ne', 'score': cognitive.ne, 'color': '0xFF9C27B0'},
      {'code': 'Ni', 'score': cognitive.ni, 'color': '0xFF673AB7'},
      {'code': 'Te', 'score': cognitive.te, 'color': '0xFF3F51B5'},
      {'code': 'Ti', 'score': cognitive.ti, 'color': '0xFF2196F3'},
      {'code': 'Fe', 'score': cognitive.fe, 'color': '0xFF009688'},
      {'code': 'Fi', 'score': cognitive.fi, 'color': '0xFF4CAF50'},
    ];

    // 2. 점수 기준 내림차순 정렬 후 상위 3개 추출
    allFunctions.sort(
      (a, b) => (b['score'] as int).compareTo(a['score'] as int),
    );
    final topFunctions = allFunctions.take(3).toList();

    // 인지기능 설명 맵
    Map<String, String> getFunctionDescription(String shortName) {
      switch (shortName) {
        case 'Te':
          return {'name': '외향 사고', 'desc': '효율적 실행'};
        case 'Ti':
          return {'name': '내향 사고', 'desc': '논리적 분석'};
        case 'Fe':
          return {'name': '외향 감정', 'desc': '타인 공감'};
        case 'Fi':
          return {'name': '내향 감정', 'desc': '내면 가치'};
        case 'Se':
          return {'name': '외향 감각', 'desc': '현재 경험'};
        case 'Si':
          return {'name': '내향 감각', 'desc': '과거 경험'};
        case 'Ne':
          return {'name': '외향 직관', 'desc': '다양한 가능성'};
        case 'Ni':
          return {'name': '내향 직관', 'desc': '미래 통찰'};
        default:
          return {'name': '-', 'desc': '-'};
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
          // 헤더 (아이콘 제거)
          const Text(
            '핵심 페르소나',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '당신이 무의식적으로 가장 잘 쓰는 기능들',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          // 상위 3개 기능 렌더링
          Row(
            children: topFunctions.map((function) {
              final color = Color(int.parse(function['color'] as String));
              final code = function['code'] as String;
              final score = function['score'] as int;
              final info = getFunctionDescription(code);

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
                          code,
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
                      info['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      info['desc']!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score%',
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
  Widget _buildBigFiveSliders(Big5Stats big5) {
    // Big 5를 위한 더미 데이터 (기존 personalityDimensions를 변환)
    final bigFiveData = [
      {
        'name': '신경성 (Neuroticism)',
        'leftLabel': '안정적인',
        'rightLabel': '민감한',
        'score': big5.neuroticism.toDouble(),
        'color': const Color(0xFFEF5350),
      },
      {
        'name': '외향성 (Extraversion)',
        'leftLabel': '내향적인',
        'rightLabel': '외향적인',
        'score': big5.extraversion.toDouble(),
        'color': const Color(0xFF42A5F5),
      },
      {
        'name': '개방성 (Openness)',
        'leftLabel': '보수적인',
        'rightLabel': '개방적인',
        'score': big5.openness.toDouble(),
        'color': const Color(0xFFAB47BC),
      },
      {
        'name': '친화성 (Agreeableness)',
        'leftLabel': '경쟁적인',
        'rightLabel': '협력적인',
        'score': big5.agreeableness.toDouble(),
        'color': const Color(0xFF66BB6A),
      },
      {
        'name': '성실성 (Conscientiousness)',
        'leftLabel': '즉흥적인',
        'rightLabel': '계획적인',
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

  /// 에니어그램 상위 3개
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
                  const Text(
                    '9가지 성격 유형',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  // 결과 타입 표시 (예: 7w6)
                  Text(
                    "나의 유형: ${stats.mainType}",
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

          // 상위 3개 유형 렌더링
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 간격 균등 배치
            children: top3.map((data) {
              final int typeNum = data['num'];
              final int score = data['score'];

              // 메타데이터 가져오기
              final meta = _enneagramMetadata[typeNum]!;
              final Color color = meta['color'];
              final String name = meta['name'];
              final String emoji = meta['emoji'];

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
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
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 2),
                            Text(
                              '$score%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${typeNum}번',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
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
                child: _buildCognitiveFunctionCircle(
                  _analysisData.cognitiveFunctions[0],
                ),
              ),
              Expanded(
                child: _buildCognitiveFunctionCircle(
                  _analysisData.cognitiveFunctions[1],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCognitiveFunctionCircle(
                  _analysisData.cognitiveFunctions[2],
                ),
              ),
              Expanded(
                child: _buildCognitiveFunctionCircle(
                  _analysisData.cognitiveFunctions[3],
                ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
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
