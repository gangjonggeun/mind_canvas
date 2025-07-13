
import 'domain/entities/psy_result.dart';

/// 심리테스트 결과 샘플 데이터
/// 여성 사용자 선호 감성적 컨텐츠
class PsyResultSampleData {
  /// 짧은 결과 샘플 (연애 성향 테스트)
  static PsyResult get shortLoveResult => PsyResult(
    id: 'love_001',
    title: '따뜻한 마음의 연인',
    subtitle: '사랑 앞에서 진심으로 다가가는 당신',
    description: '당신은 사랑에 있어서 진정성을 가장 중요하게 생각하는 사람이에요. '
        '상대방의 마음을 세심하게 살피고, 작은 것 하나하나에도 정성을 쏟는 당신의 모습은 '
        '누구라도 특별함을 느끼게 만들어요. 때로는 너무 깊이 생각해서 상처받기도 하지만, '
        '그런 섬세함이야말로 당신만의 가장 큰 매력이랍니다.',
    type: PsyResultType.love,
    mainColor: 'FFFF8FA3', // 모던 핑크
    bgGradientStart: 'FFFFE5EA',
    bgGradientEnd: 'FFFF8FA3',
    iconEmoji: '💕',
    sections: [
      PsyResultSection(
        title: '연애 스타일',
        content: '진심을 다하는 깊은 사랑을 추구해요. 상대방을 위해 작은 것부터 큰 것까지 '
            '세심하게 챙기는 것을 좋아하고, 함께하는 시간 자체에 큰 의미를 두는 편이에요.',
        iconEmoji: '💝',
        highlights: ['진실한 마음', '세심한 배려'],
      ),
      PsyResultSection(
        title: '이상형',
        content: '겉모습보다는 내면의 따뜻함을 중요시해요. 함께 있을 때 편안하고 '
            '자연스러운 사람, 서로의 생각을 나눌 수 있는 깊이 있는 대화가 가능한 사람을 선호해요.',
        iconEmoji: '🌟',
        highlights: ['내면의 아름다움', '깊은 대화'],
      ),
    ],
    createdAt: DateTime.now(),
    tags: ['연애', '진심', '따뜻함', '배려'],
  );

  /// 긴 결과 샘플 (성격 분석 테스트)
  static PsyResult get longPersonalityResult => PsyResult(
    id: 'personality_001',
    title: '꽃처럼 아름다운 감성파',
    subtitle: '세상의 아름다움을 느끼고 표현하는 예술가 기질',
    description: '당신은 세상을 바라보는 독특한 시각을 가진 사람이에요. '
        '일상 속에서도 특별한 아름다움을 발견하고, 그것을 자신만의 방식으로 표현하는 것을 좋아해요. '
        '감정이 풍부하고 섬세해서 때로는 상처받기 쉽지만, 그런 깊은 감성이야말로 당신이 세상에 '
        '전하는 가장 큰 선물이에요. 주변 사람들은 당신의 따뜻하고 진실한 마음에 감동받곤 해요.',
    type: PsyResultType.personality,
    mainColor: 'FFA78BFA', // 모던 퍼플
    bgGradientStart: 'FFF4F0FF',
    bgGradientEnd: 'FFE0D1FF',
    iconEmoji: '🌸',
    sections: [
      PsyResultSection(
        title: '당신의 핵심 성격',
        content: '당신은 감정이 풍부하고 직관적인 사람이에요. 논리보다는 감정과 직감을 '
            '더 신뢰하는 편이고, 그래서 종종 놀라운 통찰력을 보여주기도 해요. '
            '예술적 감각이 뛰어나고, 아름다운 것들에 대한 안목이 남다르죠. '
            '하지만 때로는 너무 감정적으로 접근해서 객관적 판단이 어려울 때도 있어요. '
            '그럴 때는 잠시 거리를 두고 생각해보는 시간을 갖는 것이 도움이 될 거예요.',
        iconEmoji: '💖',
        highlights: [
          '풍부한 감성과 직관력',
          '예술적 감각과 미적 안목',
          '따뜻하고 진실한 마음',
          '깊이 있는 사고와 통찰력'
        ],
      ),
      PsyResultSection(
        title: '대인관계에서의 모습',
        content: '사람들과의 관계에서 진정성을 가장 중요하게 생각해요. '
            '겉으로 드러나는 모습보다는 마음속 깊은 이야기를 나누는 것을 좋아하고, '
            '상대방의 감정에 공감하는 능력이 뛰어나요. 때로는 다른 사람의 감정에 '
            '너무 깊이 동조해서 본인이 힘들어지기도 하지만, 그런 따뜻함 때문에 '
            '많은 사람들이 당신을 찾게 되는 거예요. 갈등 상황에서는 직접적인 '
            '대립보다는 조화를 추구하는 편이에요.',
        iconEmoji: '🤝',
        highlights: [
          '진정성 있는 관계 추구',
          '뛰어난 공감 능력',
          '조화롭고 평화로운 관계 선호',
          '깊이 있는 소통 능력'
        ],
      ),
      PsyResultSection(
        title: '일과 성장에서의 특징',
        content: '창의적이고 자유로운 환경에서 가장 큰 능력을 발휘해요. '
            '규칙과 체계보다는 영감과 직감을 따르는 것을 선호하고, '
            '자신만의 독특한 방식으로 문제를 해결하는 능력이 있어요. '
            '반복적이고 기계적인 일보다는 매번 새로운 도전이 있는 일을 좋아하고, '
            '특히 사람들의 마음을 움직이거나 감동을 줄 수 있는 일에서 큰 보람을 느껴요. '
            '완벽주의적 성향이 있어서 때로는 스스로에게 너무 엄격할 수 있으니, '
            '작은 성취도 인정하고 격려하는 마음가짐이 필요해요.',
        iconEmoji: '🌱',
        highlights: [
          '창의적이고 독창적인 사고',
          '영감을 따르는 직관적 접근',
          '사람의 마음을 움직이는 능력',
          '새로운 도전을 즐기는 성향'
        ],
      ),
      PsyResultSection(
        title: '감정과 스트레스 관리',
        content: '감정의 기복이 있는 편이지만, 그만큼 삶을 풍성하게 느끼는 사람이에요. '
            '기쁠 때는 온 세상이 밝게 보이고, 슬플 때는 깊이 빠져드는 경향이 있어요. '
            '스트레스를 받을 때는 혼자만의 시간을 갖거나 자연 속에서 마음을 달래는 것을 좋아해요. '
            '음악이나 예술 활동을 통해 감정을 표현하는 것도 큰 도움이 될 거예요. '
            '때로는 감정에 휘둘리기보다는 한 발짝 뒤에서 바라보는 연습도 필요해요.',
        iconEmoji: '🌙',
        highlights: [
          '풍부한 감정 표현력',
          '자연과 예술을 통한 치유',
          '깊이 있는 감정 경험',
          '혼자만의 시간 중요시'
        ],
      ),
      PsyResultSection(
        title: '미래를 위한 조언',
        content: '당신의 섬세한 감성과 따뜻한 마음은 이 세상을 더 아름답게 만드는 큰 힘이에요. '
            '때로는 너무 깊이 느끼고 생각해서 힘들 수도 있지만, 그런 깊이가 있기에 '
            '다른 사람들이 느끼지 못하는 것들을 발견할 수 있는 거예요. '
            '자신만의 속도로 천천히 걸어가도 괜찮아요. 중요한 것은 당신다운 모습을 잃지 않는 것이에요. '
            '앞으로도 계속해서 세상의 아름다움을 발견하고, 그것을 나누는 사람이 되어주세요.',
        iconEmoji: '✨',
        highlights: [
          '자신만의 속도로 성장하기',
          '감성을 잃지 않고 살아가기',
          '세상에 아름다움 전하기',
          '있는 그대로의 자신 인정하기'
        ],
      ),
    ],
    createdAt: DateTime.now(),
    tags: ['감성', '예술가', '직관', '따뜻함', '창의성'],
  );

  /// 컬러 테라피 결과 샘플
  static PsyResult get colorTherapyResult => PsyResult(
    id: 'color_001',
    title: '라벤더 같은 당신',
    subtitle: '평온함과 우아함을 동시에 지닌 특별한 존재',
    description: '당신을 나타내는 색상은 부드러운 라벤더예요. '
        '차분하면서도 신비로운 매력을 가진 당신은 주변 사람들에게 안정감을 주는 존재예요. '
        '때로는 혼자만의 시간을 통해 에너지를 충전하고, 깊이 있는 생각을 즐기는 내향적인 면도 있어요.',
    type: PsyResultType.color,
    mainColor: 'FF8B9AFF', // 모던 라벤더
    bgGradientStart: 'FFF0F2FF',
    bgGradientEnd: 'FFD4DAFF',
    iconEmoji: '🌿',
    sections: [
      PsyResultSection(
        title: '라벤더의 의미',
        content: '라벤더는 평온, 우아함, 그리고 내면의 강함을 상징해요. '
            '겉보기에는 부드럽지만 속으로는 확고한 자신만의 신념을 가지고 있는 당신의 모습과 닮아있어요.',
        iconEmoji: '💜',
        highlights: ['평온함', '우아함', '내면의 강함'],
      ),
    ],
    createdAt: DateTime.now(),
    tags: ['라벤더', '평온', '우아함', '신비'],
  );

  /// 모든 샘플 데이터 리스트
  static List<PsyResult> get allSamples => [
    shortLoveResult,
    longPersonalityResult,
    colorTherapyResult,
  ];
}
