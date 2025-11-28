// lib/features/psytest/presentation/screens/psy_result/widgets/psy_result_content.dart

import 'dart:io';

import 'package:flutter/material.dart';
import '../../domain/entities/psy_result.dart';

/// 심리테스트 결과 콘텐츠 (단순화 버전)
class PsyResultContent extends StatelessWidget {
  final PsyResult result;
  final ScrollController scrollController;
  final Map<String, String>? localImagePaths;

  const PsyResultContent({
    super.key,
    required this.result,
    required this.scrollController,
    this.localImagePaths,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 디버깅 로그 (제일 먼저!)
    print('🎨 PsyResultContent build');
    print('   - localImagePaths: ${localImagePaths?.keys.toList()}');
    print('   - localImagePaths == null? ${localImagePaths == null}');
    print('   - result.sections: ${result.sections.length}개');

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 메인 카드
          _buildMainCard2(),



          // 3. ✅ 각 섹션 (이미지 포함)
          ...result.sections.asMap().entries.map((entry) {
            final index = entry.key+1;
            final section = entry.value;
            return _buildSectionCard(section, index);
          }).toList(),
        ],
      ),
    );
  }

  /// 메인 카드 (resultTag + briefDescription)
  Widget _buildMainCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 제목 (resultTag)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: result.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    result.iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.title, // resultTag
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ briefDescription 표시 (HtpResponse에서 온 경우)
            if (result.sections.isNotEmpty &&
                result.sections.first.title.contains('총평')) ...[
              const SizedBox(height: 16),
              Text(
                result.sections.first.content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF4A5568),
                ),
              ),
            ],

            // 태그들
            if (result.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTags(result.tags),
            ],
          ],
        ),
      ),
    );
  }

  /// 메인 카드 (resultTag + briefDescription)
  Widget _buildMainCard2() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 제목 (resultTag)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: result.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    result.iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.title, // resultTag
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ briefDescription 표시 (subtitle 사용)
            if (result.subtitle.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                result.subtitle, // ✅ briefDescription
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF4A5568),
                ),
              ),
            ],

            // 태그들
            if (result.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTags(result.tags),
            ],
          ],
        ),
      ),
    );
  }

  /// 차원별 점수 카드
  Widget _buildDimensionScoresCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: result.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('📊', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Text(
                '차원별 점수',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...result.dimensionScores!.entries.map((entry) {
            return _buildScoreBar(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }
  /// 섹션 카드
  Widget _buildSectionCard(PsyResultSection section, int index) {
    print('📍 섹션 $index: ${section.title}');
    print('   - localImagePaths: ${localImagePaths?.keys.toList()}');

    // ✅ 인덱스 대신 제목으로 매칭 (더 안전!)
    String? localImageType;
    if (localImagePaths != null) {
      print('   - 이미지 체크 시작...');
      print('   - title="${section.title}"');

      // ✅ 제목에 키워드가 있으면 매칭
      if (section.title.contains('집') || section.title.toUpperCase().contains('HOUSE')) {
        localImageType = 'house';
        print('   ✅ house 매칭! (제목 기준)');
      } else if (section.title.contains('나무') || section.title.toUpperCase().contains('TREE')) {
        localImageType = 'tree';
        print('   ✅ tree 매칭! (제목 기준)');
      } else if (section.title.contains('사람') || section.title.toUpperCase().contains('PERSON')) {
        localImageType = 'person';
        print('   ✅ person 매칭! (제목 기준)');
      }

      if (localImageType != null) {
        print('   - localImageType: $localImageType');
        print('   - 해당 키 존재? ${localImagePaths!.containsKey(localImageType)}');
        if (localImagePaths!.containsKey(localImageType)) {
          print('   - 이미지 경로: ${localImagePaths![localImageType]}');
        }
      }
    } else {
      print('   ⚠️ localImagePaths가 null');
    }

    // 서버 이미지 체크
    bool hasServerImage = section.hasImage;
    print('   - hasServerImage: $hasServerImage');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: result.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    section.iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ 이미지 표시
            if (hasServerImage) ...[
              const SizedBox(height: 16),
              _buildServerImage(section.imageUrl!),
              const SizedBox(height: 16),
            ] else if (localImageType != null &&
                localImagePaths!.containsKey(localImageType)) ...[
              const SizedBox(height: 16),
              _buildLocalImage(localImageType),
              const SizedBox(height: 16),
            ] else ...[
              const SizedBox(height: 12),
            ],

            // 섹션 내용
            Text(
              section.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// 🌐 서버 이미지 (기존 로직)
  Widget _buildServerImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 150,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }

  /// 📱 로컬 이미지 (HTP 전용)
  Widget _buildLocalImage(String type) {

    print('🖼️ _buildLocalImage 호출: type=$type');

    final imagePath = localImagePaths![type]!;
    print('   - imagePath: $imagePath');

    final imageFile = File(imagePath);
    print('   - 파일 생성 완료');

    final exists = imageFile.existsSync();
    print('   - 파일 존재? $exists');

    if (!exists) {
      print('   ❌ 파일이 존재하지 않아 SizedBox.shrink() 반환');
      return const SizedBox.shrink();
    }
    print('   ✅ 이미지 위젯 생성 시작');


    if (!imageFile.existsSync()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 그림 라벨
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: result.mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: result.mainColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconByType(type),
                color: result.mainColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '${_getTitleByType(type)} 그림',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: result.mainColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: result.mainColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  /// 🎨 섹션 내 이미지
  Widget _buildSectionImage(String type) {
    final imagePath = localImagePaths![type]!;
    final imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 그림 라벨
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: result.mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: result.mainColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconByType(type),
                color: result.mainColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '${_getTitleByType(type)} 그림',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: result.mainColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: result.mainColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }


  /// 타입별 아이콘
  IconData _getIconByType(String type) {
    switch (type) {
      case 'house':
        return Icons.home_rounded;
      case 'tree':
        return Icons.park_rounded;
      case 'person':
        return Icons.person_rounded;
      default:
        return Icons.image_rounded;
    }
  }

  /// 타입별 제목
  String _getTitleByType(String type) {
    switch (type) {
      case 'house':
        return '집';
      case 'tree':
        return '나무';
      case 'person':
        return '사람';
      default:
        return '그림';
    }
  }


  /// 주관식 답변 카드
  Widget _buildSubjectiveAnswerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: result.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('✍️', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Text(
                '내 답변',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.subjectiveAnswer!,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  /// 점수 바
  Widget _buildScoreBar(String label, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                '$score점',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(result.mainColor),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  /// 태그들
  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: result.mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: result.mainColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: result.mainColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 카드 데코레이션
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: result.mainColor.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: result.mainColor.withOpacity(0.07),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}