import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/psy_result.dart'; // ✅ 실제 엔티티 파일 경로로 수정해주세요

/// 최종 완성본: 단 하나의 '만능 카드' 템플릿 + 기존 부가설명 카드 스타일 복원
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
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 메인 카드: 결과의 핵심 정보를 담습니다.
          _buildUniversalCard(
            context: context,
            type: result.type, // ✅ 타입 전달
            images: result.images,
            iconEmoji: result.iconEmoji,
            title: result.title,
            content: result.description,
            tags: result.tags,
            rawData: result.rawData,
            mainColor: result.mainColor,
          ),

          // 2. 나머지 상세 섹션 카드들
          ...result.sections.map((section) => _buildUniversalCard(
            context: context,
            type: result.type, // ✅ 타입 전달
            images: section.sectionImages,
            iconEmoji: section.iconEmoji,
            title: section.title,
            content: section.content,
            tags: section.highlights,
            rawData: null, // 섹션에는 rawData가 없다고 가정
            mainColor: result.mainColor,
          )),
        ],
      ),
    );
  }

  // ✅ [핵심] 단 하나의 만능 카드 위젯
  Widget _buildUniversalCard({
    required BuildContext context,
    required PsyResultType type,
    required List<PsyResultImage> images,
    required String iconEmoji,
    required String title,
    required String content,
    required List<String> tags,
    required Map<String, dynamic>? rawData,
    required String mainColor,
  }) {
    final Color primaryColor = _parseColor(mainColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 이미지가 있으면 그립니다.
          if (images.isNotEmpty)
            _buildImageSection(images),

          // 2. 텍스트와 하단 콘텐츠 영역
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(iconEmoji, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(content, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF4A5568))),

                // ✅ [수정됨] 3. 하단 콘텐츠: 기존 스타일을 사용하도록 로직 변경
                if (type == PsyResultType.love)
                  _buildSpecialPointBox(primaryColor) // 연애 타입일때
                else if (rawData != null)
                  _buildCompactMetrics(context) // HTP 등 분석 데이터 있을 때
                else if (tags.isNotEmpty)
                    _buildHighlights(tags, primaryColor) // 그 외 태그 있을 때
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==================================================================
  // 🎨 UI를 그리는 '부품' 위젯들 (사용자님 기존 스타일 복원)
  //==================================================================

  /// 공용 카드 데코레이션
  BoxDecoration _cardDecoration(Color primaryColor) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
      boxShadow: [
        BoxShadow(color: primaryColor.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4)),
      ],
    );
  }

  /// 이미지 섹션 (HTP 그리드 또는 단일 이미지 자동 분기)
  Widget _buildImageSection(List<PsyResultImage> images) {
    final bool isHtpGrid = images.where((img) => img.type == PsyImageType.drawing).length >= 3;
    Widget imageContent;
    if (isHtpGrid) {
      imageContent = Row(
        children: images.take(3).map((image) => Expanded(
          child: Image.asset(image.url, fit: BoxFit.cover, height: 160),
        )).toList(),
      );
    } else {
      imageContent = Image.asset(
        images.first.url,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(height: 250, color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
      );
    }
    return ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: imageContent);
  }

  /// ✅ [복원됨] 📊 HTP 메트릭 (사용자님 기존 코드)
  Widget _buildCompactMetrics(BuildContext context) {
    final data = result.rawData;
    if (data == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _parseColor(result.mainColor).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _parseColor(result.mainColor).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCompactMetric('소요시간', '${data['totalDurationSeconds'] ?? 0}초'),
          _buildCompactMetric('수정횟수', '${data['totalModifications'] ?? 0}회'),
          _buildCompactMetric('그림순서', _getDrawingOrder(data['drawingOrder'])),
        ],
      ),
    );
  }

  // _buildCompactMetrics가 사용하는 아이템
  Widget _buildCompactMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _parseColor(result.mainColor))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF718096)), textAlign: TextAlign.center),
      ],
    );
  }

  /// ✅ [새로 추가] 특별한 점 박스 (사진 속 핑크 박스)
  Widget _buildSpecialPointBox(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(result.iconEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('당신의 특별한 점', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
                const SizedBox(height: 2),
                const Text('세상에 하나뿐인 소중한 당신의 모습을 발견했어요', style: TextStyle(fontSize: 12, color: Color(0xFF4A5568))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ [복원됨] 하이라이트 태그 (사용자님 기존 코드)
  Widget _buildHighlights(List<String> tags, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((tag) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Text(tag, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primaryColor)),
        )).toList(),
      ),
    );
  }

  //==================================================================
  // ⚙️ 헬퍼 함수들
  //==================================================================

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return const Color(0xFF6B73E6);
    }
  }

  String _getDrawingOrder(dynamic order) {
    if (order is! List) return '?';
    const names = ['집', '나무', '사람'];
    return order.map((i) => names[i] ?? '?').join('→');
  }
}