import 'package:flutter/material.dart';
import '../../domain/entities/psy_result.dart';

/// 감성적인 심리테스트 결과 헤더
/// 배경 밝기에 따른 적응형 텍스트 색상 처리
class PsyResultHeader extends StatelessWidget {
  final PsyResult result;
  final VoidCallback onClose;

  const PsyResultHeader({
    super.key,
    required this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = _getAdaptiveTextColor();
    final overlayColor = _getAdaptiveOverlayColor();
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: overlayColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: overlayColor.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: textColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${result.estimatedReadingTime}분 읽기',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: overlayColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: overlayColor.withOpacity(0.25),
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    color: textColor.withOpacity(0.8),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 메인 이모지 (큰 크기로 임팩트)
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: overlayColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: overlayColor.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  result.iconEmoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 결과 타입 배지
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: overlayColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: overlayColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                result.type.displayName,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 메인 타이틀 (감성적 폰트)
          Center(
            child: Text(
              result.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.2,
                letterSpacing: -0.5,
                shadows: _isLightBackground() ? [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ] : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 서브타이틀 (부드러운 느낌)
          Center(
            child: Text(
              result.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.85),
                height: 1.4,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 태그들 (감성적 컬러)
          if (result.tags.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: result.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: overlayColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: overlayColor.withOpacity(0.25),
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// 🎨 배경 밝기에 따른 적응형 텍스트 색상
  Color _getAdaptiveTextColor() {
    if (_isLightBackground()) {
      // 밝은 배경 → 어두운 텍스트
      return const Color(0xFF2D3748);
    } else {
      // 어두운 배경 → 밝은 텍스트  
      return Colors.white;
    }
  }

  /// 🎨 배경 밝기에 따른 적응형 오버레이 색상
  Color _getAdaptiveOverlayColor() {
    if (_isLightBackground()) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  /// 🔍 배경이 밝은지 어두운지 판단
  bool _isLightBackground() {
    try {
      // gradient 시작색을 기준으로 판단
      final startColor = Color(int.parse(result.bgGradientStart, radix: 16));
      final luminance = startColor.computeLuminance();
      
      // luminance가 0.5 이상이면 밝은 색으로 판단
      return luminance > 0.5;
    } catch (e) {
      // 파싱 실패 시 기본값: 밝은 배경으로 가정
      return true;
    }
  }
}
