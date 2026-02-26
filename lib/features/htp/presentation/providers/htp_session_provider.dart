// features/htp/presentation/providers/htp_session_provider.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/htp_session_entity.dart';

/// 🎨 HTP 세션 상태 관리 Provider
///
/// **책임:**
/// - 현재 작업 중인 세션 관리
/// - 로컬 저장/복원
/// - 진행 상태 추적
class HtpSessionNotifier extends StateNotifier<HtpSessionEntity?> {
  static const String _boxName = 'htp_current_session';
  static const String _sessionKey = 'session';

  late Box<String> _box;
  late Directory _imageDir;

  HtpSessionNotifier() : super(null) {
    _initialize();
  }
  // 👇 [추가] 갤러리 이미지 업로드 전용 메서드
  Future<void> updateDrawingFromGallery(HtpType type, File imageFile) async {
    if (state == null) return;

    try {
      // 1. 이미지 파일 로컬 저장
      final savedPath = await _saveImageFile(imageFile, type);

      // 2. 기존 그림 데이터 확인 (순서 유지용)
      final existingDrawing = getDrawing(type);

      // 3. 순서(Order) 결정: 기존 것이면 유지, 새 것이면 리스트 맨 뒤
      final int orderIndex = existingDrawing?.orderIndex ?? state!.drawings.length;

      // 4. 엔티티 생성
      // 갤러리 업로드는 압력, 그리기 시간, 획수 등의 메타데이터가 없으므로 기본값 처리
      final newDrawing = HtpDrawingEntity(
        type: type,
        imagePath: savedPath,
        sketchJson: null,       // 스케치 데이터 없음
        strokeCount: 0,         // 획수 0
        averagePressure: 0.5,   // 압력 중간값(기본)
        // pressureData: [],       // 압력 상세 데이터 빈 리스트
        startTime: DateTime.now().millisecondsSinceEpoch, // 업로드 시점
        endTime: DateTime.now().millisecondsSinceEpoch,   // 즉시 완료 처리
        // durationSeconds: 0,     // 소요 시간 0
        modificationCount: 0,   // 수정 횟수 0
        // canvasWidth: 0,         // 캔버스 크기 알 수 없음 (0 처리)
        // canvasHeight: 0,
        // backgroundImage: null,  // 배경 없음
        orderIndex: orderIndex, // 순서 할당
      );

      // 5. 상태 업데이트
      state = state!.updateDrawing(newDrawing);
      await _saveSession();

      print('📸 [Provider] 갤러리 이미지 업로드 완료: ${type.name} (path: $savedPath)');
    } catch (e) {
      print('❌ [Provider] 갤러리 업로드 실패: $e');
    }
  }

  /// 초기화
  Future<void> _initialize() async {
    try {
      // Hive 박스 열기
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(_boxName);

      // 이미지 디렉토리 설정
      final appDir = await getApplicationDocumentsDirectory();
      _imageDir = Directory('${appDir.path}/htp_temp');
      if (!await _imageDir.exists()) {
        await _imageDir.create(recursive: true);
      }

      // 저장된 세션 복원
      await _loadSession();

      print('✅ [Provider] HTP 세션 Provider 초기화 완료');
    } catch (e) {
      print('❌ [Provider] 초기화 실패: $e');
    }
  }

  /// 새 세션 시작
  Future<void> startNewSession(String userId) async {
    final session = HtpSessionEntity(
      sessionId: 'htp_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      startTime: DateTime.now().millisecondsSinceEpoch,
      drawings: [],
      supportsPressure: false,
    );

    state = session;
    await _saveSession();
    print('🆕 [Provider] 새 세션 시작: ${session.sessionId}');
  }

  /// 그림 추가/수정
  /// 그림 추가/수정
  Future<void> updateDrawing(HtpDrawingEntity drawing, File imageFile) async {
    if (state == null) return;

    try {
      // 1. 이미지 파일 저장
      final savedPath = await _saveImageFile(imageFile, drawing.type);
      final updatedDrawing = drawing.copyWith(imagePath: savedPath);

      // 2. Entity의 비즈니스 로직 사용
      state = state!.updateDrawing(updatedDrawing);
      await _saveSession();

      print('💾 [Provider] 진행 상태: ${state!.progress * 100}%');
    } catch (e) {
      print('❌ [Provider] 그림 업데이트 실패: $e');
    }
  }

  /// 세션 완료 (서버 전송 전)
  Future<void> completeSession() async {
    if (state == null) return;

    state = state!.copyWith(
      endTime: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveSession();
    print('✅ [Provider] 세션 완료: ${state!.sessionId}');
  }

  /// 세션 초기화 (전송 완료 후)
  Future<void> clearSession() async {
    // 임시 이미지 파일 삭제
    if (_imageDir.existsSync()) {
      await _imageDir.delete(recursive: true);
      await _imageDir.create();
    }

    // Hive에서 삭제
    await _box.delete(_sessionKey);
    state = null;

    print('🗑️ [Provider] 세션 초기화 완료');
  }

  // =============================================================
  // Private 메서드
  // =============================================================

  /// 세션 저장
  Future<void> _saveSession() async {
    if (state == null) return;
    await _box.put(_sessionKey, state!.toJsonString());
  }

  /// 세션 로드
  Future<void> _loadSession() async {
    final jsonString = _box.get(_sessionKey);
    if (jsonString != null) {
      state = HtpSessionEntity.fromJsonString(jsonString);
      print('📂 [Provider] 세션 복원: ${state!.sessionId}');
      print('   - 그림 개수: ${state!.drawings.length}');
    }
  }

  /// 이미지 파일 저장
  Future<String> _saveImageFile(File imageFile, HtpType type) async {
    final fileName = '${type.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}.png';
    final savePath = '${_imageDir.path}/$fileName';
    await imageFile.copy(savePath);
    return savePath;
  }

  // =============================================================
  // Getters
  // =============================================================

  /// 완료된 그림 개수
  int get completedCount => state?.drawings.length ?? 0;

  /// 완료 가능 여부
  bool get canComplete => completedCount == 3;

  /// 특정 타입 그림 가져오기
  HtpDrawingEntity? getDrawing(HtpType type) {
    if (state == null) return null;

    try {
      return state!.drawings.firstWhere((d) => d.type == type);
    } catch (_) {
      return null; // ✅ 찾지 못하면 null 반환
    }
  }


}

/// Provider 정의
final htpSessionProvider = StateNotifierProvider<HtpSessionNotifier, HtpSessionEntity?>(
      (ref) => HtpSessionNotifier(),
);

/// 편의 Provider들
final htpCompletedCountProvider = Provider<int>((ref) {
  return ref.watch(htpSessionProvider.notifier).completedCount;
});

final htpCanCompleteProvider = Provider<bool>((ref) {
  return ref.watch(htpSessionProvider.notifier).canComplete;
});