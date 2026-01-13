import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/recommendation/domain/enums/rec_category.dart';

class CoverImageHelper {
  // 카테고리별 이미지 경로 리스트를 메모리에 캐싱
  static final Map<RecCategory, List<String>> _imagePaths = {};
  static bool _isLoaded = false;

  /// 🚀 초기화: AssetManifest를 읽어서 카테고리별로 분류
  static Future<void> init() async {
    if (_isLoaded) return;

    try {
      // 1. 앱의 모든 에셋 목록 로드
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // 2. 카테고리별 키워드 매핑
      // (RecCategory enum의 이름과 폴더명이 다를 수 있으므로 매핑)
      final categoryFolders = {
        RecCategory.MOVIE: 'assets/images/cover/movie',
        RecCategory.DRAMA: 'assets/images/cover/drama',
        RecCategory.GAME: 'assets/images/cover/game',
        RecCategory.BOOK: 'assets/images/cover/book', // 소설/웹툰 통합
        // RecCategory.MUSIC: 'assets/images/cover/music',
      };

      // 3. 에셋 목록을 순회하며 리스트에 담기
      for (var entry in categoryFolders.entries) {
        final category = entry.key;
        final folderPrefix = entry.value;

        // 해당 폴더 경로로 시작하는 파일들만 필터링 (.webp, .png, .jpg 등)
        final paths = manifestMap.keys
            .where((path) => path.startsWith(folderPrefix))
            .toList();

        _imagePaths[category] = paths;
      }

      _isLoaded = true;
      print('✅ 커버 이미지 로드 완료: ${_imagePaths.map((k, v) => MapEntry(k.name, v.length))}장');
    } catch (e) {
      print('⚠️ 커버 이미지 로드 실패: $e');
    }
  }

  /// 🖼️ 제목 기반 랜덤 이미지 경로 반환
  static String? getImagePath(RecCategory category, String title) {
    // 아직 로드가 안 됐거나, 해당 카테고리에 이미지가 없으면 null 반환
    final paths = _imagePaths[category];
    if (paths == null || paths.isEmpty) return null;

    // 제목의 해시값을 이용하여 "고정된 랜덤" 인덱스 선택
    // (같은 제목이면 항상 같은 이미지가 나옴)
    final int index = title.hashCode.abs() % paths.length;

    return paths[index];
  }
}