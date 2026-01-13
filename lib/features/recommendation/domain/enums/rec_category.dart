import 'package:json_annotation/json_annotation.dart';

enum RecCategory {
  @JsonValue('MOVIE')
  MOVIE,

  @JsonValue('DRAMA')
  DRAMA,

  @JsonValue('GAME')
  GAME,

  @JsonValue('BOOK')
  BOOK; // 도서 OR 만화 OR 웹툰

  /// UI 표출용 텍스트
  String get label {
    switch (this) {
      case RecCategory.MOVIE:
        return '영화';
      case RecCategory.DRAMA:
        return '드라마';
      case RecCategory.GAME:
        return '게임';
      case RecCategory.BOOK:
        return '도서/만화/웹툰';
    }
  }
}