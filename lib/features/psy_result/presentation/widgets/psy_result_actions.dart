// lib/features/psytest/presentation/screens/psy_result/widgets/psy_result_actions.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/psy_result.dart';

class PsyResultActions extends StatefulWidget {
  final PsyResult result;
  final VoidCallback onShare;
  final VoidCallback onBookmark;
  final VoidCallback onRetry;

  const PsyResultActions({
    super.key,
    required this.result,
    required this.onShare,
    required this.onBookmark,
    required this.onRetry,
  });

  @override
  State<PsyResultActions> createState() => _PsyResultActionsState();
}

class _PsyResultActionsState extends State<PsyResultActions>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // _isBookmarked = widget.result.isBookmarked;

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    if (_isBookmarked) {
      _heartController.forward().then((_) {
        _heartController.reverse();
      });
      HapticFeedback.lightImpact();
    }

    widget.onBookmark();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ mainColor는 이제 getter (Color 객체)
    final mainColor = widget.result.mainColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 메인 액션 버튼들
          Row(
            children: [
              // 북마크 버튼
              Expanded(
                child: GestureDetector(
                  onTap: _handleBookmark,
                  child: AnimatedBuilder(
                    animation: _heartAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isBookmarked ? _heartAnimation.value : 1.0,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: _isBookmarked
                                ? mainColor
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isBookmarked
                                  ? mainColor
                                  : mainColor.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _isBookmarked
                                    ? mainColor.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                                blurRadius: _isBookmarked ? 12 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isBookmarked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isBookmarked ? Colors.white : mainColor,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isBookmarked ? '저장됨 💕' : '결과 저장',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _isBookmarked ? Colors.white : mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 공유 버튼
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onShare();
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor,
                          mainColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '친구에게 공유',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 다시 테스트하기 버튼
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onRetry();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '다른 테스트도 해보기',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
