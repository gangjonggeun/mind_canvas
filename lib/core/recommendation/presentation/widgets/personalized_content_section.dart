import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../data/mock_content_data.dart';

/// 🎯 추천 컨텐츠 모드
enum ContentMode {
  personal,
  together
}

/// 🎬 확장된 컨텐츠 타입 - 한국 트렌드 반영
enum ContentType {
  movie,     // 🎬 영화
  drama,     // 📺 드라마
  music,     // 🎵 음악
  book,      // 📚 도서 (소설 + 웹소설)
  webtoon,   // 📱 웹툰 (만화 포함)
  game,      // 🎮 게임
}

/// ContentMode 확장 메서드
extension ContentModeExtension on ContentMode {
  String get displayName {
    switch (this) {
      case ContentMode.personal:
        return '당신을 위한 컨텐츠';
      case ContentMode.together:
        return '함께 보기 추천';
    }
  }

  String get emoji {
    switch (this) {
      case ContentMode.personal:
        return '🎯';
      case ContentMode.together:
        return '👥';
    }
  }

  String get description {
    switch (this) {
      case ContentMode.personal:
        return '성격에 맞는 컨텐츠!';
      case ContentMode.together:
        return '같이 즐기는 컨텐츠!';
    }
  }
}

/// ContentType 확장 메서드 - 새로운 타입 추가
extension ContentTypeExtension on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.movie:
        return '🎬 영화';
      case ContentType.drama:
        return '📺 드라마';
      case ContentType.music:
        return '🎵 음악';
      case ContentType.book:
        return '📚 도서';
      case ContentType.webtoon:
        return '📱 웹툰';
      case ContentType.game:
        return '🎮 게임';
    }
  }

  /// 컨텐츠 타입별 설명
  String get description {
    switch (this) {
      case ContentType.movie:
        return '영화 추천';
      case ContentType.drama:
        return '드라마 추천';
      case ContentType.music:
        return '음악 추천';
      case ContentType.book:
        return '소설·웹소설 추천';
      case ContentType.webtoon:
        return '웹툰·만화 추천';
      case ContentType.game:
        return '게임 추천';
    }
  }

  /// 컨텐츠 타입별 색상 테마
  Color get themeColor {
    switch (this) {
      case ContentType.movie:
        return const Color(0xFF3182CE); // 파란색
      case ContentType.drama:
        return const Color(0xFFE53E3E); // 빨간색
      case ContentType.music:
        return const Color(0xFF38A169); // 초록색
      case ContentType.book:
        return const Color(0xFF805AD5); // 보라색
      case ContentType.webtoon:
        return const Color(0xFFD69E2E); // 노란색
      case ContentType.game:
        return const Color(0xFF00B5D8); // 청록색
    }
  }
}

/// 🎯 개인화된 컨텐츠 섹션 위젯
///
/// 메모리 최적화:
/// - StatefulWidget으로 내부 상태만 관리
/// - 조건부 렌더링으로 불필요한 위젯 제거
/// - const 생성자 및 final 변수 활용
/// - dispose에서 리소스 정리
class PersonalizedContentSection extends StatefulWidget {
  static final _logger = Logger('PersonalizedContentSection');

  final String userMbti;
  final String? initialPartnerMbti;
  final ContentMode? initialMode;
  final ContentType? initialType;
  final VoidCallback? onContentTap;
  final bool showMbtiInput;

  const PersonalizedContentSection({
    super.key,
    required this.userMbti,
    this.initialPartnerMbti,
    this.initialMode,
    this.initialType,
    this.onContentTap,
    this.showMbtiInput = true,
  });

  @override
  State<PersonalizedContentSection> createState() => _PersonalizedContentSectionState();
}

class _PersonalizedContentSectionState extends State<PersonalizedContentSection> {
  static final _logger = Logger('_PersonalizedContentSectionState');

  late ContentMode _selectedContentMode;
  late ContentType _selectedContentType;
  late String _partnerMbti;

  @override
  void initState() {
    super.initState();
    _selectedContentMode = widget.initialMode ?? ContentMode.personal;
    _selectedContentType = widget.initialType ?? ContentType.movie;
    _partnerMbti = widget.initialPartnerMbti ?? 'ENTJ';

    _logger.info('PersonalizedContentSection initialized - Mode: $_selectedContentMode, Type: $_selectedContentType');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildPersonalizedContentSection(isDark);
  }

  /// 🎯 메인 컨텐츠 섹션 빌드
  Widget _buildPersonalizedContentSection(bool isDark) {
    Color cardColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    Color textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
    Color subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 메모리 최적화
        children: [
          // 섹션 헤더: 모드 전환 기능 포함
          _buildSectionHeader(textColor, subTextColor),
          const SizedBox(height: 20),

          // '함께 보기' 모드일 때만 보이는 MBTI 입력 섹션
          if (_selectedContentMode == ContentMode.together && widget.showMbtiInput) ...[
            _buildMbtiInputSection(isDark),
            const SizedBox(height: 20),
          ],

          // 컨텐츠 카테고리 탭
          _buildContentTabs(isDark),
          const SizedBox(height: 16),

          // 추천 컨텐츠 리스트
          _buildContentList(),
        ],
      ),
    );
  }

  /// 📋 섹션 헤더 빌드 - 확장 메서드 사용
  Widget _buildSectionHeader(Color textColor, Color subTextColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _selectedContentType.themeColor.withOpacity(0.1), // 타입별 색상 적용
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _selectedContentMode.emoji, // 확장 메서드 사용
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedContentMode.displayName, // 확장 메서드 사용
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                _selectedContentType.description, // 선택된 타입의 설명
                style: TextStyle(fontSize: 14, color: subTextColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _toggleContentMode,
          icon: Icon(
            _selectedContentMode == ContentMode.personal ? Icons.group_add_outlined : Icons.person_outline,
            color: _selectedContentType.themeColor, // 타입별 색상 적용
          ),
          tooltip: _selectedContentMode == ContentMode.personal ? '함께 보기 모드로 전환' : '개인 추천 모드로 전환',
        ),
      ],
    );
  }

  /// 💕 MBTI 입력 섹션 빌드
  Widget _buildMbtiInputSection(bool isDark) {
    Color subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);
    Color boxColor = isDark ? const Color(0xFF4A5568) : Colors.white;
    Color borderColor = isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0);
    Color textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _selectedContentType.themeColor.withOpacity(isDark ? 0.2 : 0.1), // 타입별 색상 적용
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('나의 MBTI', style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: boxColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.userMbti, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.favorite, color: _selectedContentType.themeColor, size: 20), // 타입별 색상 적용
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('상대방 MBTI', style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showMbtiSelector,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_partnerMbti, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(width: 8),
                        Icon(Icons.edit, size: 16, color: subTextColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎬 컨텐츠 탭 빌드 - 스크롤 가능한 가로 탭
  Widget _buildContentTabs(bool isDark) {
    return SizedBox(
      height: 45, // 높이 고정으로 메모리 최적화
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ContentType.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = ContentType.values[index];
          return _buildContentTab(type.displayName, type, isDark); // 확장 메서드 사용
        },
      ),
    );
  }

  /// 📺 개별 컨텐츠 탭 위젯 - 타입별 색상 테마 적용
  Widget _buildContentTab(String title, ContentType type, bool isDark) {
    final isSelected = _selectedContentType == type;
    final themeColor = type.themeColor;

    return GestureDetector(
      onTap: () => _changeContentType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor
              : (isDark ? const Color(0xFF4A5568) : const Color(0xFFEDF2F7)),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: themeColor.withOpacity(0.3), width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : themeColor),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// 📜 컨텐츠 리스트 빌드
  Widget _buildContentList() {
    final contentList = _getContentList();

    if (contentList.isEmpty) {
      return _buildEmptyContentWidget();
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: contentList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final content = contentList[index];
          return _buildContentCard(content);
        },
      ),
    );
  }

  /// 📭 빈 컨텐츠 위젯
  Widget _buildEmptyContentWidget() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_off_outlined,
            size: 48,
            color: textColor.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            '준비 중인 컨텐츠입니다',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '곧 다양한 ${_selectedContentType.description}을 만나보세요!',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎭 추천 컨텐츠 카드 위젯 - 실제 사용 중인 코드 그대로
  Widget _buildContentCard(Map<String, dynamic> content) {
    return GestureDetector(
      onTap: () {
        _logger.info('Content tapped: ${content['title']} (${_selectedContentType.displayName})');
        widget.onContentTap?.call();
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 이미지 로딩 최적화
              Image.network(
                content['imageUrl']!,
                fit: BoxFit.cover,
                cacheWidth: 300, // 메모리 최적화
                cacheHeight: 360, // 메모리 최적화
                errorBuilder: (context, error, stackTrace) {
                  _logger.warning('Failed to load image: ${content['imageUrl']}');
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getContentTypeIcon(_selectedContentType),
                          color: Colors.grey,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedContentType.displayName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: _selectedContentType.themeColor,
                      ),
                    ),
                  );
                },
              ),
              // 그라디언트 오버레이
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      (content['gradientColors'] as List<Color>?)?.first.withOpacity(0.3) ??
                          _selectedContentType.themeColor.withOpacity(0.3),
                      (content['gradientColors'] as List<Color>?)?.last.withOpacity(0.9) ??
                          _selectedContentType.themeColor.withOpacity(0.9)
                    ],
                    stops: const [0.3, 0.6, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // 하단 텍스트 정보
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      content['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: [Shadow(blurRadius: 2)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content['subtitle']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        shadows: const [Shadow(blurRadius: 2)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 평점 배지
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getRatingIcon(_selectedContentType),
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content['rating']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 컨텐츠 타입 표시 배지
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _selectedContentType.themeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getContentTypeLabel(_selectedContentType),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 유틸리티 메서드들 ---

  /// 컨텐츠 타입별 아이콘 반환
  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.movie:
        return Icons.movie_outlined;
      case ContentType.drama:
        return Icons.tv_outlined;
      case ContentType.music:
        return Icons.music_note_outlined;
      case ContentType.book:
        return Icons.menu_book_outlined;
      case ContentType.webtoon:
        return Icons.auto_stories_outlined;
      case ContentType.game:
        return Icons.sports_esports_outlined;
    }
  }

  /// 컨텐츠 타입별 평점 아이콘 반환
  IconData _getRatingIcon(ContentType type) {
    switch (type) {
      case ContentType.movie:
      case ContentType.drama:
        return Icons.star_rounded;
      case ContentType.music:
        return Icons.favorite;
      case ContentType.book:
      case ContentType.webtoon:
        return Icons.thumb_up_rounded;
      case ContentType.game:
        return Icons.videogame_asset_rounded;
    }
  }

  /// 컨텐츠 타입별 라벨 반환
  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.movie:
        return 'MOVIE';
      case ContentType.drama:
        return 'DRAMA';
      case ContentType.music:
        return 'MUSIC';
      case ContentType.book:
        return 'BOOK';
      case ContentType.webtoon:
        return 'TOON';
      case ContentType.game:
        return 'GAME';
    }
  }

  // --- 로직 및 이벤트 처리 함수들 ---

  /// 컨텐츠 모드 토글
  void _toggleContentMode() {
    setState(() {
      _selectedContentMode = _selectedContentMode == ContentMode.personal
          ? ContentMode.together
          : ContentMode.personal;
    });
    _logger.info('Content mode changed to: $_selectedContentMode');
  }

  /// 컨텐츠 타입 변경
  void _changeContentType(ContentType type) {
    if (_selectedContentType != type) {
      setState(() {
        _selectedContentType = type;
      });
      _logger.info('Content type changed to: $type');
    }
  }

  /// 컨텐츠 리스트 가져오기 - 확장된 타입 지원
  List<Map<String, dynamic>> _getContentList() {
    try {
      if (_selectedContentMode == ContentMode.together) {
        switch (_selectedContentType) {
          case ContentType.movie:
            return MockContentData.getTogetherMovieList(widget.userMbti, _partnerMbti);
          case ContentType.drama:
            return MockContentData.getTogetherDramaList(widget.userMbti, _partnerMbti);
          case ContentType.music:
            return MockContentData.getTogetherMusicList(widget.userMbti, _partnerMbti);
          case ContentType.book:
            return MockContentData.getTogetherBookList(widget.userMbti, _partnerMbti);
          case ContentType.webtoon:
            return MockContentData.getTogetherWebtoonList(widget.userMbti, _partnerMbti);
          case ContentType.game:
            return MockContentData.getTogetherGameList(widget.userMbti, _partnerMbti);
        }
      } else {
        switch (_selectedContentType) {
          case ContentType.movie:
            return MockContentData.getMovieList();
          case ContentType.drama:
            return MockContentData.getDramaList();
          case ContentType.music:
            return MockContentData.getMusicList();
          case ContentType.book:
            return MockContentData.getBookList();
          case ContentType.webtoon:
            return MockContentData.getWebtoonList();
          case ContentType.game:
            return MockContentData.getGameList();
        }
      }
    } catch (e) {
      _logger.warning('Error getting content list for $_selectedContentType: $e');
      return [];
    }
  }

  /// 파트너 MBTI 선택 BottomSheet
  void _showMbtiSelector() {
    final mbtiTypes = MockContentData.getMbtiTypes();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '상대방의 MBTI를 선택해주세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: mbtiTypes.map((mbti) {
                  return ChoiceChip(
                    label: Text(mbti),
                    selected: _partnerMbti == mbti,
                    selectedColor: _selectedContentType.themeColor,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          _partnerMbti = mbti;
                        });
                        Navigator.pop(context);
                        _logger.info('Partner MBTI changed to: $_partnerMbti');
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _logger.info('PersonalizedContentSection disposed - Last selected: $_selectedContentType');
    super.dispose();
  }
}