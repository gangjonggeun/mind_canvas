import 'package:flutter/material.dart';
import '../domain/entities/recommended_content_entity.dart';
// import 'package:mind_canvas/core/utils/app_logger.dart'; // TODO: 로거 문제 해결 후 사용
import 'package:mind_canvas/core/utils/result.dart';

/// 🎬 추천 컨텐츠 데이터 서비스 인터페이스
/// 테스트를 위해 인터페이스로 분리
abstract class IRecommendedContentDataService {
  /// 컨텐츠 타입과 모드에 따른 추천 컨텐츠 조회
  Future<Result<List<RecommendedContentEntity>>> getRecommendedContents({
    required ContentType contentType,
    required ContentMode contentMode,
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
  });

  /// MBTI 타입 목록 조회
  List<String> getMbtiTypes();
}

/// 🎬 추천 컨텐츠 데이터 서비스 구현체
/// 실제 데이터 제공 (현재는 Mock 데이터, 추후 API 연동 가능)
class RecommendedContentDataService implements IRecommendedContentDataService {


  @override
  Future<Result<List<RecommendedContentEntity>>> getRecommendedContents({
    required ContentType contentType,
    required ContentMode contentMode,
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
  }) async {
    try {

      // TODO: 로그 추가 예정
      print('추천 컨텐츠 조회 시작: type=$contentType, mode=$contentMode');

      // 🔄 네트워크 지연 시뮬레이션 (실제 API 호출 시뮬레이션)
      await Future.delayed(const Duration(milliseconds: 500));

      final contents = contentMode == ContentMode.together
          ? _getTogetherContents(contentType, userMbti, partnerMbti)
          : _getPersonalContents(contentType, userMbti);

      print('추천 컨텐츠 조회 성공: ${contents.length}개');

      return Results.success(contents);
    } catch (e, stackTrace) {
      print('추천 컨텐츠 조회 실패: ${e.toString()}');
      return Results.failure('추천 컨텐츠를 불러오는데 실패했습니다: ${e.toString()}');
    }
  }

  @override
  List<String> getMbtiTypes() {
    return [
      'ENFP', 'ENFJ', 'ENTP', 'ENTJ',
      'ESFP', 'ESFJ', 'ESTP', 'ESTJ',
      'INFP', 'INFJ', 'INTP', 'INTJ',
      'ISFP', 'ISFJ', 'ISTP', 'ISTJ',
    ];
  }

  /// 🎯 개인 추천 컨텐츠 생성
  List<RecommendedContentEntity> _getPersonalContents(
    ContentType contentType,
    MbtiInfo? userMbti,
  ) {
    switch (contentType) {
      case ContentType.movie:
        return _getPersonalMovies(userMbti);
      case ContentType.drama:
        return _getPersonalDramas(userMbti);
      case ContentType.music:
        return _getPersonalMusic(userMbti);
    }
  }

  /// 👥 함께 보기 컨텐츠 생성
  List<RecommendedContentEntity> _getTogetherContents(
    ContentType contentType,
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
  ) {
    final compatibility = _calculateMbtiCompatibility(
      userMbti?.type ?? 'ENFP',
      partnerMbti?.type ?? 'ISFJ',
    );

    switch (contentType) {
      case ContentType.movie:
        return _getTogetherMovies(userMbti, partnerMbti, compatibility);
      case ContentType.drama:
        return _getTogetherDramas(userMbti, partnerMbti, compatibility);
      case ContentType.music:
        return _getTogetherMusic(userMbti, partnerMbti, compatibility);
    }
  }

  /// 🎬 개인 추천 영화
  List<RecommendedContentEntity> _getPersonalMovies(MbtiInfo? userMbti) {
    return [
      RecommendedContentEntity(
        id: 'movie_personal_1',
        title: '인터스텔라',
        subtitle: '깊이 있는 사고를 좋아하는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '9.2',
        gradientColors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        matchPercentage: 95.0,
        reason: '${userMbti?.type ?? 'ENFP'} 성향에 맞는 철학적 영화',
        tags: ['SF', '철학', '가족'],
        createdAt: DateTime.now(),
      ),
      RecommendedContentEntity(
        id: 'movie_personal_2',
        title: '라라랜드',
        subtitle: '감성적인 당신의 마음을 울릴',
        imageUrl: 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '8.8',
        gradientColors: [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
        matchPercentage: 92.0,
        reason: '감성적이고 로맨틱한 스토리',
        tags: ['로맨스', '뮤지컬', '감성'],
      ),
      RecommendedContentEntity(
        id: 'movie_personal_3',
        title: '기생충',
        subtitle: '사회적 통찰력이 있는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '9.5',
        gradientColors: [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
        matchPercentage: 89.0,
        reason: '사회 비판적 시각이 뛰어난 작품',
        tags: ['드라마', '사회비판', '스릴러'],
      ),
      RecommendedContentEntity(
        id: 'movie_personal_4',
        title: '어벤져스',
        subtitle: '모험을 즐기는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '8.4',
        gradientColors: [const Color(0xFFE53E3E), const Color(0xFFDD6B20)],
        matchPercentage: 87.0,
        reason: '액션과 모험을 즐기는 성향',
        tags: ['액션', '모험', 'SF'],
      ),
    ];
  }

  /// 📺 개인 추천 드라마
  List<RecommendedContentEntity> _getPersonalDramas(MbtiInfo? userMbti) {
    return [
      RecommendedContentEntity(
        id: 'drama_personal_1',
        title: '오징어 게임',
        subtitle: '스릴을 즐기는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
        type: ContentType.drama,
        rating: '8.7',
        gradientColors: [const Color(0xFFE53E3E), const Color(0xFFC53030)],
        matchPercentage: 91.0,
        reason: '긴장감과 사회적 메시지를 좋아하는 성향',
        tags: ['스릴러', '사회드라마', '서바이벌'],
      ),
      RecommendedContentEntity(
        id: 'drama_personal_2',
        title: '사랑의 불시착',
        subtitle: '로맨틱한 감성의 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=200&fit=crop&auto=format',
        type: ContentType.drama,
        rating: '9.0',
        gradientColors: [const Color(0xFFD53F8C), const Color(0xFFB83280)],
        matchPercentage: 94.0,
        reason: '따뜻한 로맨스를 선호하는 성향',
        tags: ['로맨스', '코미디', '힐링'],
      ),
      RecommendedContentEntity(
        id: 'drama_personal_3',
        title: '킹덤',
        subtitle: '역사와 스릴러를 좋아하는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
        type: ContentType.drama,
        rating: '8.3',
        gradientColors: [const Color(0xFF553C9A), const Color(0xFF44337A)],
        matchPercentage: 85.0,
        reason: '역사적 배경과 액션을 선호',
        tags: ['사극', '액션', '좀비'],
      ),
    ];
  }

  /// 🎵 개인 추천 음악
  List<RecommendedContentEntity> _getPersonalMusic(MbtiInfo? userMbti) {
    return [
      RecommendedContentEntity(
        id: 'music_personal_1',
        title: 'Dynamite - BTS',
        subtitle: '에너지 넘치는 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&auto=format',
        type: ContentType.music,
        rating: '9.1',
        gradientColors: [const Color(0xFFED8936), const Color(0xFFDD6B20)],
        matchPercentage: 88.0,
        reason: '활발하고 긍정적인 성향에 맞는 곡',
        tags: ['K-pop', '댄스', '업비트'],
      ),
      RecommendedContentEntity(
        id: 'music_personal_2',
        title: 'Through the Night - IU',
        subtitle: '잔잔한 감성의 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
        type: ContentType.music,
        rating: '8.9',
        gradientColors: [const Color(0xFF38B2AC), const Color(0xFF319795)],
        matchPercentage: 93.0,
        reason: '감성적이고 따뜻한 멜로디',
        tags: ['발라드', '감성', '힐링'],
      ),
      RecommendedContentEntity(
        id: 'music_personal_3',
        title: 'Bohemian Rhapsody - Queen',
        subtitle: '클래식한 감성의 당신에게',
        imageUrl: 'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=300&h=200&fit=crop&auto=format',
        type: ContentType.music,
        rating: '9.7',
        gradientColors: [const Color(0xFF9F7AEA), const Color(0xFF805AD5)],
        matchPercentage: 90.0,
        reason: '독창적이고 예술적인 성향',
        tags: ['클래식록', '오페라', '아트록'],
      ),
    ];
  }

  /// 👥 함께 보기 영화
  List<RecommendedContentEntity> _getTogetherMovies(
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
    double compatibility,
  ) {
    return [
      RecommendedContentEntity(
        id: 'movie_together_1',
        title: '어바웃 타임',
        subtitle: '${userMbti?.type ?? 'ENFP'}와 ${partnerMbti?.type ?? 'ISFJ'}가 함께 즐길',
        imageUrl: 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '8.9',
        gradientColors: [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
        matchPercentage: compatibility,
        reason: '두 성향 모두 공감할 수 있는 감동적인 이야기',
        tags: ['로맨스', '가족', '판타지'],
      ),
      RecommendedContentEntity(
        id: 'movie_together_2',
        title: '인사이드 아웃',
        subtitle: '두 사람 모두 공감할 수 있는',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
        type: ContentType.movie,
        rating: '8.6',
        gradientColors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        matchPercentage: compatibility - 5,
        reason: '감정의 복잡함을 다룬 심리적 작품',
        tags: ['애니메이션', '심리', '성장'],
      ),
    ];
  }

  /// 👥 함께 보기 드라마
  List<RecommendedContentEntity> _getTogetherDramas(
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
    double compatibility,
  ) {
    return [
      RecommendedContentEntity(
        id: 'drama_together_1',
        title: '스타트업',
        subtitle: '${userMbti?.type ?? 'ENFP'}와 ${partnerMbti?.type ?? 'ISFJ'}의 조합에 맞는',
        imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
        type: ContentType.drama,
        rating: '8.2',
        gradientColors: [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
        matchPercentage: compatibility,
        reason: '창업과 성장 이야기로 함께 동기부여',
        tags: ['로맨스', '비즈니스', '성장'],
      ),
    ];
  }

  /// 👥 함께 듣기 음악
  List<RecommendedContentEntity> _getTogetherMusic(
    MbtiInfo? userMbti,
    MbtiInfo? partnerMbti,
    double compatibility,
  ) {
    return [
      RecommendedContentEntity(
        id: 'music_together_1',
        title: 'Perfect - Ed Sheeran',
        subtitle: '커플이 함께 들으면 좋은',
        imageUrl: 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
        type: ContentType.music,
        rating: '9.3',
        gradientColors: [const Color(0xFFD53F8C), const Color(0xFFB83280)],
        matchPercentage: compatibility,
        reason: '사랑하는 사람과 함께 듣기 좋은 곡',
        tags: ['발라드', '로맨스', '커플'],
      ),
    ];
  }

  /// 🧮 MBTI 궁합도 계산 (간단한 알고리즘)
  double _calculateMbtiCompatibility(String userMbti, String partnerMbti) {
    if (userMbti.isEmpty || partnerMbti.isEmpty) return 80.0;

    int commonality = 0;
    for (int i = 0; i < 4 && i < userMbti.length && i < partnerMbti.length; i++) {
      if (userMbti[i] == partnerMbti[i]) commonality++;
    }

    // 0-4개의 공통점을 75-95% 범위로 매핑
    return 75.0 + (commonality * 5.0);
  }
}
