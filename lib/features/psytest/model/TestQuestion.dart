

enum QuestionType { text, image, subjective }

/// ✅ [수정됨] 만능 질문 모델 (질문 이미지 URL 추가)
class TestQuestion {
  final String id;
  final String text;
  final String? imageUrl;
  final QuestionType type;
  final List<QuestionOption>? options;
  TestQuestion({required this.id, required this.text, this.imageUrl, this.type = QuestionType.text, this.options});
}

class QuestionOption {
  final String id;
  final String value;
  final String? text;
  final String? imageUrl;
  QuestionOption({required this.id, required this.value, this.text, this.imageUrl});
}