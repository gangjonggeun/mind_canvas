import 'package:flutter/material.dart';
import '../../domain/entities/analysis_data.dart';

/// 에니어그램 9타입 위젯
class EnneagramWidget extends StatelessWidget {
  final List<EnneagramType> enneagramTypes;
  final int? primaryType;

  const EnneagramWidget({
    super.key,
    required this.enneagramTypes,
    this.primaryType,
  });

  @override
  Widget build(BuildContext context) {
    // 점수 순으로 정렬
    final sortedTypes = List<EnneagramType>.from(enneagramTypes)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Column(
      children: [
        // 주 타입 강조
        if (primaryType != null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(int.parse(sortedTypes.first.color, radix: 16)),
                  Color(int.parse(sortedTypes.first.color, radix: 16)).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      sortedTypes.first.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '유형 ${sortedTypes.first.number}: ${sortedTypes.first.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sortedTypes.first.score.toInt()}% 일치',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // 모든 타입 리스트
        ...sortedTypes.take(5).map((type) {
          final isPrimary = type.number == primaryType;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPrimary 
                  ? Color(int.parse(type.color, radix: 16)).withOpacity(0.1)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPrimary
                    ? Color(int.parse(type.color, radix: 16)).withOpacity(0.3)
                    : const Color(0xFFE2E8F0),
                width: isPrimary ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(int.parse(type.color, radix: 16)).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      type.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${type.number}번',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(int.parse(type.color, radix: 16)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: type.score / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(type.color, radix: 16)),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${type.score.toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(int.parse(type.color, radix: 16)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
