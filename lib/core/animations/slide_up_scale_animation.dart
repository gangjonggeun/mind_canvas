import 'package:flutter/material.dart';

/// HTP PageView용 슬라이드업 + 스케일 애니메이션 위젯
/// 
/// 아래에서 위로 올라오면서 크기가 커지는 부드러운 애니메이션
/// - 메모리 효율적인 AnimationController 관리
/// - 생명주기 기반 안전한 리소스 해제
/// - 자연스러운 easing curve 적용
class SlideUpScaleAnimation extends StatefulWidget {
  const SlideUpScaleAnimation({
    super.key,
    required this.imagePath,
    required this.child,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = const Duration(milliseconds: 300),
    this.slideDistance = 50.0,
    this.scaleFrom = 0.8,
    this.scaleTo = 1.0,
  });

  /// 배경 이미지 경로
  final String imagePath;
  
  /// 오버레이할 자식 위젯
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
  
  /// 끝 스케일
  final double scaleTo;

  @override
  State<SlideUpScaleAnimation> createState() => _SlideUpScaleAnimationState();
}

class _SlideUpScaleAnimationState extends State<SlideUpScaleAnimation>
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
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // 스케일 애니메이션 (작게 시작해서 커짐)
    _scaleAnimation = Tween<double>(
      begin: widget.scaleFrom,
      end: widget.scaleTo,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // 페이드 애니메이션 (투명에서 불투명)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // 배경 이미지
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로딩 실패 시 기본 배경색 표시
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
            // 애니메이션이 적용된 자식 위젯
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: widget.child,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
