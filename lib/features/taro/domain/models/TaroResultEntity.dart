import 'package:flutter/foundation.dart';

/// 타로 상담 결과를 저장하기 위한 데이터 클래스(Entity)
@immutable
class TaroResultEntity {
  final String id; // 고유 ID (예: 타임스탬프 또는 UUID)
  final DateTime date; // 상담 날짜
  final String theme; // 상담 주제
  final String spreadName; // 사용한 스프레드 이름
  final String overallInterpretation; // AI 종합 해석
  final List<InterpretedCard> cardInterpretations; // 카드별 상세 해석 리스트

  const TaroResultEntity({
    required this.id,
    required this.date,
    required this.theme,
    required this.spreadName,
    required this.overallInterpretation,
    required this.cardInterpretations,
  });
}

/// 해석된 개별 카드 정보를 담는 데이터 클래스
@immutable
class InterpretedCard {
  final String cardId; // 'major_01'과 같은 카드 고유 ID
  final String cardName; // 'The Magician'
  final String positionName; // '현재 상황'
  final bool isReversed; // 역방향 여부
  final String subtitle; // AI가 생성한 한 줄 요약
  final String detailedText; // AI가 생성한 상세 설명

  const InterpretedCard({
    required this.cardId,
    required this.cardName,
    required this.positionName,
    required this.isReversed,
    required this.subtitle,
    required this.detailedText,
  });
}