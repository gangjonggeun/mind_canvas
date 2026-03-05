import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/dto/channel_recommendation_response.dart';
import '../../domain/usecase/community_use_case.dart';

part 'channel_notifier.freezed.dart';
part 'channel_notifier.g.dart';

@freezed
class ChannelState with _$ChannelState {
  const factory ChannelState({
    @Default(false) bool isLoading,
    @Default([]) List<ChannelRecommendationResponse> myChannels,      // 내가 가입한 곳
    @Default([]) List<ChannelRecommendationResponse> recommendedChannels, // 추천 목록
    String? errorMessage,
  }) = _ChannelState;

  factory ChannelState.initial() => const ChannelState();
}

@Riverpod(keepAlive: true)
class ChannelNotifier extends _$ChannelNotifier {
  @override
  ChannelState build() {
    // 생성 시 데이터 바로 로드
    loadChannels();
    return ChannelState.initial();
  }
  Future<void> leaveChannel(String channelCode) async {
    // 1. ⚡ [낙관적 업데이트] API 호출 전에 UI부터 지워버림!
    final oldChannels = state.myChannels;
    final newChannels = oldChannels.where((c) => c.channel != channelCode).toList();

    // 즉시 반영
    state = state.copyWith(myChannels: newChannels);

    // 2. 서버 요청
    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.leaveChannel(channelCode);

    result.fold(
      onSuccess: (_) {
        // 이미 UI는 지워졌으므로 아무것도 안 해도 됨 (성공)
        print("✅ 채널 삭제 성공 (서버 동기화 완료)");
      },
      onFailure: (message, code) {
        // 3. 만약 진짜 네트워크 오류가 나면? -> 다시 롤백 (원상복구)
        print("❌ 채널 삭제 실패: $message");
        state = state.copyWith(
          myChannels: oldChannels, // 롤백
          errorMessage: message,
        );
      },
    );
  }

  /// 📢 채널 목록 불러오기 (내 채널 & 추천 채널 병렬 요청)
  /// 📢 채널 목록 불러오기
  Future<void> loadChannels() async {
    // 로딩 시작
    state = state.copyWith(isLoading: true, errorMessage: null);

    final useCase = ref.read(communityUseCaseProvider);

    final results = await Future.wait([
      useCase.getMyChannels(),
      useCase.getRecommendedChannels(),
    ]);

    final myChannelResult = results[0];
    final recChannelResult = results[1];

    List<ChannelRecommendationResponse> myChannels = [];
    List<ChannelRecommendationResponse> recChannels = [];
    String? error;

    // 1. 내 채널 처리
    myChannelResult.fold(
      onSuccess: (data) {
        myChannels = List.from(data); // 수정 가능한 리스트로 복사
      },
      onFailure: (msg, _) => error = msg,
    );

    // 2. 추천 채널 처리
    recChannelResult.fold(
      onSuccess: (data) => recChannels = data,
      onFailure: (msg, _) => error = error ?? msg,
    );

    // ✅ [핵심 수정] 'FREE' 채널 강제 주입 (기본 참여 처리)
    // 내 채널 목록에 FREE가 없으면 맨 앞에 추가해줍니다.
    final hasFree = myChannels.any((c) => c.channel == 'FREE');
    if (!hasFree) {
      const freeChannel = ChannelRecommendationResponse(
        channel: 'FREE',
        name: '자유 광장(ALL)',
        description: '모두가 자유롭게 이야기하는 곳',
        reason: '기본 제공',
        isJoined: true, // 강제로 true
      );
      // 맨 앞에 추가
      myChannels.insert(0, freeChannel);
    }

    state = state.copyWith(
      isLoading: false,
      myChannels: myChannels,
      recommendedChannels: recChannels,
      errorMessage: error,
    );
  }

  /// ➕ 채널 참여
  Future<void> joinChannel(String channelCode) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.joinChannel(channelCode);

    result.fold(
      onSuccess: (_) {
        // 성공 시 목록 재로딩 (가입됨 상태 반영을 위해)
        loadChannels();
      },
      onFailure: (message, code) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
      },
    );
  }
}