
/// 테스트 랭킹 아이템 모델 (Domain Model)
class TestRankingItem {
  final int id;
  final String title;
  final String subtitle;
  final String imagePath;
  final int viewCount;

  const TestRankingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.viewCount,
  });

  @override
  String toString() {
    return 'TestRankingItem(id: $id, title: $title, participantCount: $viewCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestRankingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}