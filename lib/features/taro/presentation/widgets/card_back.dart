
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    // Container로 먼저 틀을 잡고, 둥근 모서리를 적용합니다.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // ClipRRect로 내용물이 테두리를 벗어나지 않도록 강제합니다.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.asset(
          'assets/illustrations/taro/card_back_1_high.webp',
          fit: BoxFit.cover, // 공간을 꽉 채우도록 설정
        ),
      ),
    );
  }
}