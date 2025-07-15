import 'package:flutter/material.dart';
import '../../domain/entities/psy_result.dart';
import 'short_result_layout.dart';
import 'long_result_layout.dart';

/// 심리테스트 결과 컨텐츠 - 적응형 레이아웃
/// 결과 길이에 따라 자동으로 레이아웃 전환
class PsyResultContent extends StatelessWidget {
  final PsyResult result;
  final ScrollController scrollController;

  const PsyResultContent({
    super.key,
    required this.result,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // 결과 길이에 따른 적응형 레이아웃
    if (result.isLongResult) {
      return LongResultLayout(
        result: result,
        scrollController: scrollController,
      );
    } else {
      return ShortResultLayout(
        result: result,
      );
    }
  }
}
