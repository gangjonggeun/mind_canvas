/// 🌐 추천 시스템 다국어 지원
/// 
/// 추천 관련 모든 텍스트의 다국어 지원을 위한 상수 클래스
/// - 한국어, 영어 지원
/// - 확장 가능한 구조
class RecommendationStrings {
  RecommendationStrings._();

  // 메인 화면
  static const String mainTitle = '✨ 맞춤 추천';
  static const String mainSubtitle = '당신의 성격에 맞는 특별한 추천';
  
  // 성격 기반 추천
  static const String personalityRecommendation = '🎯 성격 기반 컨텐츠 추천';
  static const String personalitySubtitle = '당신의 성격에 딱 맞는 드라마, 영화, 게임을 만나보세요';
  static const String viewAll = '전체보기';
  static const String todaysRecommendation = '✨ 오늘의 추천';
  
  // 카테고리
  static const String dramaMovie = '드라마 & 영화';
  static const String dramaMovieSubtitle = '당신의 취향에 맞는\n작품 추천';
  static const String game = '게임';
  static const String gameSubtitle = '성격에 맞는\n게임 장르 추천';
  static const String bookWebtoon = '소설 & 웹툰';
  static const String bookWebtoonSubtitle = '몰입할 수 있는\n스토리 추천';
  static const String musicPlaylist = '음악 & 플레이리스트';
  static const String musicPlaylistSubtitle = '감성에 어울리는\n음악 추천';
  
  // 이상형 월드컵
  static const String worldCupTitle = '🏆 재미있는 테스트';
  static const String worldCupSubtitle = '이상형 월드컵을 통해 취향을 발견하고 데이터를 수집해요';
  static const String foodPreference = '음식 취향';
  static const String foodPreferenceSubtitle = '당신의 음식 취향을 알아보세요';
  static const String movieGenre = '영화 장르';
  static const String movieGenreSubtitle = '선호하는 영화 장르 발견';
  static const String travelStyle = '여행 스타일';
  static const String travelStyleSubtitle = '이상적인 여행 스타일 찾기';
  static const String musicTaste = '음악 취향';
  static const String musicTasteSubtitle = '좋아하는 음악 스타일 분석';
  
  // 사용자 추천
  static const String userRecommendation = '👥 사용자 추천';
  static const String userRecommendationSubtitle = '비슷한 성격의 사용자들이 추천한 컨텐츠';
  static const String similarUsers = '비슷한 성격 사용자들';
  static const String similarUsersFound = '명의 유사한 성격 사용자 발견';
  
  // 공통 액션
  static const String save = '저장';
  static const String detail = '자세히';
  static const String helpful = '도움됨';
  static const String notHelpful = '별로';
  static const String recommend = '추천하기';
  static const String retry = '다시 플레이';
  static const String refresh = '새로고침';
  static const String close = '닫기';
  static const String cancel = '취소';
  static const String confirm = '확인';
  
  // 성격 특성
  static const String creative = '🎨 창의적';
  static const String social = '🤝 사교적';
  static const String planned = '📝 계획적';
  static const String adventurous = '🌟 모험적';
  static const String curious = '💡 호기심';
  
  // 피드백
  static const String feedbackStats = '📊 추천 성과';
  static const String totalRecommendations = '📝 총 추천';
  static const String averageScore = '⭐ 평균 점수';
  static const String recentFeedback = '📋 최근 피드백';
  
  // 오류 및 안내 메시지
  static const String noRecommendations = '추천할 컨텐츠가 없습니다';
  static const String loadingRecommendations = '추천을 불러오는 중...';
  static const String errorLoadingRecommendations = '추천을 불러오는데 실패했습니다';
  static const String savedSuccessfully = '추천이 저장되었습니다';
  static const String feedbackSubmitted = '피드백이 제출되었습니다';
  
  // 월드컵 관련
  static const String round16 = '16강';
  static const String round8 = '8강';
  static const String semifinal = '준결승';
  static const String final_round = '결승';
  static const String winner = '🏆 우승!';
  static const String personalityAnalysisComplete = '🧠 취향 분석 완료';
  static const String dataCollectionNote = '이 데이터는 더 정확한 추천을 위해 활용됩니다';
  
  // 설정
  static const String settings = '⚙️ 추천 설정';
  static const String refreshRecommendations = '추천 새로고침';
  static const String refreshSubtitle = '최신 데이터로 다시 분석';
  static const String filterSettings = '필터 설정';
  static const String filterSubtitle = '관심 분야 및 장르 조정';
  static const String provideFeedback = '피드백 제공';
  static const String feedbackSubtitle = '추천 정확도 개선에 도움';
  
  // 팁
  static const String recommendationTips = '💡 추천 팁';
  static const String tip1 = '🎯 구체적인 이유를 포함해서 추천해주세요';
  static const String tip2 = '💝 자신이 정말 좋아하는 컨텐츠를 추천해주세요';
  static const String tip3 = '🔍 비슷한 성격의 사람이 좋아할만한 것을 생각해보세요';
  static const String tip4 = '📝 솔직한 피드백으로 추천 품질을 높여주세요';
}

/// 🌐 영어 번역 (추후 확장용)
class RecommendationStringsEn {
  RecommendationStringsEn._();

  static const String mainTitle = '✨ Personalized Recommendations';
  static const String mainSubtitle = 'Special recommendations tailored to your personality';
  
  static const String personalityRecommendation = '🎯 Personality-Based Content Recommendations';
  static const String personalitySubtitle = 'Discover dramas, movies, and games perfect for your personality';
  
  static const String viewAll = 'View All';
  static const String todaysRecommendation = '✨ Today\'s Recommendations';
  
  // 카테고리
  static const String dramaMovie = 'Drama & Movies';
  static const String game = 'Games';
  static const String bookWebtoon = 'Books & Webtoons';
  static const String musicPlaylist = 'Music & Playlists';
  
  // 공통 액션
  static const String save = 'Save';
  static const String detail = 'Details';
  static const String helpful = 'Helpful';
  static const String notHelpful = 'Not Helpful';
  static const String recommend = 'Recommend';
  static const String retry = 'Try Again';
  static const String refresh = 'Refresh';
  static const String close = 'Close';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
}
