
import '../../../domain/entities/htp_session_entity.dart';

class HtpDataCollector {
  final List<double> _pressureValues = [];
  int _strokeCount = 0;
  int _modificationCount = 0;

  void addStroke(double pressure) {
    _strokeCount++;
    _pressureValues.add(pressure);
  }

  void addModification() {
    _modificationCount++;
  }

  int get strokeCount => _strokeCount;
  int get modificationCount => _modificationCount;

  double get averagePressure {
    if (_pressureValues.isEmpty) return 0.0;
    return _pressureValues.reduce((a, b) => a + b) / _pressureValues.length;
  }

  // ✅ 반환 타입을 HtpDrawingEntity로 변경
  HtpDrawingEntity createDrawing({
    required HtpType type,
    required int startTime,
    required int endTime,
    int orderIndex = 0, // ✅ 기본값 추가
  }) {
    return HtpDrawingEntity(
      type: type,
      startTime: startTime,
      endTime: endTime,
      strokeCount: _strokeCount,
      modificationCount: _modificationCount,
      averagePressure: averagePressure,
      orderIndex: orderIndex,
      // imagePath와 thumbnailPath는 나중에 추가
    );
  }

  // ✅ 필압 계산 헬퍼 (static)
  static double calculatePressureFromSpeed(double speed) {
    if (speed < 50) return 0.8;
    if (speed < 150) return 0.5;
    return 0.2;
  }

  void reset() {
    _strokeCount = 0;
    _modificationCount = 0;
    _pressureValues.clear();
  }
}