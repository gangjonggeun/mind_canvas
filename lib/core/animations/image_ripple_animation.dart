import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 타로 카드용 이미지 흔들림 애니메이션 위젯
/// 
/// 배경 이미지가 약간 흔들리는 잔물결 효과
/// - 이미지 자체가 미세하게 움직임
/// - 페이지뷰 진입 시 자동 시작
/// - 매우 부드럽고 자연스러운 효과
/// - 에러 발생 시 애니메이션 중단 및 로그 최소화
class ImageRippleAnimation extends StatefulWidget {
  const ImageRippleAnimation({
    super.key,
    required this.imagePath,
    required this.child,
    this.backgroundColor = Colors.white,
    this.rippleStrength = 2.0, // 흔들림 강도 (매우 약하게)
    this.rippleSpeed = 0.5, // 흔들림 속도 (느리게)
    this.autoStart = true, // 자동 시작 여부
  });

  /// 배경 이미지 경로
  final String imagePath;
  
  /// 오버레이할 자식 위젯
  final Widget child;
  
  /// 배경색
  final Color backgroundColor;
  
  /// 흔들림 강도 (픽셀 단위)
  final double rippleStrength;
  
  /// 흔들림 속도 (낮을수록 느림)
  final double rippleSpeed;
  
  /// 자동 시작 여부
  final bool autoStart;

  @override
  State<ImageRippleAnimation> createState() => _ImageRippleAnimationState();
}

class _ImageRippleAnimationState extends State<ImageRippleAnimation>
    with TickerProviderStateMixin {
  
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  
  // ===== 🛡️ 에러 상태 관리 =====
  bool _hasImageError = false;
  bool _isImageLoaded = false;
  Widget? _cachedImageWidget;
  Widget? _cachedErrorWidget;

  @override
  void initState() {
    super.initState();
    _initializeRippleAnimation();
    _preloadImage();
  }

  /// 이미지 미리 로드 및 에러 체크
  /// 
  /// 한 번만 이미지 로딩을 시도하고 결과를 캐싱
  void _preloadImage() {
    final imageProvider = AssetImage(widget.imagePath);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        // ✅ 이미지 로딩 성공
        if (mounted) {
          setState(() {
            _isImageLoaded = true;
            _hasImageError = false;
          });
          _startRippleAnimationSafely();
        }
        imageStream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        // ❌ 이미지 로딩 실패 (한 번만 로그 출력)
        if (mounted && !_hasImageError) {
          print('🖼️ [ImageRippleAnimation] 이미지 로딩 실패: ${widget.imagePath}');
          print('🚫 [ImageRippleAnimation] 에러: $exception');
          
          setState(() {
            _hasImageError = true;
            _isImageLoaded = false;
          });
          
          // 에러 발생 시 애니메이션 중단
          _rippleController.stop();
        }
        imageStream.removeListener(listener);
      },
    );
    
    imageStream.addListener(listener);
  }

  /// 잔물결 애니메이션 초기화
  void _initializeRippleAnimation() {
    _rippleController = AnimationController(
      duration: Duration(milliseconds: (4000 / widget.rippleSpeed).round()), // 느린 주기
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi, // 한 바퀴 사인 웨이브
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeInOut, // 부드러운 곡선
    ));
  }

  /// 안전한 애니메이션 시작 (이미지 로딩 성공 시에만)
  void _startRippleAnimationSafely() {
    if (widget.autoStart && !_hasImageError && _isImageLoaded) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_hasImageError) {
          _rippleController.repeat();
        }
      });
    }
  }

  /// 이미지 위젯 캐싱 (한 번만 생성)
  Widget _buildCachedImage() {
    if (_cachedImageWidget != null) {
      return _cachedImageWidget!;
    }

    _cachedImageWidget = Image.asset(
      widget.imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // ⚠️ errorBuilder 제거 (이미 preload에서 처리)
    );
    
    return _cachedImageWidget!;
  }

  /// 에러 위젯 캐싱 (한 번만 생성)
  Widget _buildCachedErrorWidget() {
    if (_cachedErrorWidget != null) {
      return _cachedErrorWidget!;
    }

    _cachedErrorWidget = Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            '이미지 로딩 실패',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    
    return _cachedErrorWidget!;
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ===== 🖼️ 배경 이미지 (조건부 렌더링) =====
            Positioned.fill(
              child: _hasImageError
                  ? _buildCachedErrorWidget() // 에러 시 정적 위젯
                  : _isImageLoaded
                      ? AnimatedBuilder( // 로딩 완료 시 애니메이션
                          animation: _rippleAnimation,
                          builder: (context, child) {
                            // X, Y 방향으로 미세한 움직임 (서로 다른 주기)
                            final xOffset = math.sin(_rippleAnimation.value) * widget.rippleStrength;
                            final yOffset = math.cos(_rippleAnimation.value * 0.7) * widget.rippleStrength * 0.5;
                            
                            return Transform.translate(
                              offset: Offset(xOffset, yOffset),
                              child: _buildCachedImage(), // 캐싱된 이미지 사용
                            );
                          },
                        )
                      : Container( // 로딩 중
                          color: widget.backgroundColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ),
            ),
            
            // ===== 📝 고정된 컨텐츠 (움직이지 않음) =====
            widget.child,
          ],
        ),
      ),
    );
  }
}
