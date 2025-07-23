import 'package:flutter/material.dart';

/// 🎯 추천 컨텐츠 MOCK 데이터
/// 
/// 메모리 효율성을 위해 lazy loading 적용
/// 실제 서비스에서는 API 호출로 대체
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
    ];
  }
}
