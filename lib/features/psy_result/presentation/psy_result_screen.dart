import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/psy_result.dart';
import 'widgets/psy_result_header.dart';
import 'widgets/psy_result_content.dart';
import 'widgets/psy_result_actions.dart';

/// 심리테스트 결과 화면
/// 통합형 적응형 레이아웃으로 모든 결과 타입 처리
class PsyResultScreen extends ConsumerStatefulWidget {
  final PsyResult result;

  const PsyResultScreen({
    super.key,
    required this.result,
  });

  @override
  ConsumerState<PsyResultScreen> createState() => _PsyResultScreenState();
}

class _PsyResultScreenState extends ConsumerState<PsyResultScreen>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final PageController _pageController;

  @override
  bool get wantKeepAlive => true; // 메모리 효율성을 위한 위젯 생존 관리

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(int.parse(widget.result.bgGradientStart, radix: 16)),
              Color(int.parse(widget.result.bgGradientEnd, radix: 16)),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(), // iOS 스타일 부드러운 스크롤
            slivers: [
              // 감성적인 헤더
              SliverToBoxAdapter(
                child: PsyResultHeader(
                  result: widget.result,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
              
              // 적응형 컨텐츠
              SliverToBoxAdapter(
                child: RepaintBoundary( // 렌더링 성능 최적화
                  child: PsyResultContent(
                    result: widget.result,
                    scrollController: _scrollController,
                  ),
                ),
              ),
              
              // 하단 액션 버튼들
              SliverToBoxAdapter(
                child: PsyResultActions(
                  result: widget.result,
                  onShare: _handleShare,
                  onBookmark: _handleBookmark,
                  onRetry: _handleRetry,
                ),
              ),
              
              // 하단 여백
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 공유 처리
  void _handleShare() {
    // TODO: 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('결과가 공유되었습니다 💕'),
        backgroundColor: Color(int.parse(widget.result.mainColor, radix: 16)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// 북마크 처리
  void _handleBookmark() {
    // TODO: 북마크 상태 관리 구현
    setState(() {
      // 임시 UI 업데이트
    });
  }

  /// 다시 테스트하기
  void _handleRetry() {
    Navigator.of(context).pop();
    // TODO: 테스트 화면으로 이동
  }
}
