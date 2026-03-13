import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

// ✅ 사용자가 정의한 Entity import
import '../../../../generated/l10n.dart';
import '../../domain/entities/psy_result.dart';

class PsyResultScreen2 extends ConsumerStatefulWidget {
  final PsyResult result;

  const PsyResultScreen2({Key? key, required this.result}) : super(key: key);

  @override
  ConsumerState<PsyResultScreen2> createState() => _PsyResultScreenState();
}

class _PsyResultScreenState extends ConsumerState<PsyResultScreen2>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimController;
  late String _randomLottieFile;

  // 🎨 차트용 색상 팔레트 (파스텔톤 & 비비드 조합)
  final List<Color> _chartColors = [
    const Color(0xFFD4C9FF), // 소프트 퍼플
    const Color(0xFFA7E9E1), // 프레쉬 민트
    const Color(0xFFFFD1D1), // 살구 핑크
    const Color(0xFFFFE8A3), // 부드러운 옐로우
    const Color(0xFFB5DEFF), // 스카이 블루
    const Color(0xFFC9F2C7), // 애플 그린
    const Color(0xFFFFC4EB), // 버블껌 핑크
    const Color(0xFFD1EAFF), // 아이스 블루
  ];

  // 📂 가지고 계신 Lottie 파일 목록 (여기에 파일명을 다 적어주세요)
  final List<String> _lottieList = [
    'assets/lottie/book.json',
    'assets/lottie/cat.json',
    'assets/lottie/flower.json',
    'assets/lottie/rocket.json',
    'assets/lottie/smartphone.json',
    'assets/lottie/globe.json',
    'assets/lottie/game.json',
    'assets/lottie/search.json',
    // ... 추가 파일들
  ];

  @override
  void initState() {
    super.initState();
    // 차트 애니메이션용 컨트롤러
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // 🎲 화면이 생성될 때 리스트에서 랜덤으로 하나 뽑기
    if (_lottieList.isNotEmpty) {
      _randomLottieFile = _lottieList[Random().nextInt(_lottieList.length)];
    } else {
      // 리스트가 비어있을 경우를 대비한 기본값
      _randomLottieFile = 'assets/lottie/flower.json';
    }
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다크모드 대응 및 기본 배경색 설정
    final bgColor = const Color(0xFFF8F9FA); // 아주 연한 회색 (카드 돋보이게)

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1️⃣ [수정] 앱바는 고정(Pinned)만 하고, 내용은 뺍니다.
          SliverAppBar(
            pinned: true,
            backgroundColor: widget.result.mainColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: widget.result.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // 스크롤 올렸을 때만 보이는 제목
            title: Text(
              widget.result.title,
              style: TextStyle(
                color: widget.result.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 1️⃣ 상단 헤더 (제목 + Lottie + 요약)
          _buildAdaptiveHeader(),

          // 2️⃣ 차트 영역 (데이터가 있을 때만 표시)
          if (widget.result.hasDimensionScores) _buildPolarChartSection(),

          // 3️⃣ 결과 상세 카드 리스트 제목
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                S.of(context).psy_result_show_detail,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // 4️⃣ 결과 상세 카드 리스트
          _buildDetailList(),

          // 하단 여백 (버튼에 가려지지 않게)
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      // 5️⃣ 하단 고정 버튼 (공유 / 확인)
      bottomSheet: _buildBottomActions(context),
    );
  }

  Widget _buildAdaptiveHeader() {
    final result = widget.result;
    final mainColor = result.mainColor;
    final textColor = result.textColor;

    return SliverToBoxAdapter(
      child: Container(
        color: mainColor,
        child: Column(
          children: [
            // Stack을 사용하여 Lottie와 텍스트를 분리 배치
            Stack(
              children: [
                // 1. 텍스트 콘텐츠 영역
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  // 상단 패딩을 줄임 (60 -> 20)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✨ [태그] 제목 바로 위
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          result.type.displayName,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // ✨ [제목] 태그와 함께 위로 올라감
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.55, // Lottie와 겹치지 않게 너비 제한
                        child: Text(
                          result.title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // [요약 설명]
                      if (result.subtitle.isNotEmpty)
                        Text(
                          result.subtitle,
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // 2. [Lottie] 우측 상단에 고정 (텍스트 위치에 영향을 주지 않음)
                Positioned(
                  top: 0,
                  right: 16,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      _randomLottieFile,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.public,
                          size: 40, color: Colors.white24),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 둥근 마감부 (Body와 연결)
            Container(
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🟢 1. 헤더 영역 (제목 + Lottie)
  Widget _buildHeader() {
    final result = widget.result;
    final mainColor = result.mainColor;
    final textColor = result.textColor;

    return SliverAppBar(
      expandedHeight: 280.0,
      floating: false,
      pinned: true,
      backgroundColor: mainColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // 배경 그라데이션 (선택 사항)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    mainColor,
                    Color(int.parse('FF${result.bgGradientEnd}', radix: 16)),
                  ],
                ),
              ),
            ),

            // 🎈 Lottie 애니메이션 (우측 상단, 작게)
            Positioned(
              top: 60,
              right: 20,
              child: SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  _randomLottieFile,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Icon(
                    Icons.public,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            // 📝 텍스트 내용
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 태그 (Result Type)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result.type.displayName,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 제목
                  Text(
                    result.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 요약 (Subtitle)
                  if (result.subtitle.isNotEmpty)
                    Text(
                      result.subtitle,
                      style: TextStyle(
                        color: textColor.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 하단 둥글게 처리
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA), // 바디 배경색과 일치
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolarChartSection() {
    final scores = widget.result.translatedScores;
    final keys = scores.keys.toList();
    final values = scores.values.map((e) => e.toDouble()).toList();

    if (keys.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 범례
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(keys.length, (index) {
                return _Indicator(
                  color: _chartColors[index % _chartColors.length],
                  text: keys[index],
                  isSquare: false,
                  size: 12,
                  textColor: Colors.grey[600]!,
                );
              }),
            ),
            const SizedBox(height: 40),

            SizedBox(
              height: 280,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                  startDegreeOffset: 270,
                  sections: List.generate(keys.length, (i) {
                    final value = values[i];
                    final color = _chartColors[i % _chartColors.length];

                    // ✨ [보정 로직] 낮은 점수도 너무 작아지지 않게 기본값(50)을 높게 잡음
                    final double radius = 50.0 + (value * 0.9);

                    return PieChartSectionData(
                      color: color,
                      value: 1,
                      title: '${value.toInt()}',
                      radius: radius,
                      titlePositionPercentageOffset: 0.7,
                      // 숫자를 살짝 안쪽으로
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black12, blurRadius: 4)],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📝 3. 상세 리스트 (카드 형태)
  Widget _buildDetailList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final section = widget.result.sections[index];
        return _buildResultCard(section, index);
      }, childCount: widget.result.sections.length),
    );
  }

  /// 개별 카드 위젯
  Widget _buildResultCard(PsyResultSection section, int index) {
    // 🖼️ 이미지 결정 로직
    // 1. 서버 이미지가 있으면 사용
    // 2. 없으면 키워드 매칭 로컬 이미지
    // 3. 그것도 없으면 텍스트만 표시

    Widget? imageWidget;
    if (section.hasImage && section.imageUrl != null) {
      imageWidget = GestureDetector(
        // 💡 클릭하면 크게 보기 기능 추가 가능
        onTap: () => _showFullScreenImage(context, section.imageUrl!),
        child: Container(
          width: double.infinity,
          height: 300, // 세로로 긴 그림을 위해 높이를 넉넉히 잡음
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA), // 아주 연한 회색/베이지 배경
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // 그림 테두리에 여백을 줌
            child: Image.network(
              section.imageUrl!,
              fit: BoxFit.contain, // ✅ 절대 자르지 않고 전체를 다 보여줌
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
        ),
      );
    } else {
      final localAsset = _getLocalAssetForTitle(section.title);
      if (localAsset != null) {
        // 로컬 이미지 (또는 아이콘)
        imageWidget = Container(
          height: 220,
          width: double.infinity,
          color: widget.result.mainColor.withOpacity(0.1),
          alignment: Alignment.center,
          child: Image.asset(localAsset, height: 220, fit: BoxFit.contain),
          // 💡 Lottie로 교체해도 좋습니다!
        );
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // 이미지 둥글게 잘리기 위해
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 이미지 영역 (있을 경우만)
          if (imageWidget != null) imageWidget,

          // 2. 내용 영역
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목과 아이콘
                Row(
                  children: [
                    Text(
                      section.iconEmoji, // 엔티티에 정의된 이모지 사용
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 본문
                Text(
                  section.content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white)),
        body: Center(
          child: InteractiveViewer(
            // ✅ 줌인/줌아웃 가능
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  /// 🔘 하단 액션 버튼 (공유 / 확인)
  Widget _buildBottomActions(BuildContext context) {
    final mainColor = widget.result.mainColor;
    final contrastColor =
        widget.result.textColor; // ✨ 여기가 핵심! (배경에 따라 흰색/검정 자동 결정)

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 공유 버튼
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  Share.share(
                    //TODO: 다시 공유 해보고 결정
                    '제목: [${widget.result.title}]\n\n간단한 내용: ${widget.result.subtitle}\n\n더욱 자세한 나의 결과가 궁금하다면?\n\n#마음색캔버스 #htp테스트 #타로 #주관식테스트 #그림테라피',
                    subject: '',
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: mainColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor:
                      contrastColor == Colors.white ? mainColor : Colors.black,
                ),
                child: Text(
                  S.of(context).psy_result_share,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 확인(홈으로) 버튼
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // 홈 화면으로 이동 (스택 초기화)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  // 버튼 배경색
                  foregroundColor: contrastColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  S.of(context).psy_result_ok,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getLocalAssetForTitle(String title) {
    final lowerTitle = title.toLowerCase();

    // 카테고리별 키워드 정의 (한글/영어/유사표현 포함)
    final Map<String, List<String>> categoryKeywords = {
      'assets/images/result/love.webp': [
        '사랑',
        '연애',
        '감정',
        '애정',
        '심장',
        'love',
        'affection',
        'emotion',
        'heart',
        'romance'
      ],
      'assets/images/result/relationship.webp': [
        '관계',
        '친구',
        '함께',
        '건강',
        '동료',
        '우정',
        'relationship',
        'friend',
        'together',
        'health',
        'buddy',
        'social'
      ],
      'assets/images/result/target.webp': [
        '성취',
        '목표',
        '즐거움',
        '성공',
        '달성',
        'target',
        'goal',
        'achievement',
        'success',
        'joy',
        'pleasure'
      ],
      'assets/images/result/work.webp': [
        '직업',
        '일',
        '업무',
        '직장',
        '비즈니스',
        '커리어',
        '전문',
        'work',
        'job',
        'business',
        'career',
        'office',
        'professional'
      ],
      'assets/images/result/stress.webp': [
        '불안',
        '스트레스',
        '고민',
        '그림자',
        '쉐도',
        '걱정',
        '어둠',
        'stress',
        'anxiety',
        'worry',
        'shadow',
        'darkness',
        'pressure'
      ],
      'assets/images/result/sad.webp': [
        '슬픔',
        '헤어',
        '이별',
        '눈물',
        '우울',
        'sad',
        'farewell',
        'breakup',
        'tear',
        'sorrow',
        'depressed'
      ],
      'assets/images/result/delight.webp': [
        '행복',
        '기쁨',
        '축하',
        '성장',
        '발전',
        '환희',
        'happy',
        'delight',
        'joy',
        'celebrate',
        'growth',
        'cheer'
      ],
      'assets/images/result/family.webp': [
        '가족',
        '모두',
        '편안',
        '마무리',
        '마음',
        '처방',
        '휴식',
        '안정',
        'family',
        'home',
        'comfort',
        'relax',
        'mind',
        'heart',
        'peace'
      ],
      'assets/images/result/objectivity.webp': [
        '주관',
        '객관',
        '만의',
        '길',
        '관점',
        '시각',
        '시선',
        'objectivity',
        'view',
        'perspective',
        'path',
        'eye',
        'way'
      ],
      'assets/images/result/reflection.webp': [
        '수립',
        '통계',
        '계획',
        '성찰',
        '분석',
        '기록',
        'reflection',
        'plan',
        'stats',
        'analysis',
        'record',
        'strategy'
      ],
      'assets/images/result/stage.webp': [
        '무대',
        '연극',
        '연기',
        '예술',
        '가면',
        '공연',
        '페르소나',
        'stage',
        'theater',
        'act',
        'art',
        'mask',
        'performance',
        'persona'
      ],
      'assets/images/result/think.webp': [
        '생각',
        '사고',
        '명상',
        '철학',
        '아이디어',
        'think',
        'thought',
        'meditation',
        'philosophy',
        'idea',
        'mindset'
      ],
      'assets/images/result/world.webp': [
        '세계',
        '세상',
        '지구',
        '우주',
        '환경',
        'world',
        'earth',
        'universe',
        'environment',
        'global'
      ],
      'assets/images/result/self.webp': [
        '나',
        '자신',
        '내',
        '하나',
        '본인',
        '자아',
        'self',
        'me',
        'individual',
        'ego',
        'myself'
      ],
      'assets/images/result/habit.webp': [
        '취미',
        '문화',
        '하고',
        '해야',
        '습관',
        '일상',
        'habit',
        'hobby',
        'culture',
        'routine',
        'daily'
      ],
      'assets/images/result/sensitive.webp': [
        '섬세',
        '예민',
        '감성',
        '공감',
        '예술적',
        '내향',
        '디테일',
        '여린',
        '감수성',
        'sensitive',
        'empathy',
        'delicate',
        'aesthetic',
        'introvert',
        'detail',
        'vulnerable',
        'tender',
        'creative'
      ],
      'assets/images/result/energy.webp': [
        '열정',
        '에너지',
        '외향',
        '활기',
        '주도',
        '리더',
        '자신감',
        '추진',
        '도전',
        'active',
        'energy',
        'extrovert',
        'passionate',
        'leader',
        'bold',
        'confident',
        'vibrant',
        'outgoing',
        'dynamic'
      ],
      'assets/images/result/balance.webp': [
        '조화',
        '균형',
        '평온',
        '안정',
        '중립',
        '유지',
        '절제',
        '차분',
        '침착',
        'balance',
        'harmony',
        'stable',
        'neutral',
        'calm',
        'peaceful',
        'moderate',
        'steady',
        'composure',
        'equilibrium'
      ],
    };

    // 루프를 돌며 해당 단어가 제목에 포함되어 있는지 확인
    for (var entry in categoryKeywords.entries) {
      if (entry.value.any((keyword) => lowerTitle.contains(keyword))) {
        return entry.key;
      }
    }

    return null; // 매칭되는 게 없으면 null
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const _Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
