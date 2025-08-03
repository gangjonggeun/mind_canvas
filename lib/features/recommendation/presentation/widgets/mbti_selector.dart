import 'package:flutter/material.dart';
import '../../data/mock_content_data.dart';

/// 📱 MBTI 선택 모달 위젯
/// 
/// 메모리 효율성:
/// - showModalBottomSheet로 필요시에만 생성
/// - 정적 메서드로 메모리 최적화
class MbtiSelector {
  /// MBTI 선택 모달 표시
  static void show({
    required BuildContext context,
    required String currentMbti,
    required Function(String) onMbtiSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MbtiSelectorContent(
        currentMbti: currentMbti,
        onMbtiSelected: onMbtiSelected,
      ),
    );
  }
}

/// MBTI 선택 모달 내용 위젯
class _MbtiSelectorContent extends StatelessWidget {
  final String currentMbti;
  final Function(String) onMbtiSelected;

  const _MbtiSelectorContent({
    required this.currentMbti,
    required this.onMbtiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final mbtiTypes = MockContentData.getMbtiTypes();

    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '상대방 MBTI 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemCount: mbtiTypes.length,
              itemBuilder: (context, index) {
                final mbti = mbtiTypes[index];
                final isSelected = mbti == currentMbti;
                return GestureDetector(
                  onTap: () {
                    onMbtiSelected(mbti);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3182CE) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3182CE) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        mbti,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF2D3748),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
