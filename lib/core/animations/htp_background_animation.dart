import 'package:flutter/material.dart';

/// HTP PageView용 배경 이미지 전용 슬라이드업 애니메이션 위젯
/// 
/// 배경 이미지만 아래에서 위로 올라오면서 커지는 애니메이션
/// 텍스트와 아이콘은 고정된 상태 유지
/// - 컨테이너 밖으로 삐져나오는 오버플로우 효과
/// - 메모리 효율적인 AnimationController 관리
/// - 배경과 콘텐츠 분리된 레이어링
class HTPBackgroundAnimation extends StatefulWidget {
  const HTPBackgroundAnimation({
    super.key,
    required this.imagePath,
    required this.child,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = const Duration(milliseconds: 300),
    this.slideDistance = 80.0,
    this.scaleFrom = 0.8,
    this.scaleTo = 1.1, // 컨테이너보다 약간 크게
    this.enableOverflow = true,
  });

  /// 배경 이미지 경로
  final String imagePath;
  
  /// 오버레이할 자식 위젯 (텍스트, 아이콘 등)
  final Widget child;
  
  /// 배경색 (이미지 로딩 중 표시)
  final Color backgroundColor;
  
  /// 애니메이션 지속 시간
  final Duration duration;
  
  /// 애니메이션 시작 지연 시간
  final Duration delay;
  
  /// 슬라이드 거리 (픽셀)
  final double slideDistance;
  
  /// 시작 스케일
  final double scaleFrom;
  
  /// 끝 스케일 (1.1로 설정하면 컨테이너 밖으로 삐져나옴)
  final double scaleTo;
  
  /// 오버플로우 효과 사용 여부
  final bool enableOverflow;

  @override
  State<HTPBackgroundAnimation> createState() => _HTPBackgroundAnimationState();
}

class _HTPBackgroundAnimationState extends State<HTPBackgroundAnimation>
    with TickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  /// 애니메이션 초기화
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 슬라이드 애니메이션 (아래에서 위로)
    _slideAnimation = Tween<double>(
      begin: widget.slideDistance,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // 스케일 애니메이션 (작게 시작해서 자연스럽게 커짐)
    _scaleAnimation = Tween<double>(
      begin: widget.scaleFrom,
      end: widget.scaleTo,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuart), // 더 부드러운 커브
    ));

    // 페이드 애니메이션 (투명에서 불투명)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
  }

  /// 지연 후 애니메이션 시작
  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enableOverflow 
        ? _buildTopOverflowContainer()
        : _buildNormalContainer();
  }

  /// 위쪽으로만 오버플로우되는 컨테이너
  Widget _buildTopOverflowContainer() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none, // 중요: 위쪽으로 나가는 것 허용
          children: [
            // 애니메이션되는 배경 이미지
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: Alignment.bottomCenter, // 아래쪽 중앙을 기준으로 스케일 (위쪽으로만 늘어나감)
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: widget.backgroundColor,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            // 고정된 텍스트 콘텐츠 (애니메이션 없음)
            widget.child,
          ],
        ),
      ),
    );
  }

  /// 일반 컨테이너 (오버플로우 없음)
  Widget _buildNormalContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // 애니메이션되는 배경 이미지
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: widget.backgroundColor,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 고정된 텍스트 콘텐츠 (애니메이션 없음)
            widget.child,
          ],
        ),
      ),
    );
  }
}
