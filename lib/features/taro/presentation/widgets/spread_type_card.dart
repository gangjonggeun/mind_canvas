import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/taro_spread_type.dart';

/// 스프레드 타입 선택 카드 위젯
/// 
/// 메모리 최적화:
/// - const 생성자 사용으로 불필요한 재생성 방지
/// - 단순한 레이아웃 구조로 위젯 트리 최적화
/// 
/// CPU 최적화:
/// - FittedBox 제거하여 실시간 계산 부담 감소
/// - 고정된 높이 값으로 레이아웃 계산 최적화
class SpreadTypeCard extends StatelessWidget {
  final TaroSpreadType spreadType;
  final bool isSelected;
  final VoidCallback onTap;

  const SpreadTypeCard({
    super.key,
    required this.spreadType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: TaroColors.gradientGolden,
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TaroColors.withMysticOpacity(TaroColors.textMystic, 0.1),
                    TaroColors.withMysticOpacity(TaroColors.textMystic, 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? TaroColors.accentGold : TaroColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TaroColors.withMysticOpacity(TaroColors.accentGold, 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w), // 패딩 더 늘리기
          child: Column(
            children: [
              // 상단 영역 - 중앙 정렬
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 카드 수 표시
                    Container(
                      width: 45.w, // 크기 더 늘리기
                      height: 45.w,
                      decoration: BoxDecoration(
                        color: isSelected ? TaroColors.textMystic : TaroColors.accentGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: TaroColors.cardShadow,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${spreadType.cardCount}',
                          style: TextStyle(
                            fontSize: 20.sp, // 폰트 크기 더 늘리기
                            fontWeight: FontWeight.bold,
                            color: isSelected ? TaroColors.accentGold : TaroColors.textMystic,
                          ),
                        ),
                      ),
                    ),
                    
                    Gap(16.h), // 간격 더 늘리기
                    
                    // 스프레드 이름
                    Text(
                      spreadType.name,
                      style: TextStyle(
                        fontSize: 15.sp, // 폰트 크기 더 늘리기
                        fontWeight: FontWeight.w600,
                        color: isSelected ? TaroColors.textMystic : TaroColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // 중앙 영역 - 설명 부분
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    spreadType.description,
                    style: TextStyle(
                      fontSize: 12.sp, // 폰트 크기 더 늘리기
                      color: isSelected ? TaroColors.textSecondary : TaroColors.textMuted,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3, // 3줄로 늘리기
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              
              // 체크 표시 완전 제거 - 색으로 이미 선택 상태가 명확
              // 사용자가 색으로 선택 상태를 충분히 인지할 수 있음
            ],
          ),
        ),
      ),
    );
  }
}
