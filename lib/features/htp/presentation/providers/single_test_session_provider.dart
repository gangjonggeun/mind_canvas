// lib/features/single_test/presentation/providers/single_test_session_provider.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../htp/domain/entities/htp_session_entity.dart';
import '../enum/single_test_type.dart';

class SingleTestSessionNotifier extends StateNotifier<HtpSessionEntity?> {
  final SingleTestType testType; // 현재 진행 중인 검사 타입

  late final String _boxName;
  static const String _sessionKey = 'current_session';

  late Box<String> _box;
  late Directory _imageDir;

  SingleTestSessionNotifier(this.testType) : super(null) {
    _boxName = 'session_box_${testType.name}'; // ex) session_box_starrySea
    _initialize();
  }

  // =============================================================
  // 1. 초기화 및 세션 관리
  // =============================================================

  Future<void> _initialize() async {
    try {
      // 1. Hive 박스 열기 (타입별로 다른 박스 사용)
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(_boxName);

      // 2. 이미지 디렉토리 설정 (타입별로 다른 폴더 사용)
      final appDir = await getApplicationDocumentsDirectory();
      _imageDir = Directory('${appDir.path}/${testType.name}_temp');
      if (!await _imageDir.exists()) {
        await _imageDir.create(recursive: true);
      }

      // 3. 저장된 세션 복원
      await _loadSession();

      print('✅ [Provider] ${testType.displayName} 세션 초기화 완료');
    } catch (e) {
      print('❌ [Provider] ${testType.displayName} 초기화 실패: $e');
    }
  }

  Future<void> startNewSession(String userId) async {
    final session = HtpSessionEntity(
      sessionId: '${testType.name}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      startTime: DateTime.now().millisecondsSinceEpoch,
      drawings: [], // 초기엔 빈 리스트
      supportsPressure: false,
    );
    state = session;
    await _saveSession();
    print('🆕 [Provider] ${testType.displayName} 새 세션 시작: ${session.sessionId}');
  }

  // =============================================================
  // 2. 상태 확인 Getter
  // =============================================================

  /// 그림 + PDI 모두 완료되었는지 확인
  bool get canComplete {
    if (state == null) return false;

    // 단일 검사이므로 그림 1개 필요
    final bool isDrawingComplete = state!.drawings.isNotEmpty;
    // PDI 답변이 존재하고 비어있지 않은지 확인
    final bool isPdiComplete = state!.pdiAnswers != null && state!.pdiAnswers!.isNotEmpty;

    return isDrawingComplete && isPdiComplete;
  }

  /// 현재 검사 타입에 맞는 그림 가져오기
  HtpDrawingEntity? getDrawing() {
    if (state == null) return null;
    final targetType = _mapToHtpType(testType);

    try {
      return state!.drawings.firstWhere((d) => d.type == targetType);
    } catch (_) {
      return null;
    }
  }

  // =============================================================
  // 3. 데이터 업데이트 (그림, PDI, 갤러리 업로드)
  // =============================================================

  /// 직접 그린 그림 업데이트
  Future<void> updateDrawing(HtpDrawingEntity drawing, File imageFile) async {
    if (state == null) return;

    try {
      final savedPath = await _saveImageFile(imageFile);
      final updatedDrawing = drawing.copyWith(imagePath: savedPath);

      state = state!.updateDrawing(updatedDrawing);
      await _saveSession();

      print('💾 [Provider] ${testType.displayName} 그림 업데이트 완료');
    } catch (e) {
      print('❌ [Provider] 그림 업데이트 실패: $e');
    }
  }

  /// 갤러리에서 불러온 이미지 업데이트
  Future<void> updateDrawingFromGallery(File imageFile) async {
    if (state == null) return;

    try {
      final savedPath = await _saveImageFile(imageFile);
      final targetType = _mapToHtpType(testType);

      // 갤러리 이미지는 메타데이터가 없으므로 기본값 처리
      final newDrawing = HtpDrawingEntity(
        type: targetType,
        imagePath: savedPath,
        sketchJson: null,
        strokeCount: 0,
        averagePressure: 0.5,
        // pressureData: [],
        startTime: DateTime.now().millisecondsSinceEpoch,
        endTime: DateTime.now().millisecondsSinceEpoch,
        // durationSeconds: 0,
        modificationCount: 0,
        // canvasWidth: 0,
        // canvasHeight: 0,
        // backgroundImage: null,
        orderIndex: 0,
      );

      state = state!.updateDrawing(newDrawing);
      await _saveSession();

      print('📸 [Provider] ${testType.displayName} 갤러리 업로드 완료');
    } catch (e) {
      print('❌ [Provider] 갤러리 업로드 실패: $e');
    }
  }

  /// PDI 질문지 답변 저장
  Future<void> savePdiAnswers(Map<String, String> answers) async {
    if (state == null) return;

    state = state!.copyWith(pdiAnswers: answers);
    await _saveSession();

    print('📝 [Provider] ${testType.displayName} PDI 답변 저장 완료: ${answers.length}문항');
  }

  // =============================================================
  // 4. 세션 종료 및 내부 헬퍼 메서드
  // =============================================================

  Future<void> completeSession() async {
    if (state == null) return;

    state = state!.copyWith(endTime: DateTime.now().millisecondsSinceEpoch);
    await _saveSession();
    print('✅ [Provider] ${testType.displayName} 세션 완료');
  }

  Future<void> clearSession() async {
    if (_imageDir.existsSync()) {
      await _imageDir.delete(recursive: true);
      await _imageDir.create();
    }
    await _box.delete(_sessionKey);
    state = null;
    print('🗑️ [Provider] ${testType.displayName} 세션 및 임시파일 초기화 완료');
  }

  Future<void> _saveSession() async {
    if (state == null) return;
    await _box.put(_sessionKey, state!.toJsonString());
  }

  Future<void> _loadSession() async {
    final jsonString = _box.get(_sessionKey);
    if (jsonString != null) {
      state = HtpSessionEntity.fromJsonString(jsonString);
      print('📂 [Provider] ${testType.displayName} 기존 세션 복원됨');
    }
  }

  Future<String> _saveImageFile(File imageFile) async {
    final fileName = '${testType.name}_${DateTime.now().millisecondsSinceEpoch}.png';
    final savePath = '${_imageDir.path}/$fileName';
    await imageFile.copy(savePath);
    return savePath;
  }

  /// 헬퍼: SingleTestType을 HtpType으로 변환
  HtpType _mapToHtpType(SingleTestType type) {
    switch (type) {
      case SingleTestType.starrySea:
        return HtpType.starrySea;
      case SingleTestType.pitr:
        return HtpType.pitr;
      case SingleTestType.fishbowl:
        return HtpType.fishbowl;
    }
  }


}

// =============================================================
// Provider 정의 (Riverpod Family 사용)
// =============================================================
final singleTestSessionProvider = StateNotifierProvider.family<SingleTestSessionNotifier, HtpSessionEntity?, SingleTestType>(
      (ref, testType) => SingleTestSessionNotifier(testType),
);