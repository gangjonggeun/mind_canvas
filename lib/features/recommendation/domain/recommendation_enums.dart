// // lib/features/recommendation/domain/enums/recommendation_enums.dart
//
// /// 🎯 추천 컨텐츠 모드
// /// - personal: 개인 추천
// /// - together: 함께 보기 추천
// enum ContentMode {
//   personal,
//   together
// }
//
// /// 🎬 컨텐츠 타입
// /// - movie: 영화
// /// - drama: 드라마
// /// - music: 음악
// enum ContentType {
//   movie,
//   drama,
//   music
// }
//
// /// ContentMode 확장 메서드
// extension ContentModeExtension on ContentMode {
//   String get displayName {
//     switch (this) {
//       case ContentMode.personal:
//         return '당신을 위한 컨텐츠';
//       case ContentMode.together:
//         return '함께 보기 추천';
//     }
//   }
//
//   String get emoji {
//     switch (this) {
//       case ContentMode.personal:
//         return '🎯';
//       case ContentMode.together:
//         return '👥';
//     }
//   }
//
//   String get description {
//     switch (this) {
//       case ContentMode.personal:
//         return '성격에 맞는 컨텐츠!';
//       case ContentMode.together:
//         return '같이 즐기는 컨텐츠!';
//     }
//   }
// }
//
// /// ContentType 확장 메서드
// extension ContentTypeExtension on ContentType {
//   String get displayName {
//     switch (this) {
//       case ContentType.movie:
//         return '🎬 영화';
//       case ContentType.drama:
//         return '📺 드라마';
//       case ContentType.music:
//         return '🎵 음악';
//     }
//   }
// }