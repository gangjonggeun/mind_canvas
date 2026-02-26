import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/repositories/test_repository_provider.dart';
import '../../../psy_result/data/mapper/test_result_mapper.dart';
import '../../../psy_result/presentation/psy_result_screen.dart';
import '../../../psy_result/presentation/screen/psy_result_screen2.dart';
import '../../data/models/response/profile_dto.dart'; // DTO 경로 확인

class TestResultItem extends ConsumerWidget { // ConsumerWidget으로 변경
  final MyTestResultSummaryResponse result;

  const TestResultItem({super.key, required this.result});

  // 🎨 태그 기반 해시코드 컬러 로직
  Color _getCategoryColor(String tag) {
    const List<Color> palette = [
      Color(0xFFED8936), Color(0xFF4299E1), Color(0xFF9F7AEA),
      Color(0xFF48BB78), Color(0xFFF56565), Color(0xFF38B2AC),
      Color(0xFF667EEA), Color(0xFFED64A6),
    ];
    final int index = tag.hashCode.abs() % palette.length;
    return palette[index];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getCategoryColor(result.testTag);

    return GestureDetector(
      onTap: () async {
        // 1. 로딩 표시 (선택사항이지만 UX상 권장)
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('결과를 분석 중입니다...')));

        // 2. 기존에 사용하던 레포지토리 메서드 호출
        final detailResult = await ref.read(testRepositoryProvider).getTestResultDetail(result.id);

        detailResult.fold(
          onSuccess: (data) {
            // 3. 기존 매퍼를 사용하여 엔티티 변환
            final psyResult = TestResultMapper.toEntity(data);

            // 4. 결과 화면으로 이동
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PsyResultScreen2(result: psyResult))
              );
            }
          },
          onFailure: (code, msg) {
            print("❌ 테스트 결과 조회 실패: $msg");
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('결과를 불러오지 못했습니다: $msg'))
              );
            }
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            // 왼쪽 컬러 바
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            // 중앙 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.testTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.createdAt ?? '-',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
            // 오른쪽 상태 배지
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '분석 완료',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4A5568)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}