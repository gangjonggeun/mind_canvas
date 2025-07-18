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

    // 컵 수트 (감정, 관계) - 14장 완성
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
    TaroCard(
      id: 'cups_04',
      name: '컵 4',
      nameEn: 'Four of Cups',
      imagePath: 'assets/illustrations/taro/Cups04.webp',
      type: TaroCardType.cups,
      description: '무관심, 기회 거부, 내성',
    ),
    TaroCard(
      id: 'cups_05',
      name: '컵 5',
      nameEn: 'Five of Cups',
      imagePath: 'assets/illustrations/taro/Cups05.webp',
      type: TaroCardType.cups,
      description: '실망, 슬픔, 상실',
    ),
    TaroCard(
      id: 'cups_06',
      name: '컵 6',
      nameEn: 'Six of Cups',
      imagePath: 'assets/illustrations/taro/Cups06.webp',
      type: TaroCardType.cups,
      description: '향수, 어린 시절, 순수함',
    ),
    TaroCard(
      id: 'cups_07',
      name: '컵 7',
      nameEn: 'Seven of Cups',
      imagePath: 'assets/illustrations/taro/Cups07.webp',
      type: TaroCardType.cups,
      description: '환상, 선택의 혼란, 몽상',
    ),
    TaroCard(
      id: 'cups_08',
      name: '컵 8',
      nameEn: 'Eight of Cups',
      imagePath: 'assets/illustrations/taro/Cups08.webp',
      type: TaroCardType.cups,
      description: '포기, 탈출, 새로운 추구',
    ),
    TaroCard(
      id: 'cups_09',
      name: '컵 9',
      nameEn: 'Nine of Cups',
      imagePath: 'assets/illustrations/taro/Cups09.webp',
      type: TaroCardType.cups,
      description: '만족, 소원 성취, 기쁨',
    ),
    TaroCard(
      id: 'cups_10',
      name: '컵 10',
      nameEn: 'Ten of Cups',
      imagePath: 'assets/illustrations/taro/Cups10.webp',
      type: TaroCardType.cups,
      description: '행복, 가족, 조화',
    ),
    TaroCard(
      id: 'cups_11',
      name: '컵 시종',
      nameEn: 'Page of Cups',
      imagePath: 'assets/illustrations/taro/Cups11.webp',
      type: TaroCardType.cups,
      description: '창조적 기회, 직관적 메시지',
    ),
    TaroCard(
      id: 'cups_12',
      name: '컵 기사',
      nameEn: 'Knight of Cups',
      imagePath: 'assets/illustrations/taro/Cups12.webp',
      type: TaroCardType.cups,
      description: '로맨스, 매력, 감정적 추구',
    ),
    TaroCard(
      id: 'cups_13',
      name: '컵 여왕',
      nameEn: 'Queen of Cups',
      imagePath: 'assets/illustrations/taro/Cups13.webp',
      type: TaroCardType.cups,
      description: '감정적 성숙, 직감, 공감',
    ),
    TaroCard(
      id: 'cups_14',
      name: '컵 왕',
      nameEn: 'King of Cups',
      imagePath: 'assets/illustrations/taro/Cups14.webp',
      type: TaroCardType.cups,
      description: '감정 조절, 지혜, 자비',
    ),

    // 펜타클 수트 (물질, 직업) - 14장 완성
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
    TaroCard(
      id: 'pentacles_03',
      name: '펜타클 3',
      nameEn: 'Three of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles03.webp',
      type: TaroCardType.pentacles,
      description: '협력, 팀워크, 기술 습득',
    ),
    TaroCard(
      id: 'pentacles_04',
      name: '펜타클 4',
      nameEn: 'Four of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles04.webp',
      type: TaroCardType.pentacles,
      description: '보안, 소유욕, 안정 추구',
    ),
    TaroCard(
      id: 'pentacles_05',
      name: '펜타클 5',
      nameEn: 'Five of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles05.webp',
      type: TaroCardType.pentacles,
      description: '빈곤, 어려움, 도움 요청',
    ),
    TaroCard(
      id: 'pentacles_06',
      name: '펜타클 6',
      nameEn: 'Six of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles06.webp',
      type: TaroCardType.pentacles,
      description: '관대함, 나눔, 공정한 교환',
    ),
    TaroCard(
      id: 'pentacles_07',
      name: '펜타클 7',
      nameEn: 'Seven of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles07.webp',
      type: TaroCardType.pentacles,
      description: '인내, 투자, 장기적 보상',
    ),
    TaroCard(
      id: 'pentacles_08',
      name: '펜타클 8',
      nameEn: 'Eight of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles08.webp',
      type: TaroCardType.pentacles,
      description: '숙련, 완벽, 기술 개발',
    ),
    TaroCard(
      id: 'pentacles_09',
      name: '펜타클 9',
      nameEn: 'Nine of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles09.webp',
      type: TaroCardType.pentacles,
      description: '독립, 성취, 물질적 풍요',
    ),
    TaroCard(
      id: 'pentacles_10',
      name: '펜타클 10',
      nameEn: 'Ten of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles10.webp',
      type: TaroCardType.pentacles,
      description: '가족 유산, 안정, 전통',
    ),
    TaroCard(
      id: 'pentacles_11',
      name: '펜타클 시종',
      nameEn: 'Page of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles11.webp',
      type: TaroCardType.pentacles,
      description: '학습, 실용적 기회, 성실함',
    ),
    TaroCard(
      id: 'pentacles_12',
      name: '펜타클 기사',
      nameEn: 'Knight of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles12.webp',
      type: TaroCardType.pentacles,
      description: '근면, 신뢰성, 점진적 진보',
    ),
    TaroCard(
      id: 'pentacles_13',
      name: '펜타클 여왕',
      nameEn: 'Queen of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles13.webp',
      type: TaroCardType.pentacles,
      description: '풍요, 보육, 실용적 지혜',
    ),
    TaroCard(
      id: 'pentacles_14',
      name: '펜타클 왕',
      nameEn: 'King of Pentacles',
      imagePath: 'assets/illustrations/taro/Pentacles14.webp',
      type: TaroCardType.pentacles,
      description: '성공, 리더십, 물질적 마스터',
    ),

    // 검 수트 (사고, 갈등) - 14장 완성
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
    TaroCard(
      id: 'swords_03',
      name: '검 3',
      nameEn: 'Three of Swords',
      imagePath: 'assets/illustrations/taro/Swords03.webp',
      type: TaroCardType.swords,
      description: '상처, 슬픔, 이별',
    ),
    TaroCard(
      id: 'swords_04',
      name: '검 4',
      nameEn: 'Four of Swords',
      imagePath: 'assets/illustrations/taro/Swords04.webp',
      type: TaroCardType.swords,
      description: '휴식, 명상, 재충전',
    ),
    TaroCard(
      id: 'swords_05',
      name: '검 5',
      nameEn: 'Five of Swords',
      imagePath: 'assets/illustrations/taro/Swords05.webp',
      type: TaroCardType.swords,
      description: '갈등, 패배, 공허한 승리',
    ),
    TaroCard(
      id: 'swords_06',
      name: '검 6',
      nameEn: 'Six of Swords',
      imagePath: 'assets/illustrations/taro/Swords06.webp',
      type: TaroCardType.swords,
      description: '전환, 여행, 치유',
    ),
    TaroCard(
      id: 'swords_07',
      name: '검 7',
      nameEn: 'Seven of Swords',
      imagePath: 'assets/illustrations/taro/Swords07.webp',
      type: TaroCardType.swords,
      description: '기만, 도둑질, 회피',
    ),
    TaroCard(
      id: 'swords_08',
      name: '검 8',
      nameEn: 'Eight of Swords',
      imagePath: 'assets/illustrations/taro/Swords08.webp',
      type: TaroCardType.swords,
      description: '속박, 제한, 자기 제약',
    ),
    TaroCard(
      id: 'swords_09',
      name: '검 9',
      nameEn: 'Nine of Swords',
      imagePath: 'assets/illustrations/taro/Swords09.webp',
      type: TaroCardType.swords,
      description: '불안, 악몽, 걱정',
    ),
    TaroCard(
      id: 'swords_10',
      name: '검 10',
      nameEn: 'Ten of Swords',
      imagePath: 'assets/illustrations/taro/Swords10.webp',
      type: TaroCardType.swords,
      description: '종료, 배신, 바닥',
    ),
    TaroCard(
      id: 'swords_11',
      name: '검 시종',
      nameEn: 'Page of Swords',
      imagePath: 'assets/illustrations/taro/Swords11.webp',
      type: TaroCardType.swords,
      description: '호기심, 정보 수집, 감시',
    ),
    TaroCard(
      id: 'swords_12',
      name: '검 기사',
      nameEn: 'Knight of Swords',
      imagePath: 'assets/illustrations/taro/Swords12.webp',
      type: TaroCardType.swords,
      description: '성급함, 충동, 직접 행동',
    ),
    TaroCard(
      id: 'swords_13',
      name: '검 여왕',
      nameEn: 'Queen of Swords',
      imagePath: 'assets/illustrations/taro/Swords13.webp',
      type: TaroCardType.swords,
      description: '독립, 명료함, 정직',
    ),
    TaroCard(
      id: 'swords_14',
      name: '검 왕',
      nameEn: 'King of Swords',
      imagePath: 'assets/illustrations/taro/Swords14.webp',
      type: TaroCardType.swords,
      description: '권위, 지성, 공정성',
    ),

    // 완드 수트 (의지, 창조) - 14장 완성
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
    TaroCard(
      id: 'wands_03',
      name: '완드 3',
      nameEn: 'Three of Wands',
      imagePath: 'assets/illustrations/taro/Wands03.webp',
      type: TaroCardType.wands,
      description: '확장, 진보, 장기적 계획',
    ),
    TaroCard(
      id: 'wands_04',
      name: '완드 4',
      nameEn: 'Four of Wands',
      imagePath: 'assets/illustrations/taro/Wands04.webp',
      type: TaroCardType.wands,
      description: '축하, 성취, 안정',
    ),
    TaroCard(
      id: 'wands_05',
      name: '완드 5',
      nameEn: 'Five of Wands',
      imagePath: 'assets/illustrations/taro/Wands05.webp',
      type: TaroCardType.wands,
      description: '경쟁, 갈등, 불일치',
    ),
    TaroCard(
      id: 'wands_06',
      name: '완드 6',
      nameEn: 'Six of Wands',
      imagePath: 'assets/illustrations/taro/Wands06.webp',
      type: TaroCardType.wands,
      description: '승리, 인정, 성공',
    ),
    TaroCard(
      id: 'wands_07',
      name: '완드 7',
      nameEn: 'Seven of Wands',
      imagePath: 'assets/illustrations/taro/Wands07.webp',
      type: TaroCardType.wands,
      description: '방어, 도전, 인내',
    ),
    TaroCard(
      id: 'wands_08',
      name: '완드 8',
      nameEn: 'Eight of Wands',
      imagePath: 'assets/illustrations/taro/Wands08.webp',
      type: TaroCardType.wands,
      description: '속도, 진전, 변화',
    ),
    TaroCard(
      id: 'wands_09',
      name: '완드 9',
      nameEn: 'Nine of Wands',
      imagePath: 'assets/illustrations/taro/Wands09.webp',
      type: TaroCardType.wands,
      description: '인내, 회복력, 마지막 노력',
    ),
    TaroCard(
      id: 'wands_10',
      name: '완드 10',
      nameEn: 'Ten of Wands',
      imagePath: 'assets/illustrations/taro/Wands10.webp',
      type: TaroCardType.wands,
      description: '부담, 과로, 완료',
    ),
    TaroCard(
      id: 'wands_11',
      name: '완드 시종',
      nameEn: 'Page of Wands',
      imagePath: 'assets/illustrations/taro/Wands11.webp',
      type: TaroCardType.wands,
      description: '열정, 모험, 자유 정신',
    ),
    TaroCard(
      id: 'wands_12',
      name: '완드 기사',
      nameEn: 'Knight of Wands',
      imagePath: 'assets/illustrations/taro/Wands12.webp',
      type: TaroCardType.wands,
      description: '충동, 모험, 행동력',
    ),
    TaroCard(
      id: 'wands_13',
      name: '완드 여왕',
      nameEn: 'Queen of Wands',
      imagePath: 'assets/illustrations/taro/Wands13.webp',
      type: TaroCardType.wands,
      description: '자신감, 결단력, 따뜻함',
    ),
    TaroCard(
      id: 'wands_14',
      name: '완드 왕',
      nameEn: 'King of Wands',
      imagePath: 'assets/illustrations/taro/Wands14.webp',
      type: TaroCardType.wands,
      description: '리더십, 비전, 영감',
    ),
  ];

  /// 메이저 아르카나만 가져오기 (간단한 상담용)
  static List<TaroCard> get majorArcanaOnly =>
      fullDeck.where((card) => card.type == TaroCardType.majorArcana).toList();

  /// 마이너 아르카나만 가져오기
  static List<TaroCard> get minorArcanaOnly =>
      fullDeck.where((card) => card.type != TaroCardType.majorArcana).toList();

  /// 카드 타입별 가져오기
  static List<TaroCard> getByType(TaroCardType type) =>
      fullDeck.where((card) => card.type == type).toList();

  /// 카드 ID로 카드 찾기
  static TaroCard? findById(String id) {
    try {
      return fullDeck.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 랜덤 카드 섞기 (전체 덱)
  static List<TaroCard> getShuffledDeck() {
    final List<TaroCard> deck = List.from(fullDeck);
    deck.shuffle();
    return deck;
  }

  /// 메이저 아르카나만 섞기
  static List<TaroCard> getShuffledMajorArcana() {
    final List<TaroCard> deck = List.from(majorArcanaOnly);
    deck.shuffle();
    return deck;
  }

  /// 마이너 아르카나만 섞기
  static List<TaroCard> getShuffledMinorArcana() {
    final List<TaroCard> deck = List.from(minorArcanaOnly);
    deck.shuffle();
    return deck;
  }

  /// 특정 수트만 섞기
  static List<TaroCard> getShuffledSuit(TaroCardType suitType) {
    if (suitType == TaroCardType.majorArcana) {
      return getShuffledMajorArcana();
    }
    final List<TaroCard> deck = List.from(getByType(suitType));
    deck.shuffle();
    return deck;
  }

  /// 덱 통계 정보
  static Map<String, int> get deckStats => {
    'total': fullDeck.length,
    'major': majorArcanaOnly.length,
    'minor': minorArcanaOnly.length,
    'cups': getByType(TaroCardType.cups).length,
    'pentacles': getByType(TaroCardType.pentacles).length,
    'swords': getByType(TaroCardType.swords).length,
    'wands': getByType(TaroCardType.wands).length,
  };
}