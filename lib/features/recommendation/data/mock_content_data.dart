import 'package:flutter/material.dart';

/// 🎯 추천 컨텐츠 MOCK 데이터
/// 
/// 메모리 효율성을 위해 lazy loading 적용
/// 실제 서비스에서는 API 호출로 대체
/// 
/// 📚 확장된 콘텐츠 타입 지원:
/// - 영화, 드라마, 음악 (기존)
/// - 도서, 웹툰, 게임 (신규)
class MockContentData {
  // ===== 🎬 영화 데이터 =====
  static List<Map<String, dynamic>> getMovieList() {
    return [
      {
        'title': '인터스텔라',
        'subtitle': '깊이 있는 사고를 좋아하는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '9.2',
        'gradientColors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      },
      {
        'title': '라라랜드',
        'subtitle': '감성적인 당신의 마음을 울릴',
        'imageUrl': 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.8',
        'gradientColors': [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
      },
      {
        'title': '기생충',
        'subtitle': '사회적 통찰력이 있는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '9.5',
        'gradientColors': [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
      },
      {
        'title': '어벤져스: 엔드게임',
        'subtitle': '모험을 즐기는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.4',
        'gradientColors': [const Color(0xFFE53E3E), const Color(0xFFDD6B20)],
      },
      {
        'title': '미나리',
        'subtitle': '가족에 대한 따뜻한 이야기',
        'imageUrl': 'https://images.unsplash.com/photo-1533928298208-27ff66555d8d?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.7',
        'gradientColors': [const Color(0xFF38A169), const Color(0xFF2F855A)],
      },
    ];
  }

  // ===== 📺 드라마 데이터 =====
  static List<Map<String, dynamic>> getDramaList() {
    return [
      {
        'title': '오징어 게임',
        'subtitle': '스릴을 즐기는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.7',
        'gradientColors': [const Color(0xFFE53E3E), const Color(0xFFC53030)],
      },
      {
        'title': '사랑의 불시착',
        'subtitle': '로맨틱한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '9.0',
        'gradientColors': [const Color(0xFFD53F8C), const Color(0xFFB83280)],
      },
      {
        'title': '킹덤',
        'subtitle': '역사와 스릴러를 좋아하는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.3',
        'gradientColors': [const Color(0xFF553C9A), const Color(0xFF44337A)],
      },
      {
        'title': '이태원 클라쓰',
        'subtitle': '열정적인 성취 스토리',
        'imageUrl': 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.5',
        'gradientColors': [const Color(0xFFD69E2E), const Color(0xFFB7791F)],
      },
    ];
  }

  // ===== 🎵 음악 데이터 =====
  static List<Map<String, dynamic>> getMusicList() {
    return [
      {
        'title': 'Dynamite - BTS',
        'subtitle': '에너지 넘치는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.1',
        'gradientColors': [const Color(0xFFED8936), const Color(0xFFDD6B20)],
      },
      {
        'title': 'Through the Night - IU',
        'subtitle': '잔잔한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '8.9',
        'gradientColors': [const Color(0xFF38B2AC), const Color(0xFF319795)],
      },
      {
        'title': 'Bohemian Rhapsody - Queen',
        'subtitle': '클래식한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.7',
        'gradientColors': [const Color(0xFF9F7AEA), const Color(0xFF805AD5)],
      },
      {
        'title': 'Blinding Lights - The Weeknd',
        'subtitle': '모던한 비트를 즐기는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '8.6',
        'gradientColors': [const Color(0xFF00B5D8), const Color(0xFF0BC5EA)],
      },
    ];
  }

  // ===== 📚 도서 데이터 (신규) =====
  static List<Map<String, dynamic>> getBookList() {
    return [
      {
        'title': '미드나잇 라이브러리',
        'subtitle': '인생의 가능성을 탐구하는 철학적 소설',
        'imageUrl': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop&auto=format',
        'category': '소설',
        'rating': '4.2',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
      {
        'title': '아몬드',
        'subtitle': '감정을 잃은 소년의 성장 이야기',
        'imageUrl': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=400&fit=crop&auto=format',
        'category': '소설',
        'rating': '4.5',
        'gradientColors': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      },
      {
        'title': '82년생 김지영',
        'subtitle': '현실적인 여성의 삶을 그린 소설',
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&auto=format',
        'category': '소설',
        'rating': '4.1',
        'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
      {
        'title': '원피스 RED 소설판',
        'subtitle': '모험과 우정을 그린 라이트노벨',
        'imageUrl': 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=300&h=400&fit=crop&auto=format',
        'category': '라이트노벨',
        'rating': '4.3',
        'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        'title': '전지적 독자 시점',
        'subtitle': '웹소설계의 혁신적 작품',
        'imageUrl': 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=300&h=400&fit=crop&auto=format',
        'category': '웹소설',
        'rating': '4.8',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
    ];
  }

  // ===== 📱 웹툰 데이터 (신규) =====
  static List<Map<String, dynamic>> getWebtoonList() {
    return [
      {
        'title': '나 혼자만 레벨업',
        'subtitle': '초능력 액션 판타지 웹툰',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=400&fit=crop&auto=format',
        'category': '판타지',
        'rating': '9.8',
        'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
      {
        'title': '화산귀환',
        'subtitle': '무협의 정수를 담은 웹툰',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=400&fit=crop&auto=format',
        'category': '무협',
        'rating': '9.7',
        'gradientColors': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      },
      {
        'title': '외모지상주의',
        'subtitle': '현실적인 학원 드라마 웹툰',
        'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=400&fit=crop&auto=format',
        'category': '드라마',
        'rating': '9.2',
        'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        'title': '여신강림',
        'subtitle': '로맨스와 성장을 다룬 웹툰',
        'imageUrl': 'https://images.unsplash.com/photo-1594736797933-d0fce9d09f8b?w=300&h=400&fit=crop&auto=format',
        'category': '로맨스',
        'rating': '9.0',
        'gradientColors': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      },
      {
        'title': '신의 탑',
        'subtitle': '거대한 세계관의 판타지 웹툰',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=400&fit=crop&auto=format',
        'category': '판타지',
        'rating': '9.4',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
    ];
  }

  // ===== 🎮 게임 데이터 (신규) =====
  static List<Map<String, dynamic>> getGameList() {
    return [
      {
        'title': '발더스 게이트 3',
        'subtitle': '선택의 무게를 느끼는 RPG',
        'imageUrl': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=300&h=400&fit=crop&auto=format',
        'category': 'RPG',
        'rating': '9.6',
        'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        'title': '젤다의 전설: 왕국의 눈물',
        'subtitle': '무한한 창조와 모험의 게임',
        'imageUrl': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=300&h=400&fit=crop&auto=format',
        'category': '액션 어드벤처',
        'rating': '9.8',
        'gradientColors': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      },
      {
        'title': '스타듀 밸리',
        'subtitle': '여유로운 농장 생활 시뮬레이션',
        'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=300&h=400&fit=crop&auto=format',
        'category': '시뮬레이션',
        'rating': '9.1',
        'gradientColors': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      },
      {
        'title': '리그 오브 레전드',
        'subtitle': '전략적 팀 대전 게임',
        'imageUrl': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=300&h=400&fit=crop&auto=format',
        'category': 'MOBA',
        'rating': '8.5',
        'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
      {
        'title': '원신',
        'subtitle': '아름다운 오픈월드 RPG',
        'imageUrl': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=300&h=400&fit=crop&auto=format',
        'category': 'RPG',
        'rating': '8.9',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
    ];
  }

  // ===== 👥 함께 보기 컨텐츠 데이터 (MBTI 조합 기반) =====

  static List<Map<String, dynamic>> getTogetherMovieList(String userMbti, String partnerMbti) {
    return [
      {
        'title': '어바웃 타임',
        'subtitle': '$userMbti와 $partnerMbti가 함께 즐길',
        'imageUrl': 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.9',
        'gradientColors': [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
      },
      {
        'title': '인사이드 아웃',
        'subtitle': '두 사람 모두 공감할 수 있는',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.6',
        'gradientColors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      },
      {
        'title': '코코',
        'subtitle': '감동적인 가족 이야기',
        'imageUrl': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.7',
        'gradientColors': [const Color(0xFFD69E2E), const Color(0xFFB7791F)],
      },
    ];
  }

  static List<Map<String, dynamic>> getTogetherDramaList(String userMbti, String partnerMbti) {
    return [
      {
        'title': '스타트업',
        'subtitle': '$userMbti와 $partnerMbti의 조합에 맞는',
        'imageUrl': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.2',
        'gradientColors': [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
      },
      {
        'title': '호텔 델루나',
        'subtitle': '판타지를 함께 즐기는',
        'imageUrl': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.5',
        'gradientColors': [const Color(0xFF9F7AEA), const Color(0xFF805AD5)],
      },
      {
        'title': '갯마을 차차차',
        'subtitle': '힐링 로맨스 드라마',
        'imageUrl': 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.3',
        'gradientColors': [const Color(0xFF38A169), const Color(0xFF2F855A)],
      },
    ];
  }

  static List<Map<String, dynamic>> getTogetherMusicList(String userMbti, String partnerMbti) {
    return [
      {
        'title': 'Perfect - Ed Sheeran',
        'subtitle': '커플이 함께 들으면 좋은',
        'imageUrl': 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.3',
        'gradientColors': [const Color(0xFFD53F8C), const Color(0xFFB83280)],
      },
      {
        'title': 'Couple Vibes Playlist',
        'subtitle': '로맨틱한 분위기의',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '8.8',
        'gradientColors': [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
      },
      {
        'title': '아이유 & BTS 협업곡',
        'subtitle': '세대를 아우르는 음악',
        'imageUrl': 'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.0',
        'gradientColors': [const Color(0xFF38B2AC), const Color(0xFF319795)],
      },
    ];
  }

  // ===== 📚 함께 읽기 도서 데이터 (신규) =====
  static List<Map<String, dynamic>> getTogetherBookList(String userMbti, String partnerMbti) {
    return [
      {
        'title': '작별하지 않는다',
        'subtitle': '$userMbti-$partnerMbti 커플이 함께 읽기 좋은',
        'imageUrl': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop&auto=format',
        'category': '소설',
        'rating': '4.4',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
      {
        'title': '연애 소설 읽는 시간',
        'subtitle': '커플이 함께 공감할 수 있는',
        'imageUrl': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=400&fit=crop&auto=format',
        'category': '에세이',
        'rating': '4.2',
        'gradientColors': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      },
      {
        'title': '우리가 빛의 속도로 갈 수 없다면',
        'subtitle': 'SF를 함께 상상하며',
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop&auto=format',
        'category': 'SF',
        'rating': '4.6',
        'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
    ];
  }

  // ===== 📱 함께 보기 웹툰 데이터 (신규) =====
  static List<Map<String, dynamic>> getTogetherWebtoonList(String userMbti, String partnerMbti) {
    return [
      {
        'title': '연애혁명',
        'subtitle': '$userMbti-$partnerMbti가 함께 보기 좋은 로맨스',
        'imageUrl': 'https://images.unsplash.com/photo-1594736797933-d0fce9d09f8b?w=300&h=400&fit=crop&auto=format',
        'category': '로맨스',
        'rating': '9.1',
        'gradientColors': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      },
      {
        'title': '치즈인더트랩',
        'subtitle': '복잡한 인간관계를 함께 분석하며',
        'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=400&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.9',
        'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        'title': '나빌레라',
        'subtitle': '꿈에 대한 이야기를 함께',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=400&fit=crop&auto=format',
        'category': '드라마',
        'rating': '9.3',
        'gradientColors': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
    ];
  }

  // ===== 🎮 함께 하기 게임 데이터 (신규) =====
  static List<Map<String, dynamic>> getTogetherGameList(String userMbti, String partnerMbti) {
    return [
      {
        'title': 'It Takes Two',
        'subtitle': '$userMbti-$partnerMbti 커플 협동 게임',
        'imageUrl': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=300&h=400&fit=crop&auto=format',
        'category': '협동',
        'rating': '9.5',
        'gradientColors': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        'title': '동물의 숲',
        'subtitle': '함께 꾸미는 아늑한 섬',
        'imageUrl': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=300&h=400&fit=crop&auto=format',
        'category': '시뮬레이션',
        'rating': '9.2',
        'gradientColors': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      },
      {
        'title': '오버쿡 2',
        'subtitle': '함께 요리하며 협력하는 게임',
        'imageUrl': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=300&h=400&fit=crop&auto=format',
        'category': '파티',
        'rating': '8.8',
        'gradientColors': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      },
      {
        'title': '마인크래프트',
        'subtitle': '무한한 창조의 세계를 함께',
        'imageUrl': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=300&h=400&fit=crop&auto=format',
        'category': '샌드박스',
        'rating': '9.0',
        'gradientColors': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      },
    ];
  }

  // ===== 👥 사용자 추천 데이터 =====
  static List<Map<String, String>> getUserRecommendations() {
    return [
      {'title': '사용자 @김민수', 'content': '"스트레인저 씽즈" 강추!', 'similarity': '91%'},
      {'title': '사용자 @박지은', 'content': '카페 브런치 플레이리스트', 'similarity': '89%'},
      {'title': '사용자 @이준호', 'content': '힐링 게임 "스타듀밸리"', 'similarity': '87%'},
      {'title': '사용자 @최수영', 'content': '넷플릭스 "킹덤" 시리즈', 'similarity': '85%'},
      {'title': '사용자 @정민호', 'content': '로파이 집중 음악', 'similarity': '83%'},
      {'title': '사용자 @한서연', 'content': '"나 혼자만 레벨업" 웹툰', 'similarity': '86%'},
      {'title': '사용자 @조민재', 'content': '"미드나잇 라이브러리" 도서', 'similarity': '84%'},
      {'title': '사용자 @윤하영', 'content': '"It Takes Two" 커플게임', 'similarity': '88%'},
    ];
  }

  // ===== 🎯 MBTI 리스트 =====
  static List<String> getMbtiTypes() {
    return [
      'ENFP', 'ENFJ', 'ENTP', 'ENTJ',
      'ESFP', 'ESFJ', 'ESTP', 'ESTJ',
      'INFP', 'INFJ', 'INTP', 'INTJ',
      'ISFP', 'ISFJ', 'ISTP', 'ISTJ',
    ];
  }

  // ===== 🏆 월드컵 카테고리 데이터 =====
  static List<Map<String, String>> getWorldCupCategories() {
    return [
      {
        'emoji': '🍽️',
        'title': '음식 취향',
        'category': 'food',
        'subtitle': '당신의 음식 취향을 알아보세요'
      },
      {
        'emoji': '🎬',
        'title': '영화 장르',
        'category': 'movie',
        'subtitle': '선호하는 영화 장르 발견'
      },
      {
        'emoji': '✈️',
        'title': '여행 스타일',
        'category': 'travel',
        'subtitle': '이상적인 여행 스타일 찾기'
      },
      {
        'emoji': '🎵',
        'title': '음악 취향',
        'category': 'music',
        'subtitle': '좋아하는 음악 스타일 분석'
      },
      {
        'emoji': '📚',
        'title': '도서 취향',
        'category': 'book',
        'subtitle': '선호하는 책 장르 분석'
      },
      {
        'emoji': '📱',
        'title': '웹툰 장르',
        'category': 'webtoon',
        'subtitle': '좋아하는 웹툰 스타일 발견'
      },
      {
        'emoji': '🎮',
        'title': '게임 장르',
        'category': 'game',
        'subtitle': '선호하는 게임 타입 분석'
      },
    ];
  }

  // ===== 🔍 MBTI별 추천 로직 (향후 고도화) =====

  /// MBTI 특성에 따른 콘텐츠 필터링 로직
  /// TODO: 실제 MBTI 분석 알고리즘 구현
  static Map<String, List<String>> getMbtiContentPreferences(String mbti) {
    // 예시: ENFP의 경우
    if (mbti == 'ENFP') {
      return {
        'movie': ['코미디', '모험', '판타지'],
        'drama': ['로맨스', '코미디', '드라마'],
        'music': ['팝', '인디', '일렉트로닉'],
        'book': ['자기계발', '판타지', '에세이'],
        'webtoon': ['로맨스', '코미디', '판타지'],
        'game': ['RPG', '시뮬레이션', '어드벤처'],
      };
    }

    // 기본값 반환
    return {
      'movie': ['드라마', '액션'],
      'drama': ['드라마', '로맨스'],
      'music': ['팝', '발라드'],
      'book': ['소설', '에세이'],
      'webtoon': ['드라마', '로맨스'],
      'game': ['RPG', '액션'],
    };
  }

  /// 콘텐츠 타입별 인기 순위 (실시간 업데이트 시뮬레이션)
  static Map<String, List<String>> getTrendingContent() {
    return {
      'movie': ['기생충', '미나리', '라라랜드'],
      'drama': ['오징어 게임', '사랑의 불시착', '킹덤'],
      'music': ['Dynamite - BTS', 'Through the Night - IU'],
      'book': ['아몬드', '미드나잇 라이브러리', '전지적 독자 시점'],
      'webtoon': ['나 혼자만 레벨업', '화산귀환', '외모지상주의'],
      'game': ['발더스 게이트 3', '젤다의 전설', '원신'],
    };
  }
}