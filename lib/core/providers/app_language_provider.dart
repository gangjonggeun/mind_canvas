import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';

part 'app_language_provider.g.dart';

// ✅ 앱이 종료될 때까지 상태를 유지하기 위해 keepAlive: true 사용
@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {

  // Hive Box 이름과 Key 상수 정의 (오타 방지)
  static const String _boxName = 'settings';
  static const String _keyName = 'language';

  @override
  String build() {
    // 1. Hive Box 열기 (main.dart에서 미리 열어두는 것을 권장하지만, 여기서 안전하게 처리)
    // 주의: main()에서 await Hive.openBox('settings'); 를 했다고 가정합니다.
    final box = Hive.box(_boxName);

    // 2. 저장된 언어 가져오기 (없으면 기본값 'ko')
    return box.get(_keyName, defaultValue: 'ko') as String;
  }

  /// 🌐 언어 변경 (상태 업데이트 + Hive 저장)
  Future<void> setLanguage(String languageCode) async {
    await S.load(Locale(languageCode));
    // 1. 상태 업데이트 (UI 즉시 반영)
    state = languageCode;

    // 2. Hive에 영구 저장
    final box = Hive.box(_boxName);
    await box.put(_keyName, languageCode);
  }
}