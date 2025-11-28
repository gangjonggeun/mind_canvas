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
    // 1. 색상 계산을 상단에서 한 번만 수행하여 변수에 저장
    final mainTag = result.tags.isNotEmpty ? result.tags.first : null;
    final textColor = ColorUtils.getSmartTextColor(
      result.bgGradientStart,
      tag: mainTag,
    );
    final overlayColor = ColorUtils.getSmartOverlayColor(
      result.bgGradientStart,
    );

    // 투명도가 적용된 색상들을 미리 계산 (const 처럼 사용하기 위함)
    final containerBgColor = overlayColor.withOpacity(0.15);
    final containerBorderColor = overlayColor.withOpacity(0.25);
    final tagBgColor = overlayColor.withOpacity(0.12);
    final iconColor = textColor.withOpacity(0.8);

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: containerBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: iconColor,
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
                    color:  containerBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: containerBorderColor),
                  ),
                  child: Icon(
                    Icons.close,
                    color: iconColor,
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
                color:  containerBgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: overlayColor.withOpacity(0.2),
                  width: 2,
                ),
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
                color:  containerBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: overlayColor.withOpacity(0.3)),
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
                // shadows: textShadows, // 🎨 파스텔 대응 그림자
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
                color: const Color(0xD9FFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                result.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  height: 1.4,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                  // ✅ shadows 제거
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 태그들 (감성적 컬러)
          if (result.tags.isNotEmpty)
            Center(
              // Wrap을 Center로 감싸 정렬 보장
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: result.tags.map((tag) {
                  // 2. 태그별 색상 계산 (필요하다면 유지하되, 그림자는 제거 고려)
                  // 반복문 안에서 복잡한 ColorUtils 호출은 최소화하는 것이 좋습니다.
                  final tagTextColor = ColorUtils.getSmartTextColor(
                    result.bgGradientStart,
                    tag: tag,
                  );

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tagBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: containerBorderColor),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 12,
                        color: tagTextColor,
                        fontWeight: FontWeight.w600,
                        // shadows: ... // ✅ 텍스트 그림자는 렌더링 비용이 매우 높으므로 제거 추천
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // 🎨 색상 로직은 ColorUtils로 이관됨 (중복 제거)
}
