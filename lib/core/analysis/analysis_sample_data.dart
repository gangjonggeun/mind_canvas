import 'domain/entities/analysis_data.dart';

/// 분석 화면용 샘플 데이터
/// 실제 심리검사 결과를 시뮬레이션한 고품질 데이터
class AnalysisSampleData {
  
  /// 메인 분석 데이터 샘플
  static AnalysisData get sampleAnalysisData => AnalysisData(
    userId: 'user_001',
    lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    mbtiType: 'INFP',
    primaryEnneagram: 4,
    
    // 감정 상태 (원형 그래프용)
    emotionStates: [
      EmotionState(
        name: '평온',
        percentage: 35.0,
        color: 'FF81C784', // 연한 초록
        emoji: '😌',
      ),
      EmotionState(
        name: '열정',
        percentage: 25.0,
        color: 'FFFF8A65', // 연한 주황
        emoji: '🔥',
      ),
      EmotionState(
        name: '불안',
        percentage: 20.0,
        color: 'FF64B5F6', // 연한 파랑
        emoji: '😰',
      ),
      EmotionState(
        name: '기쁨',
        percentage: 15.0,
        color: 'FFFFB74D', // 연한 노랑
        emoji: '😊',
      ),
      EmotionState(
        name: '슬픔',
        percentage: 5.0,
        color: 'FFB39DDB', // 연한 보라
        emoji: '😢',
      ),
    ],
    
    // 성격 5대 요소 (스트레스, 안정감, 열정, 사교성, 이성 등)
    personalityDimensions: [
      PersonalityDimension(
        name: '스트레스 저항성',
        shortName: '스트레스',
        score: 42.0,
        description: '스트레스 상황에서의 대처 능력',
        color: 'FFEF5350',
        icon: '💪',
      ),
      PersonalityDimension(
        name: '정서적 안정감',
        shortName: '안정감',
        score: 78.0,
        description: '감정의 안정성과 회복력',
        color: 'FF66BB6A',
        icon: '🌱',
      ),
      PersonalityDimension(
        name: '열정과 에너지',
        shortName: '열정',
        score: 85.0,
        description: '새로운 일에 대한 적극성과 추진력',
        color: 'FFFF7043',
        icon: '🔥',
      ),
      PersonalityDimension(
        name: '사교성',
        shortName: '사교성',
        score: 32.0,
        description: '사람들과의 상호작용 선호도',
        color: 'FF42A5F5',
        icon: '👥',
      ),
      PersonalityDimension(
        name: '이성적 판단',
        shortName: '이성',
        score: 55.0,
        description: '논리적이고 객관적인 사고력',
        color: 'FF9C27B0',
        icon: '🧠',
      ),
      PersonalityDimension(
        name: '창의성',
        shortName: '창의성',
        score: 92.0,
        description: '새로운 아이디어와 독창적 사고',
        color: 'FFAB47BC',
        icon: '🎨',
      ),
    ],
    
    // MBTI 4차원 점수
    mbtiScores: [
      MbtiScore(
        dimension: 'E/I',
        leftType: 'E',
        rightType: 'I',
        score: 45.0, // I 성향
        description: '내향적 성향이 강해 혼자만의 시간을 통해 에너지를 충전해요',
      ),
      MbtiScore(
        dimension: 'S/N',
        leftType: 'S',
        rightType: 'N',
        score: 75.0, // N 성향
        description: '직관적이며 미래 가능성과 아이디어에 집중하는 편이에요',
      ),
      MbtiScore(
        dimension: 'T/F',
        leftType: 'T',
        rightType: 'F',
        score: 60.0, // F 성향
        description: '감정과 가치를 중시하며 사람 중심적으로 판단해요',
      ),
      MbtiScore(
        dimension: 'J/P',
        leftType: 'J',
        rightType: 'P',
        score: 55.0, // P 성향
        description: '융통성 있고 즉흥적이며 열린 자세를 선호해요',
      ),
    ],
    
    // MBTI 8기능
    cognitiveFunctions: [
      CognitiveFunction(
        name: '내향 감정',
        shortName: 'Fi',
        description: '개인의 가치와 신념을 중시하는 기능',
        strength: 88.0,
        color: 'FFFF8A80',
        type: FunctionType.dominant,
      ),
      CognitiveFunction(
        name: '외향 직관',
        shortName: 'Ne',
        description: '가능성과 아이디어를 탐색하는 기능',
        strength: 75.0,
        color: 'FF80D8FF',
        type: FunctionType.auxiliary,
      ),
      CognitiveFunction(
        name: '내향 감각',
        shortName: 'Si',
        description: '과거 경험과 세부사항을 기억하는 기능',
        strength: 45.0,
        color: 'FFCCFF90',
        type: FunctionType.tertiary,
      ),
      CognitiveFunction(
        name: '외향 사고',
        shortName: 'Te',
        description: '효율성과 논리적 조직화를 추구하는 기능',
        strength: 25.0,
        color: 'FFBCAAA4',
        type: FunctionType.inferior,
      ),
    ],
    
    // 에니어그램 9타입
    enneagramTypes: [
      EnneagramType(
        number: 4,
        name: '개인주의자',
        description: '독특하고 감성적이며 자기표현을 중시하는 타입',
        score: 85.0,
        color: 'FFAB47BC',
        emoji: '🎭',
        keywords: ['감성적', '독창적', '깊이있는', '예술적'],
      ),
      EnneagramType(
        number: 9,
        name: '평화주의자',
        description: '조화롭고 수용적이며 갈등을 피하는 타입',
        score: 72.0,
        color: 'FF81C784',
        emoji: '☮️',
        keywords: ['평화로운', '수용적', '안정적', '포용적'],
      ),
      EnneagramType(
        number: 7,
        name: '열정가',
        description: '다양한 경험을 추구하며 낙천적인 타입',
        score: 68.0,
        color: 'FFFF7043',
        emoji: '🌟',
        keywords: ['낙천적', '활동적', '모험적', '다재다능'],
      ),
      EnneagramType(
        number: 2,
        name: '조력가',
        description: '타인을 도우며 관계를 중시하는 타입',
        score: 55.0,
        color: 'FF4FC3F7',
        emoji: '🤝',
        keywords: ['배려심', '따뜻함', '협력적', '관계중심'],
      ),
      EnneagramType(
        number: 5,
        name: '탐구가',
        description: '지식을 추구하며 독립적인 타입',
        score: 48.0,
        color: 'FF7986CB',
        emoji: '🔍',
        keywords: ['분석적', '독립적', '지적', '관찰자'],
      ),
    ],
    
    // 맞춤 추천 컨텐츠
    recommendedContents: [
      RecommendedContent(
        id: 'movie_001',
        title: '인사이드 아웃',
        type: '영화',
        imageUrl: 'https://via.placeholder.com/150x220/FFB74D/FFFFFF?text=Movie',
        matchPercentage: 95.0,
        reason: '감정의 복잡성을 이해하는 INFP 성향과 완벽하게 맞아요',
        tags: ['감정', '성장', '가족'],
      ),
      RecommendedContent(
        id: 'drama_001',
        title: '호텔 델루나',
        type: '드라마',
        imageUrl: 'https://via.placeholder.com/150x220/AB47BC/FFFFFF?text=Drama',
        matchPercentage: 88.0,
        reason: '신비롭고 감성적인 스토리가 당신의 상상력을 자극할 거예요',
        tags: ['판타지', '로맨스', '감성'],
      ),
      RecommendedContent(
        id: 'book_001',
        title: '연금술사',
        type: '도서',
        imageUrl: 'https://via.placeholder.com/150x220/66BB6A/FFFFFF?text=Book',
        matchPercentage: 92.0,
        reason: '꿈과 자아실현에 대한 깊이 있는 메시지가 담겨있어요',
        tags: ['자기계발', '철학', '모험'],
      ),
      RecommendedContent(
        id: 'music_001',
        title: 'Lo-Fi Hip Hop 플레이리스트',
        type: '음악',
        imageUrl: 'https://via.placeholder.com/150x220/81C784/FFFFFF?text=Music',
        matchPercentage: 85.0,
        reason: '차분하고 집중력을 높여주는 음악으로 당신의 창작 활동에 도움이 될 거예요',
        tags: ['집중', '차분함', '창의성'],
      ),
    ],
    
    // 성격 태그
    personalityTags: [
      PersonalityTag(name: '감성적인', color: 'FFFF8A80', confidence: 92.0),
      PersonalityTag(name: '창의적인', color: 'FFAB47BC', confidence: 89.0),
      PersonalityTag(name: '내성적인', color: 'FF81C784', confidence: 85.0),
      PersonalityTag(name: '직관적인', color: 'FF80D8FF', confidence: 82.0),
      PersonalityTag(name: '이상주의적', color: 'FFBCAAA4', confidence: 78.0),
      PersonalityTag(name: '독립적인', color: 'FF7986CB', confidence: 75.0),
      PersonalityTag(name: '섬세한', color: 'FFFF7043', confidence: 72.0),
      PersonalityTag(name: '유연한', color: 'FF4FC3F7', confidence: 68.0),
    ],
  );
}
