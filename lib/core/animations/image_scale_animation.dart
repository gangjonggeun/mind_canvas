import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 이미지 스케일 애니메이션 위젯
/// 
/// **메모리 최적화**:
/// - 애니메이션 컨트롤러 자동 해제
/// - mounted 상태 체크
/// - 가벼운 애니메이션 객체 사용
class ImageScaleAnimation extends StatefulWidget {
  final String imagePath;
  final Widget? child;
  final Duration? duration;
  final Duration? delay;
  final Color? backgroundColor;
  final bool isLottie;
  final String? lottiePath;

  const ImageScaleAnimation({
    super.key,
    required this.imagePath,
    this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = const Duration(milliseconds: 300),
    this.backgroundColor = Colors.white,
    this.isLottie = false,
    this.lottiePath,
  });

  @override
  State<ImageScaleAnimation> createState() => _ImageScaleAnimationState();
}

class _ImageScaleAnimationState extends State<ImageScaleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimation();
  }

  /// 애니메이션 초기화 (메모리 효율적)
  void _initAnimations() {
    // 스케일 애니메이션
    _scaleController = AnimationController(
      duration: widget.duration!,
      vsync: this,
    );

    // 페이드 애니메이션
    _fadeController = AnimationController(
      duration: Duration(milliseconds: (widget.duration!.inMilliseconds * 0.8).round()),
      vsync: this,
    );

    // 부드러운 탄성 효과
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // 자연스러운 페이드인
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  /// 애니메이션 시작
  void _startAnimation() {
    Future.delayed(widget.delay!, () {
      if (mounted && !_isDisposed) {
        _fadeController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && !_isDisposed) {
            _scaleController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _fadeController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildImageContent(),
          ),
        );
      },
    );
  }

  /// 이미지 콘텐츠 빌드 (Lottie vs Asset 분기)
  Widget _buildImageContent() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 배경 이미지 또는 Lottie
            Positioned.fill(
              child: widget.isLottie && widget.lottiePath != null
                  ? Lottie.asset(
                      widget.lottiePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackImage();
                      },
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackImage();
                      },
                    ),
            ),
            // 자식 위젯
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }

  /// 폴백 이미지 (에러 시)
  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.backgroundColor ?? Colors.white,
            (widget.backgroundColor ?? Colors.white).withOpacity(0.8),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// Lottie 애니메이션 전용 위젯
class LottieScaleAnimation extends StatefulWidget {
  final String lottiePath;
  final Widget? overlayChild;
  final Duration? duration;
  final Duration? delay;
  final Color? backgroundColor;

  const LottieScaleAnimation({
    super.key,
    required this.lottiePath,
    this.overlayChild,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = const Duration(milliseconds: 300),
    this.backgroundColor = Colors.white,
  });

  @override
  State<LottieScaleAnimation> createState() => _LottieScaleAnimationState();
}

class _LottieScaleAnimationState extends State<LottieScaleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration!,
      vsync: this,
    );
    
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(widget.delay!, () {
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
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Lottie 애니메이션
            Positioned.fill(
              child: Lottie.asset(
                widget.lottiePath,
                controller: _controller,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: widget.backgroundColor,
                    child: const Center(
                      child: Icon(
                        Icons.animation,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            // 오버레이 콘텐츠
            if (widget.overlayChild != null) widget.overlayChild!,
          ],
        ),
      ),
    );
  }
}
