import 'package:flutter/material.dart';

/// 간단한 이미지 스케일 애니메이션 위젯
/// 
/// **메모리 최적화**:
/// - 단일 애니메이션 컨트롤러 사용
/// - 자동 dispose 처리
/// - mounted 체크로 안전성 확보
class SimpleScaleAnimation extends StatefulWidget {
  final String imagePath;
  final Widget? child;
  final Duration duration;
  final Duration delay;
  final Color backgroundColor;
  final double scaleFrom;
  final double scaleTo;

  const SimpleScaleAnimation({
    super.key,
    required this.imagePath,
    this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 300),
    this.backgroundColor = Colors.white,
    this.scaleFrom = 0.8,
    this.scaleTo = 1.0,
  });

  @override
  State<SimpleScaleAnimation> createState() => _SimpleScaleAnimationState();
}

class _SimpleScaleAnimationState extends State<SimpleScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _startAnimation();
  }

  /// 애니메이션 초기화 (가벼운 단일 컨트롤러)
  void _initAnimation() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 스케일 애니메이션 (부드러운 탄성)
    _scaleAnimation = Tween<double>(
      begin: widget.scaleFrom,
      end: widget.scaleTo,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // 페이드 애니메이션 (자연스러운 등장)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  /// 딜레이 후 애니메이션 시작
  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted && !_isDisposed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // 배경 이미지
                    Positioned.fill(
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image Error: $error');  // 디버그 로그
                          print('Image Path: ${widget.imagePath}');  // 경로 확인
                          return Container(
                            color: widget.backgroundColor,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 48,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image Load Failed',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 자식 위젯 (텍스트 오버레이 등)
                    if (widget.child != null) widget.child!,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
