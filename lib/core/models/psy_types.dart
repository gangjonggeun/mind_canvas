// lib/core/models/psy_types.dart

/// 심리검사 타입 열거형
enum PsyTestType {
  htp('HTP', '그림 심리검사', '집-나무-사람 그림을 통한 심리 분석'),
  mbti('MBTI', '성격유형검사', '16가지 성격유형으로 분석'),
  persona('페르소나', '숨겨진 성격', '내면에 숨겨진 또 다른 성격 발견'),
  cognitive('인지스타일', '사고방식 분석', '학습과 사고 방식 특성 파악');
  
  const PsyTestType(this.displayName, this.shortDescription, this.fullDescription);
  
  final String displayName;
  final String shortDescription;
  final String fullDescription;
}

/// 심리검사 카테고리
enum PsyTestCategory {
  drawing('그리기 기반', '그림을 그려서 진행하는 검사'),
  questionnaire('설문 기반', '질문에 답변하여 진행하는 검사'),
  interactive('인터랙티브', '다양한 상호작용을 통한 검사');
  
  const PsyTestCategory(this.name, this.description);
  
  final String name;
  final String description;
}

/// 심리검사 설정 클래스
class PsyTestConfig {
  final String language;
  final bool isDarkMode;
  final int questionsPerPage;
  final Duration timeLimit;
  final bool enableAnalytics;
  final Map<String, dynamic> customSettings;
  
  const PsyTestConfig({
    this.language = 'ko',
    this.isDarkMode = false,
    this.questionsPerPage = 3,
    this.timeLimit = const Duration(minutes: 30),
    this.enableAnalytics = true,
    this.customSettings = const {},
  });
  
  /// 설정 복사 (일부 값 변경)
  PsyTestConfig copyWith({
    String? language,
    bool? isDarkMode,
    int? questionsPerPage,
    Duration? timeLimit,
    bool? enableAnalytics,
    Map<String, dynamic>? customSettings,
  }) {
    return PsyTestConfig(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      questionsPerPage: questionsPerPage ?? this.questionsPerPage,
      timeLimit: timeLimit ?? this.timeLimit,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

/// 심리검사 정보 클래스
class PsyTestInfo {
  final String id;
  final PsyTestType type;
  final PsyTestCategory category;
  final String title;
  final String description;
  final int estimatedMinutes;
  final String iconPath;
  final int primaryColor; // Color.value 저장
  final List<String> features;
  final bool isAvailable;
  
  const PsyTestInfo({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.iconPath,
    required this.primaryColor,
    this.features = const [],
    this.isAvailable = true,
  });
  
  /// 미리 정의된 테스트 정보들
  static const List<PsyTestInfo> predefinedTests = [
    PsyTestInfo(
      id: 'htp_test',
      type: PsyTestType.htp,
      category: PsyTestCategory.drawing,
      title: 'HTP 심리검사',
      description: '집, 나무, 사람을 그려서 무의식을 분석하는 투사법 심리검사',
      estimatedMinutes: 15,
      iconPath: 'assets/icons/htp_icon.png',
      primaryColor: 0xFF3182CE, // Colors.blue.value
      features: ['창의성 분석', '성격 특성', '심리 상태'],
    ),
    
    PsyTestInfo(
      id: 'mbti_test',
      type: PsyTestType.mbti,
      category: PsyTestCategory.questionnaire,
      title: 'MBTI 성격유형검사',
      description: '16가지 성격유형으로 나누어 개인의 선호도와 성향을 분석',
      estimatedMinutes: 12,
      iconPath: 'assets/icons/mbti_icon.png',
      primaryColor: 0xFF38A169, // Colors.green.value
      features: ['성격 분석', '직업 적성', '인간관계'],
    ),
    
    PsyTestInfo(
      id: 'persona_test',
      type: PsyTestType.persona,
      category: PsyTestCategory.questionnaire,
      title: '페르소나 테스트',
      description: '겉으로 드러나는 모습과 내면의 진짜 모습을 비교 분석',
      estimatedMinutes: 10,
      iconPath: 'assets/icons/persona_icon.png',
      primaryColor: 0xFF805AD5, // Colors.purple.value
      features: ['이중성 분석', '숨겨진 성격', '자아 인식'],
      isAvailable: false, // 준비중
    ),
    
    PsyTestInfo(
      id: 'cognitive_test',
      type: PsyTestType.cognitive,
      category: PsyTestCategory.interactive,
      title: '인지스타일 검사',
      description: '정보 처리 방식과 학습 스타일, 문제 해결 접근법 분석',
      estimatedMinutes: 8,
      iconPath: 'assets/icons/cognitive_icon.png',
      primaryColor: 0xFFD69E2E, // Colors.orange.value
      features: ['학습 스타일', '사고 방식', '문제 해결'],
      isAvailable: false, // 준비중
    ),
  ];
  
  /// ID로 테스트 정보 찾기
  static PsyTestInfo? findById(String id) {
    try {
      return predefinedTests.firstWhere((test) => test.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// 타입으로 테스트 정보 찾기
  static PsyTestInfo? findByType(PsyTestType type) {
    try {
      return predefinedTests.firstWhere((test) => test.type == type);
    } catch (e) {
      return null;
    }
  }
  
  /// 사용 가능한 테스트만 반환
  static List<PsyTestInfo> get availableTests {
    return predefinedTests.where((test) => test.isAvailable).toList();
  }
}
