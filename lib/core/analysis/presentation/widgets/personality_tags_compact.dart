import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 간결한 성격 태그 위젯
/// 상단에 배치되는 핵심 특성 태그들
class PersonalityTagsCompact extends StatelessWidget {
  final List<PersonalityTag> tags;

  const PersonalityTagsCompact({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    // 상위 6개 태그만 표시
    final topTags = tags.take(6).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              color: Color(0xFF64748B),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              '당신의 성격 키워드',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topTags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '#${tag.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(int.parse(tag.color, radix: 16)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(int.parse(tag.color, radix: 16)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${tag.confidence.toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
