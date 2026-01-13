import 'package:json_annotation/json_annotation.dart';

/// 🏘️ 채널 타입 (MBTI 16종 + 특수 채널)
/// 서버의 ChannelType Enum과 대소문자가 정확히 일치해야 합니다.
enum ChannelType {
  // --- Analysts (분석가형) ---
  INTP, INTJ, ENTP, ENTJ,

  // --- Diplomats (외교관형) ---
  INFP, INFJ, ENFP, ENFJ,

  // --- Sentinels (관리자형) ---
  ISTJ, ISFJ, ESTJ, ESFJ,

  // --- Explorers (탐험가형) ---
  ISTP, ISFP, ESTP, ESFP,

  // --- Special ---
  FREE, // 자유게시판 (기본 제공)
  ETC   // 기타
}

/// 📝 게시글 카테고리 (말머리)
/// 서버의 PostCategory Enum과 일치해야 합니다.
enum PostCategory {
  CHAT,     // 잡담
  REVIEW,   // 후기/추천 (영화, 책 등 콘텐츠 첨부 시 주로 사용)
  QUESTION  // 질문
}