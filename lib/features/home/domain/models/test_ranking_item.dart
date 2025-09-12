
/// 테스트 랭킹 아이템 모델 (Domain Model)
class TestRankingItem {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final int participantCount;
  final double popularityScore;

  const TestRankingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.participantCount,
    required this.popularityScore,
  });

  @override
  String toString() {
    return 'TestRankingItem(id: $id, title: $title, participantCount: $participantCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestRankingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}