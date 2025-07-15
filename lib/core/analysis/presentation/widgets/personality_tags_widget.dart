import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 성격 태그 위젯
class PersonalityTagsWidget extends StatelessWidget {
  final List<PersonalityTag> tags;

  const PersonalityTagsWidget({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
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
              const SizedBox(width: 4),
              Text(
                '${tag.confidence.toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(int.parse(tag.color, radix: 16)).withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
