import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attendance_notifier.dart';

class AttendanceHelper {
  static int getMinCoins(int day) => min(5 + (max(1, day) - 1), 10);
  static int getMaxCoins(int day) => min(10 + (max(1, day) - 1), 15);

  // 💡 결정론적 보상 계산기
  static int calculateReward(double seconds, int day) {
    int minCoins = getMinCoins(day);
    int maxCoins = getMaxCoins(day);

    double error = (3.0 - seconds).abs();
    int penalty = (error * 10).toInt();

    int reward = max(minCoins, maxCoins - penalty);

    // 💡 [추가] 완벽 타이밍 보너스 (서버와 동일하게)
    if (error <= 0.05) {
      reward += 5;
    }

    // maxCoins에서 페널티를 빼되, minCoins보다는 작아지지 않게 함
    return reward;
  }
}

/// 1️⃣ 프로필 화면에 들어갈 [출석 배너 위젯]
class TarotAttendanceBanner extends StatelessWidget {
  final int consecutiveDays; // 연속 출석 일수 (서버/로컬에서 받아옴)
  final bool isTodayCheckedIn;

  const TarotAttendanceBanner({
    super.key,
    required this.consecutiveDays,
    required this.isTodayCheckedIn, // ✅ 추가
  });

  @override
  Widget build(BuildContext context) {
    // 1. 상태에 따른 디자인 값 정의
    final Color bgColorStart =
        isTodayCheckedIn ? const Color(0xFF606060) : const Color(0xFF2C3E50);
    final Color bgColorEnd =
        isTodayCheckedIn ? const Color(0xFF808080) : const Color(0xFF4CA1AF);
    final String title = isTodayCheckedIn ? '오늘의 운명 확인 완료' : '오늘의 운명의 타로 뽑기';
    final String subTitle =
        isTodayCheckedIn ? '내일 다시 새로운 잉크를 받으러 오세요!' : '마음속으로 3초를 세고 잉크를 획득하세요!';
    final IconData trailingIcon =
        isTodayCheckedIn ? Icons.check_circle : Icons.chevron_right;

    return GestureDetector(
      onTap: isTodayCheckedIn
          ? null // 완료 시 클릭 차단
          : () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    TarotMiniGameDialog(consecutiveDays: consecutiveDays),
              );
            },
      child: AnimatedContainer(
        // 상태 변경 시 자연스러운 전환을 위해 AnimatedContainer 사용
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [bgColorStart, bgColorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isTodayCheckedIn ? 0.05 : 0.2),
              // 완료 시 그림자도 연하게
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 카드 아이콘 영역 (완료 시 체크 이모지로 변경 가능)
            Container(
              width: 40,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isTodayCheckedIn ? 0.1 : 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isTodayCheckedIn
                      ? Colors.white30
                      : Colors.amber.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  isTodayCheckedIn ? '✅' : '🃏',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isTodayCheckedIn ? Colors.white70 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: isTodayCheckedIn ? Colors.white38 : Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // 우측 아이콘 변경 (화살표 -> 체크)
            Icon(trailingIcon,
                color:
                    isTodayCheckedIn ? Colors.lightGreenAccent : Colors.white),
          ],
        ),
      ),
    );
  }
}

/// 2️⃣ [3초 타임 미니게임 다이얼로그]
enum GameState { ready, playing, finished }

class TarotMiniGameDialog extends ConsumerStatefulWidget {
  final int consecutiveDays;

  const TarotMiniGameDialog({super.key, required this.consecutiveDays});

  @override
  ConsumerState<TarotMiniGameDialog> createState() =>
      _TarotMiniGameDialogState(); // 💡
}

class _TarotMiniGameDialogState extends ConsumerState<TarotMiniGameDialog> with SingleTickerProviderStateMixin {
  GameState _gameState = GameState.ready;
  DateTime? _startTime;

  double _elapsedSeconds = 0.0;
  int _earnedCoins = 0;

  String _cardImage =
      'assets/illustrations/taro/card_back_2_high.webp'; // 뒷면 이미지 (경로 수정 필요)
  String _cardName = '';
  String _feedback = '';

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // 💡 0.0 ~ 1.0 사이를 1.5초 동안 왔다갔다 하는 애니메이션
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _startGame() {
    HapticFeedback.lightImpact();
    setState(() {
      _gameState = GameState.playing;
      _startTime = DateTime.now();
    });
  }

  void _resetGame() {
    setState(() {
      _gameState = GameState.ready;
      _elapsedSeconds = 0.0;
      _earnedCoins = 0;
      _cardName = '';
      _cardImage = 'assets/illustrations/taro/card_back_2_high.webp';
    });
  }

  void _stopGame() {
    if (_gameState != GameState.playing || _startTime == null) return;
    HapticFeedback.heavyImpact();
    final endTime = DateTime.now();
    final diffMs = endTime.difference(_startTime!).inMilliseconds;
    _elapsedSeconds = diffMs / 1000.0;

    _calculateResult(_elapsedSeconds);

    setState(() {
      _gameState = GameState.finished;
    });
  }

  /// 🎯 시간 오차에 따른 결과 계산 로직
  void _calculateResult(double seconds) {
    double error = (3.0 - seconds).abs();
    int day = widget.consecutiveDays; // 연속 출석 일수

    // 💡 1. 획득 코인은 무조건 Helper의 계산식(서버와 동일한 식)을 따름
    _earnedCoins = AttendanceHelper.calculateReward(seconds, day);

    if (error <= 0.05) {
      _cardName = 'The Sun (태양)';
      _cardImage = 'assets/illustrations/taro/19-TheSun.webp'; // 🌟 경로 매칭 필요
      _feedback = '완벽한 타이밍! 태양처럼 빛나는 하루가 되길!';
    } else if (error <= 0.2) {
      _cardName = 'The Magician (마법사)';
      _cardImage = 'assets/illustrations/taro/01-TheMagician.webp';
      _feedback = '놀라운 집중력! 당신의 능력을 마음껏 펼치기 좋은 날입니다.';
    } else if (error <= 0.4) {
      _cardName = 'The Chariot (전차)';
      _cardImage = 'assets/illustrations/taro/07-TheChariot.webp';
      _feedback = '거침없는 질주! 목표를 향해 나아가기 좋은 날입니다.';
    } else if (error <= 0.6) {
      _cardName = 'Temperance (절제)';
      _cardImage = 'assets/illustrations/taro/14-Temperance.webp';
      _feedback = '어디로 튈지 모르는 타이밍, 새로운 모험을 즐기세요!';
    } else {
      _cardName = 'The Tower (탑)';
      _cardImage = 'assets/illustrations/taro/16-TheTower.webp';
      _feedback = '타이밍이 엇나갔네요! 하지만 예상치 못한 행운이 올지도 모릅니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bool isFinished = _gameState == GameState.finished;

    final attendanceState = ref.watch(attendanceNotifierProvider);
    final isFinished = _gameState == GameState.finished;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF1E212D), // 다크한 타로 느낌 배경
      child: SingleChildScrollView(
        // ✅ 여기서 감싸주세요
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏱️ 3초 타이밍 타로',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                _gameState == GameState.ready
                    ? '시작 버튼을 누르고,\n마음속으로 정확히 3초를 샌 뒤 카드를 누르세요!'
                    : (_gameState == GameState.playing
                        ? '진행 중... 속으로 3초를 세세요!'
                        : '당신의 운명은?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 30),

              // 🎴 타로 카드 (뒤집기 애니메이션 포함)
              GestureDetector(
                onTap: _stopGame,
                child: TweenAnimationBuilder(
                  // 상태가 finished가 되면 0도에서 180도로 회전
                  tween: Tween<double>(begin: 0, end: isFinished ? 180 : 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  builder: (context, double angle, child) {
                    final isBackVisible = angle >= 90; // 90도 넘어가면 뒷면(결과) 보여줌

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // 3D 원근감
                        ..rotateY(angle * pi / 180),
                      alignment: Alignment.center,
                      child: isBackVisible
                          ? Transform(
                              // 이미지가 좌우 반전되는 것을 막기 위해 다시 180도 뒤집어줌
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(pi),
                              child: _buildCardFront(), // 앞면 (결과 타로 카드)
                            )
                          : _buildCardBack(), // 뒷면 (기본 카드)
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // 🏆 결과 텍스트 영역
              if (isFinished) ...[
                Text(
                  '기록: ${_elapsedSeconds.toStringAsFixed(2)}초', // 예: 2.94초
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber),
                ),
                const SizedBox(height: 10),
                Text(
                  '보상: $_earnedCoins 잉크 획득!',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    _feedback,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 🔘 버튼 영역
              if (_gameState == GameState.ready)
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('도전 시작!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                )
              else if (isFinished)
                Column(
                  children: [
                    // 1. 잉크 받기 버튼 (기존 코드)
                    ElevatedButton(
                      onPressed: attendanceState.isLoading
                          ? null
                          : () async {
                              HapticFeedback.heavyImpact();
                              await ref
                                  .read(attendanceNotifierProvider.notifier)
                                  .claimAttendance(_elapsedSeconds);
                              final result =
                                  ref.read(attendanceNotifierProvider);

                              if (result.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.errorMessage!)),
                                );
                              } else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${result.earnedCoins} 잉크를 획득했어요!')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CA1AF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: attendanceState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('잉크 받기',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 10),

                    // 2. 다시 하기 버튼 (추가)
                    OutlinedButton(
                      onPressed: _resetGame, // 💡 아까 만든 초기화 함수 호출
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('다시 도전하기',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70)),
                    ),
                  ],
                ),

              const SizedBox(height: 15),

              // 💡 안내 문구 추가
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '보상은 연속 출석 일수가 늘어날수록 커집니다.\n(매일 00:00 KST 기준 초기화)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCardBack() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        // 게임 중일 때만 애니메이션 적용
        final isPlaying = _gameState == GameState.playing;
        final glowValue = isPlaying ? _glowAnimation.value : 0.0;

        return Container(
          width: 160,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isPlaying ? Colors.amber.withOpacity(glowValue) : Colors.transparent,
                width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3 * glowValue), // 💡 투명도와 퍼짐 정도를 애니메이션 값에 연동
                blurRadius: 20 * glowValue,
                spreadRadius: 2 * glowValue,
              )
            ],
            image: const DecorationImage(
              image: AssetImage('assets/illustrations/taro/card_back_2_high.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: isPlaying
              ? const Center(
            child: Text('지금 터치!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          )
              : null,
        );
      },
    );
  }

  // 앞면 카드 위젯 (결과 카드)
  Widget _buildCardFront() {
    return Container(
      width: 160,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 2),
        // 결과 이미지
        image: DecorationImage(
          image: AssetImage(_cardImage), // _calculateResult 에서 결정된 이미지
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.black.withOpacity(0.6),
        child: Text(
          _cardName,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
