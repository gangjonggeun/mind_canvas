import 'package:freezed_annotation/freezed_annotation.dart';

part 'taro_card.freezed.dart';
part 'taro_card.g.dart';

/// 타로 카드 모델
@freezed
class TaroCard with _$TaroCard {
  const factory TaroCard({
    required String id,
    required String name,
    required String nameEn,
    required String imagePath,
    required TaroCardType type,
    required String description,
    @Default(false) bool isReversed,
  }) = _TaroCard;

  factory TaroCard.fromJson(Map<String, dynamic> json) =>
      _$TaroCardFromJson(json);
}

/// 타로 카드 타입
enum TaroCardType {
  majorArcana,  // 메이저 아르카나 (22장)
  cups,         // 컵 (14장)
  pentacles,    // 펜타클 (14장)  
  swords,       // 검 (14장)
  wands,        // 완드 (14장)
}

/// 타로 카드 데이터 제공 클래스
class TaroCards {
  /// 전체 타로 카드 덱 (78장)
  static const List<TaroCard> fullDeck = [
    // 메이저 아르카나 (22장)
    TaroCard(
      id: 'major_00',
      name: '바보',
      nameEn: 'The Fool',
      imagePath: 'assets/illustrations/taro/00-TheFool.webp',
      type: TaroCardType.majorArcana,
      description: '새로운 시작, 모험, 순수함',
    ),
    TaroCard(
      id: 'major_01',
      name: '마법사',
      nameEn: 'The Magician',
      imagePath: 'assets/illustrations/taro/01-TheMagician.webp',
      type: TaroCardType.majorArcana,
      description: '의지력, 창조력, 집중력',
    ),
    TaroCard(
      id: 'major_02',
      name: '여교황',
      nameEn: 'The High Priestess',
      imagePath: 'assets/illustrations/taro/02-TheHighPriestess.webp',
      type: TaroCardType.majorArcana,
      description: '직감, 내면의 지혜, 신비',
    ),
    TaroCard(
      id: 'major_03',
      name: '여황제',
      nameEn: 'The Empress',
      imagePath: 'assets/illustrations/taro/03-TheEmpress.webp',
      type: TaroCardType.majorArcana,
      description: '풍요, 모성, 창조성',
    ),
    TaroCard(
      id: 'major_04',
      name: '황제',
      nameEn: 'The Emperor',
      imagePath: 'assets/illustrations/taro/04-TheEmperor.webp',
      type: TaroCardType.majorArcana,
      description: '권위, 안정성, 리더십',
    ),
    TaroCard(
      id: 'major_05',
      name: '교황',
      nameEn: 'The Hierophant',
      imagePath: 'assets/illustrations/taro/05-TheHierophant.webp',
      type: TaroCardType.majorArcana,
      description: '전통, 영성, 가르침',
    ),
    TaroCard(
      id: 'major_06',
      name: '연인',
      nameEn: 'The Lovers',
      imagePath: 'assets/illustrations/taro/06-TheLovers.webp',
      type: TaroCardType.majorArcana,
      description: '사랑, 선택, 조화',
    ),
    TaroCard(
      id: 'major_07',
      name: '전차',
      nameEn: 'The Chariot',
      imagePath: 'assets/illustrations/taro/07-TheChariot.webp',
      type: TaroCardType.majorArcana,
      description: '의지력, 승리, 통제',
    ),
    TaroCard(
      id: 'major_08',
      name: '힘',
      nameEn: 'Strength',
      imagePath: 'assets/illustrations/taro/08-Strength.webp',
      type: TaroCardType.majorArcana,
      description: '내적 힘, 용기, 인내',
    ),
    TaroCard(
      id: 'major_09',
      name: '은둔자',
      nameEn: 'The Hermit',
      imagePath: 'assets/illustrations/taro/09-TheHermit.webp',
      type: TaroCardType.majorArcana,
      description: '내면 탐구, 지혜, 성찰',
    ),
    TaroCard(
      id: 'major_10',
      name: '운명의 수레바퀴',
      nameEn: 'Wheel of Fortune',
      imagePath: 'assets/illustrations/taro/10-WheelOfFortune.webp',
      type: TaroCardType.majorArcana,
      description: '운명, 변화, 행운',
    ),
    TaroCard(
      id: 'major_11',
      name: '정의',
      nameEn: 'Justice',
      imagePath: 'assets/illustrations/taro/11-Justice.webp',
      type: TaroCardType.majorArcana,
      description: '공정성, 균형, 진실',
    ),
    TaroCard(
      id: 'major_12',
      name: '매달린 남자',
      nameEn: 'The Hanged Man',
      imagePath: 'assets/illustrations/taro/12-TheHangedMan.webp',
      type: TaroCardType.majorArcana,
      description: '희생, 관점 전환, 기다림',
    ),
    TaroCard(
      id: 'major_13',
      name: '죽음',
      nameEn: 'Death',
      imagePath: 'assets/illustrations/taro/13-Death.webp',
      type: TaroCardType.majorArcana,
      description: '변화, 재생, 끝과 시작',
    ),
    TaroCard(
      id: 'major_14',
      name: '절제',
      nameEn: 'Temperance',
      imagePath: 'assets/illustrations/taro/14-Temperance.webp',
      type: TaroCardType.majorArcana,
      description: '조화, 균형, 절제',
    ),
    TaroCard(
      id: 'major_15',
      name: '악마',
      nameEn: 'The Devil',
      imagePath: 'assets/illustrations/taro/15-TheDevil.webp',
      type: TaroCardType.majorArcana,
      description: '유혹, 속박, 물질주의',
    ),
    TaroCard(
      id: 'major_16',
      name: '탑',
      nameEn: 'The Tower',
      imagePath: 'assets/illustrations/taro/16-TheTower.webp',
      type: TaroCardType.majorArcana,
      description: '파괴, 변혁, 깨달음',
    ),
    TaroCard(
      id: 'major_17',
      name: '별',
      nameEn: 'The Star',
      imagePath: 'assets/illustrations/taro/17-TheStar.webp',
      type: TaroCardType.majorArcana,
      description: '희망, 영감, 치유',
    ),
    TaroCard(
      id: 'major_18',
      name: '달',
      nameEn: 'The Moon',
      imagePath: 'assets/illustrations/taro/18-TheMoon.webp',
      type: TaroCardType.majorArcana,
      description: '환상, 불안, 무의식',
    ),
    TaroCard(
      id: 'major_19',
      name: '태양',
      nameEn: 'The Sun',
      imagePath: 'assets/illustrations/taro/19-TheSun.webp',
      type: TaroCardType.majorArcana,
      description: '기쁨, 성공, 활력',
    ),
    TaroCard(
      id: 'major_20',
      name: '심판',
      nameEn: 'Judgement',
      imagePath: 'assets/illustrations/taro/20-Judgement.webp',
      type: TaroCardType.majorArcana,
      description: '부활, 각성, 심판',
    ),
    TaroCard(
      id: 'major_21',
      name: '세계',
      nameEn: 'The World',
      imagePath: 'assets/illustrations/taro/21-TheWorld.webp',
      type: TaroCardType.majorArcana,
      description: '완성, 성취, 통합',
    ),

    // 컵 수트 (감정, 관계) - 일부만 구현
    TaroCard(
      id: 'cups_01',
      name: '컵 에이스',
      nameEn: 'Ace of Cups',
      imagePath: 'assets/illustrations/taro/Cups01.webp',
      type: TaroCardType.cups,
      description: '새로운 감정, 사랑의 시작',
    ),
    TaroCard(
      id: 'cups_02',
      name: '컵 2',
      nameEn: 'Two of Cups',
      imagePath: 'assets/illustrations/taro/Cups02.webp',
      type: TaroCardType.cups,
      description: '결합, 파트너십, 상호 매력',
    ),
    TaroCard(
      id: 'cups_03',
      name: '컵 3',
      nameEn: 'Three of Cups',
      imagePath: 'assets/illustrations/taro/Cups03.webp',
      type: TaroCardType.cups,
      description: '우정, 축하, 공동체',
    ),

    // 펜타클 수트 (물질, 직업) - 일부만 구현
    TaroCard(
      id: 'pentacles_01',
      name: '펜타클 에이스',
      nameEn: 'Ace of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles01.webp',
      type: TaroCardType.pentacles,
      description: '새로운 기회, 물질적 시작',
    ),
    TaroCard(
      id: 'pentacles_02',
      name: '펜타클 2',
      nameEn: 'Two of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles02.webp',
      type: TaroCardType.pentacles,
      description: '균형, 적응성, 변화 관리',
    ),

    // 검 수트 (사고, 갈등) - 일부만 구현
    TaroCard(
      id: 'swords_01',
      name: '검 에이스',
      nameEn: 'Ace of Swords',
      imagePath: 'assets/illustrations/taro/Swords01.webp',
      type: TaroCardType.swords,
      description: '새로운 아이디어, 정신적 명료함',
    ),
    TaroCard(
      id: 'swords_02',
      name: '검 2',
      nameEn: 'Two of Swords',
      imagePath: 'assets/illustrations/taro/Swords02.webp',
      type: TaroCardType.swords,
      description: '결정의 어려움, 균형',
    ),

    // 완드 수트 (의지, 창조) - 일부만 구현
    TaroCard(
      id: 'wands_01',
      name: '완드 에이스',
      nameEn: 'Ace of Wands',
      imagePath: 'assets/illustrations/taro/Wands01.webp',
      type: TaroCardType.wands,
      description: '새로운 시작, 창조적 에너지',
    ),
    TaroCard(
      id: 'wands_02',
      name: '완드 2',
      nameEn: 'Two of Wands',
      imagePath: 'assets/illustrations/taro/Wands02.webp',
      type: TaroCardType.wands,
      description: '미래 계획, 개인적 힘',
    ),
  ];

  /// 메이저 아르카나만 가져오기 (간단한 상담용)
  static List<TaroCard> get majorArcanaOnly =>
      fullDeck.where((card) => card.type == TaroCardType.majorArcana).toList();

  /// 카드 ID로 카드 찾기
  static TaroCard? findById(String id) {
    try {
      return fullDeck.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 랜덤 카드 섞기
  static List<TaroCard> getShuffledDeck({bool majorArcanaOnly = true}) {
    final deck = majorArcanaOnly ? TaroCards.majorArcanaOnly : fullDeck;
    final shuffled = List<TaroCard>.from(deck);
    shuffled.shuffle();
    return shuffled;
  }
}
