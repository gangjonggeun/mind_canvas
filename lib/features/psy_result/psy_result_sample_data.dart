import 'domain/entities/psy_result.dart';

/// 심리테스트 결과 샘플 데이터
/// 사용자 요구사항에 맞는 3가지 레이아웃과 개선된 mock 데이터
class PsyResultSampleData {

  // ===== 1. 텍스트 중심 레이아웃 (layoutType: 0) =====
  static PsyResult get textCentricResult => PsyResult(
    id: 'text_001',
    title: '따뜻한 마음의 연인',
    subtitle: '사랑 앞에서 진심으로 다가가는 당신',
    description: '당신은 사랑에 있어서 진정성을 가장 중요하게 생각하는 사람이에요. '
        '상대방의 마음을 세심하게 살피고, 작은 것 하나하나에도 정성을 쏟는 당신의 모습은 '
        '누구라도 특별함을 느끼게 만들어요. 때로는 너무 깊이 생각해서 상처받기도 하지만, '
        '그런 섬세함이야말로 당신만의 가장 큰 매력이랍니다.',
    type: PsyResultType.love,
    mainColor: 'FFFF8FA3',
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
    layoutType: 0,
    tags: ['연애', '진심', '따뜻함', '배려'],
  );

  // ===== 2. 하이브리드 레이아웃 (layoutType: 2) =====
  static PsyResult get hybridMbtiResult => PsyResult(
    id: 'mbti_enfp_001',
    title: 'ENFP - 활발한 꿈꾸는 사람',
    subtitle: '열정적이고 창의적인 영감의 원천',
    description: '당신은 넘치는 에너지와 창의성으로 주변을 밝게 만드는 사람이에요. '
        '새로운 아이디어와 가능성을 탐구하는 것을 좋아하고, 사람들과의 진심어린 관계를 소중히 여겨요. '
        '때로는 너무 많은 것을 한 번에 시도하려고 해서 집중이 어려울 수 있지만, '
        '그런 다양성이야말로 당신의 가장 큰 강점이에요.',
    type: PsyResultType.mbti,
    mainColor: 'FFFF6B9D',
    bgGradientStart: 'FFFFF0F5',
    bgGradientEnd: 'FFFFE4E9',
    iconEmoji: '🌟',
    images: [
      PsyResultImage(
        id: 'mbti_main_character',
        url: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=600&h=600&fit=crop',
        type: PsyImageType.avatar,
        caption: 'ENFP 메인 캐릭터',
      ),
    ],
    sections: [
      PsyResultSection(
        title: '성격 특징',
        content: '외향적이고 직관적인 성격으로 새로운 가능성을 끊임없이 탐구해요. '
            '감정 기능이 발달해서 사람들의 마음을 잘 이해하고, 따뜻한 관계를 만들어가는 데 능숙해요.',
        iconEmoji: '💫',
        highlights: ['창의성', '열정', '공감능력'],
        sectionImages: [
          PsyResultImage(
            id: 'enfp_trait_1',
            url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
            type: PsyImageType.section,
          ),
        ],
      ),
      PsyResultSection(
        title: '직업 적성',
        content: '창의적이고 사람 중심적인 일에서 최고의 능력을 발휘해요. 교육, 상담, 마케팅, 예술 분야에서 뛰어난 성과를 보이며, 팀워크를 중시하고 혁신적인 아이디어를 제안하는 것을 좋아해요.',
        iconEmoji: '🎯',
        highlights: ['창의적 업무', '팀워크', '혁신'],
      ),
    ],
    createdAt: DateTime.now(),
    layoutType: 2,
    tags: ['MBTI', 'ENFP', '외향적', '창의적'],
  );

  // ===== 3. 이미지 중심 레이아웃 (layoutType: 1) =====

  /// ✅ [최종 수정] HTP 결과 - 카드 하나당 이미지 하나씩 전달하는 구조로 변경
  static PsyResult get imageCentricHtpResult => PsyResult(
    id: 'htp_real_sample_001',
    title: 'HTP 심리 검사 상세 분석',
    subtitle: '그림에 담긴 당신의 내면 이야기',
    description: '세 그림을 종합적으로 볼 때, 내면에는 건강한 성장 욕구와 회복탄력성이 자리 잡고 있지만, 현재는 심리적인 소진과 방향성에 대한 불안감을 느끼고 있을 가능성이 큽니다. 외부 세계와의 교류를 원하면서도, 동시에 상처받을까 두려워하는 양가적인 감정이 엿보입니다.',
    type: PsyResultType.drawing,
    mainColor: 'FF6B73E6',
    bgGradientStart: 'FFF8F9FF',
    bgGradientEnd: 'FFE8EAFF',
    iconEmoji: '🎨',
    // ✅ 최상위 이미지는 이제 없습니다. 각 이미지는 자신의 섹션으로 이동했습니다.
    images: const [],
    sections: [
      PsyResultSection(
        title: '분석에 앞서',
        iconEmoji: 'ℹ️',
        content: '이 분석은 그림에 나타난 상징을 바탕으로 한 일반적인 해석이며, 전문적인 임상 진단이 아님을 먼저 말씀드립니다. 자신을 이해하는 데 도움이 되는 참고 자료로 활용해 주시길 바랍니다.',
        highlights: const [],
      ),
      PsyResultSection(
        title: '1. 집(House) 그림 분석',
        iconEmoji: '🏠',
        content: '집 그림은 본인이 인식하는 가정환경, 가족 관계, 그리고 자기 자신에 대한 인식을 상징합니다. 집의 내부가 보이는 구조는 소통 욕구와 불안감을, 작은 문은 관계의 어려움을, 여러 창문은 소통 욕구를 나타냅니다.',
        highlights: ['가족관계', '자아인식', '소통욕구', '경계심'],
        // ✅ '집' 섹션이 자신의 이미지를 가집니다.
        sectionImages: [
          PsyResultImage(id: 'htp_house', url: 'assets/illustrations/item/home_hizzi.png', type: PsyImageType.drawing),
        ],
      ),
      PsyResultSection(
        title: '2. 나무(Tree) 그림 분석',
        iconEmoji: '🌳',
        content: '나무 그림은 깊은 내면의 자아상, 생명력, 성장 잠재력을 상징합니다. 굵은 기둥과 상처 자국은 회복탄력성을, 위로 뻗은 가지는 미래지향적 에너지를 보여줍니다. 당신의 무의식적 자아는 매우 건강하고 강인합니다.',
        highlights: ['성장에너지', '무의식', '회복탄력성', '잠재력'],
        // ✅ '나무' 섹션이 자신의 이미지를 가집니다.
        sectionImages: [
          PsyResultImage(id: 'htp_tree', url: 'assets/illustrations/item/tree_hizzi.png', type: PsyImageType.drawing),
        ],
      ),
      PsyResultSection(
        title: '3. 사람(Person) 그림 분석',
        iconEmoji: '👤',
        content: '사람 그림은 현실 속 자신의 모습과 대인관계 태도를 나타냅니다. 피곤한 표정은 심리적 소진을, 감춘 손과 생략된 발은 자신감 부족과 현실의 불안정감을 강력하게 암시합니다.',
        highlights: ['현실인식', '대인관계', '심리적소진', '불안정감'],
        // ✅ '사람' 섹션이 자신의 이미지를 가집니다.
        sectionImages: [
          PsyResultImage(id: 'htp_person', url: 'assets/illustrations/item/human_hizzi.png', type: PsyImageType.drawing),
        ],
      ),
      PsyResultSection(
        title: '최종 종합 해석 및 조언',
        iconEmoji: '💡',
        content: '당신은 강한 잠재력을 지녔지만 현재 많이 지쳐있습니다. 자신의 잠재력을 믿고, 현실에 발 딛는 작은 연습을 하며, 자신을 돌보는 휴식 시간을 갖는 것이 중요합니다. 필요하다면 전문가와의 대화도 큰 도움이 될 수 있습니다.',
        highlights: ['자기돌봄', '안정감찾기', '전문가상담'],
      ),
    ],
    rawData: {
      'totalDurationSeconds': 1245,
      'drawingOrder': [0, 1, 2],
      'totalModifications': 12,
    },
    createdAt: DateTime.now(),
    layoutType: 1,
    tags: ['HTP', '그림심리검사', '내면분석', '자아상태'],
  );

  // 이하 나머지 코드는 동일합니다.

  static List<PsyResult> get allSamples => [
    textCentricResult,
    hybridMbtiResult,
    imageCentricHtpResult,
  ];
}