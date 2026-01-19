import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  // ✅ [수정] 이름을 onLikeChanged -> onTap으로 변경 (직관성 및 코드 통일)
  final Function(bool) onTap;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onTap,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isLiked = false;
  int _currentCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _currentCount = widget.likeCount;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // 튀어 오르는 효과 (Spring Curve)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      _isLiked = widget.isLiked;
    }
    if (oldWidget.likeCount != widget.likeCount) {
      _currentCount = widget.likeCount;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isLiked = !_isLiked;
      _currentCount += _isLiked ? 1 : -1;
    });

    // 애니메이션 실행
    if (_isLiked) {
      _controller.forward();
    }

    // ✅ [수정] 변경된 이름(onTap)으로 콜백 호출
    widget.onTap(_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.translucent, // 터치 영역 확보
      child: Row(
        mainAxisSize: MainAxisSize.min, // 최소 크기만 차지
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? const Color(0xFFFF5252) : Colors.grey[600],
              size: 26,
            ),
          ),
          if (_currentCount > 0) ...[
            const SizedBox(width: 6),
            Text(
              '$_currentCount',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: _isLiked ? const Color(0xFFFF5252) : Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}