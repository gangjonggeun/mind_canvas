import 'package:flutter/material.dart';
import '../../domain/entities/psy_result.dart';
import '../../../../core/utils/color_utils.dart';

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
    // 🎨 파스텔 대응 스마트 색상 계산
    final mainTag = result.tags.isNotEmpty ? result.tags.first : null;
    final textColor = ColorUtils.getSmartTextColor(result.bgGradientStart, tag: mainTag);
    final overlayColor = ColorUtils.getSmartOverlayColor(result.bgGradientStart);
    final textShadows = ColorUtils.getReadableShadows(result.bgGradientStart);
    
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
                shadows: textShadows, // 🎨 파스텔 대응 그림자
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 서브타이틀 (파스텔 배경 가독성 개선)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorUtils.getReadableBackgroundPanel(result.bgGradientStart),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: overlayColor.withOpacity(0.15),
                ),
              ),
              child: Text(
                result.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  height: 1.4,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                  shadows: textShadows,
                ),
                textAlign: TextAlign.center,
              ),
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
                      color: ColorUtils.getSmartTextColor(result.bgGradientStart, tag: tag),
                      fontWeight: FontWeight.w600,
                      shadows: ColorUtils.getReadableShadows(result.bgGradientStart),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // 🎨 색상 로직은 ColorUtils로 이관됨 (중복 제거)
}
