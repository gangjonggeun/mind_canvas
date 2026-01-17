// =============================================================================
// 📢 [Widget] 커뮤니티 프로모션 섹션 (광고 배너 스타일)
// =============================================================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/community_page.dart';

class CommunityPromoSection extends StatelessWidget {
  const CommunityPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 실제로는 서버나 로직에서 추천 데이터를 받아와야 합니다.
    final promos = [
      _PromoData(
        title: "ESFP 모여라! 🎉",
        subtitle: "세상에서 제일 시끌벅적한\n우리들의 파티룸으로 초대합니다.",
        tag: "#텐션폭발 #인싸집합",
        colorStart: const Color(0xFFFF9A9E),
        colorEnd: const Color(0xFFFECFEF),
        icon: Icons.celebration,
      ),
      _PromoData(
        title: "에니어그램 조력가들 🤝",
        subtitle: "남 돕느라 지친 당신,\n여기서만큼은 위로받으세요.",
        tag: "#2번유형 #따뜻한말한마디",
        colorStart: const Color(0xFFA18CD1),
        colorEnd: const Color(0xFFFBC2EB),
        icon: Icons.favorite,
      ),
      _PromoData(
        title: "논리술사 INTP 🧠",
        subtitle: "새벽 3시까지 토론 가능?\n쓸데없지만 흥미로운 잡담방",
        tag: "#분석중독 #마이웨이",
        colorStart: const Color(0xFF84FAB0),
        colorEnd: const Color(0xFF8FD3F4),
        icon: Icons.psychology,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀 (아이콘은 별(⭐️)로 유지)
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFF9F7AEA), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⭐️ 추천 커뮤니티',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '나와 비슷한 성향의 사람들과 소통해보세요',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🎠 가로 스크롤 카드 영역
        SizedBox(
          height: 150, // ✅ [수정] 높이 축소 (180 -> 150)
          child: PageView.builder(
            // ✅ [수정] 0.92 -> 0.85 (카드를 줄여서 양옆 여백 확보 및 다음 카드 노출)
            controller: PageController(viewportFraction: 0.85),
            padEnds: false, // 왼쪽 정렬 느낌 유지 (첫 카드가 왼쪽에 붙음)
            itemCount: promos.length,
            itemBuilder: (context, index) {
              // 첫 번째 아이템 왼쪽에만 패딩을 줘서 AI 추천과 라인을 맞춤
              final isFirst = index == 0;
              return Container(
                margin: EdgeInsets.only(
                    left: isFirst ? 20 : 0, // 첫 카드는 20px 띄움
                    right: 12,
                    bottom: 10
                ),
                child: _PromoCard(
                  data: promos[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommunityPage(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 데이터 모델
class _PromoData {
  final String title;
  final String subtitle;
  final String tag;
  final Color colorStart;
  final Color colorEnd;
  final IconData icon;

  _PromoData({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.colorStart,
    required this.colorEnd,
    required this.icon,
  });
}

// 🎫 [Widget] 개별 프로모션 카드
class _PromoCard extends StatelessWidget {
  final _PromoData data;
  final VoidCallback onTap;

  const _PromoCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin은 위 PageView.builder에서 처리함
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // 둥근 정도 약간 줄임
        gradient: LinearGradient(
          colors: [data.colorStart, data.colorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: data.colorStart.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15, top: -15,
            child: Icon(data.icon, size: 120, color: Colors.white.withOpacity(0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(16), // 내부 패딩도 살짝 줄임
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.2,
                      shadows: [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black12)]
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 12, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}