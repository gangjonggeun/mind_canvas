import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// json_annotation import는 이제 필요 없습니다.

part 'recommended_content_entity.freezed.dart';
part 'recommended_content_entity.g.dart';


/// 🎬 컨텐츠 타입 열거형
// @JsonEnum() 어노테이션을 삭제합니다. Freezed가 알아서 처리합니다.
enum ContentType {
  movie,
  drama,
  music;

  String get displayName {
    switch (this) {
      case ContentType.movie:
        return '🎬 영화';
      case ContentType.drama:
        return '📺 드라마';
      case ContentType.music:
        return '🎵 음악';
    }
  }

  IconData get icon {
    switch (this) {
      case ContentType.movie:
        return Icons.movie_outlined;
      case ContentType.drama:
        return Icons.tv;
      case ContentType.music:
        return Icons.music_note;
    }
  }
}

/// 컨텐츠 모드 열거형 (개인 추천 vs 함께 보기)
// @JsonEnum() 어노테이션을 삭제합니다.
enum ContentMode {
  personal,
  together;

  String get displayName {
    switch (this) {
      case ContentMode.personal:
        return '당신을 위한 컨텐츠';
      case ContentMode.together:
        return '함께 보기 추천';
    }
  }

  String get description {
    switch (this) {
      case ContentMode.personal:
        return '성격에 맞는 영화, 드라마, 노래를 추천해드려요';
      case ContentMode.together:
        return '두 사람이 함께 즐길 수 있는 컨텐츠를 추천해드려요';
    }
  }

  String get emoji {
    switch (this) {
      case ContentMode.personal:
        return '🎬';
      case ContentMode.together:
        return '👥';
    }
  }
}

/// 🎯 추천 컨텐츠 엔티티
@freezed
// @JsonSerializable() 어노테이션을 삭제합니다.
class RecommendedContentEntity with _$RecommendedContentEntity {

  const factory RecommendedContentEntity({
    required String id,
    required String title,
    required String subtitle,
    required String imageUrl,
    required ContentType type,
    required String rating,
    @JsonKey(ignore: true)
    @Default(const [const Color(0xFF667EEA), const Color(0xFF764BA2)]) List<Color> gradientColors,
    @Default([]) List<String> tags,
    @Default(0.0) double matchPercentage,
    @Default('') String reason,
    DateTime? createdAt,
  }) = _RecommendedContentEntity;

  // 이 fromJson 팩토리 메소드는 그대로 둡니다.
  // 이 코드가 바로 Freezed에게 "JSON 생성 기능이 필요해!"라고 알려주는 신호입니다.
  factory RecommendedContentEntity.fromJson(Map<String, dynamic> json) => _$RecommendedContentEntityFromJson(json);
}

/// 📱 MBTI 정보 엔티티
@freezed
// @JsonSerializable() 어노테이션을 삭제합니다.
class MbtiInfo with _$MbtiInfo {

  const factory MbtiInfo({
    required String type,
    @Default('') String description,
  }) = _MbtiInfo;

  factory MbtiInfo.fromJson(Map<String, dynamic> json) => _$MbtiInfoFromJson(json);
}

/// 🎬 추천 컨텐츠 섹션 상태
@freezed
// @JsonSerializable() 어노테이션을 삭제합니다.
class RecommendedContentState with _$RecommendedContentState {

  const factory RecommendedContentState({
    @Default([]) List<RecommendedContentEntity> contents,
    @Default(ContentType.movie) ContentType selectedContentType,
    @Default(ContentMode.personal) ContentMode selectedContentMode,
    @Default(const MbtiInfo(type: 'ENFP')) MbtiInfo userMbti,
    @Default(const MbtiInfo(type: 'ISFJ')) MbtiInfo partnerMbti,
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
  }) = _RecommendedContentState;

  factory RecommendedContentState.fromJson(Map<String, dynamic> json) => _$RecommendedContentStateFromJson(json);
}