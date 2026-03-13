import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mind_canvas/features/profile/presentation/providers/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/profile_repository_impl.dart';
// 기존 DTO 및 레포지토리 import


part 'attendance_notifier.freezed.dart';
part 'attendance_notifier.g.dart';

@freezed
class AttendanceState with _$AttendanceState {
  const factory AttendanceState({
    @Default(false) bool isLoading,
    String? errorMessage,
    int? earnedCoins, // 서버에서 받은 최종 획득 코인
  }) = _AttendanceState;

  factory AttendanceState.initial() => const AttendanceState();
}

@riverpod
class AttendanceNotifier extends _$AttendanceNotifier {
  @override
  AttendanceState build() => AttendanceState.initial();

  Future<void> claimAttendance(double seconds) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(profileRepositoryProvider).claimAttendance(seconds);

    result.fold(
      onSuccess: (earnedCoins) {
        // ✅ 1. ProfileNotifier의 잔액 즉시 갱신
        ref.read(profileNotifierProvider.notifier).addCoins(earnedCoins);
        //배너 닫히게
        ref.read(profileNotifierProvider.notifier).setAttendanceComplete(earnedCoins);

        // 2. 출석 성공 상태 업데이트
        state = state.copyWith(isLoading: false, earnedCoins: earnedCoins);
      },
      onFailure: (msg, code) {
        // 🚨 서버에서 준 에러메시지와 코드(예: NETWORK_ERROR (404))가 그대로 msg에 담김
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }
}