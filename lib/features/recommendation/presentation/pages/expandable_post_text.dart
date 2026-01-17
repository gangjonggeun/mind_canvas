// =============================================================================
// 📝 [Widget] 5줄 이상 시 '더보기' 기능이 있는 텍스트
// =============================================================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandablePostText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandablePostText({
    super.key,
    required this.text,
    this.maxLines = 5, // 기본 5줄
  });

  @override
  State<ExpandablePostText> createState() => _ExpandablePostTextState();
}

class _ExpandablePostTextState extends State<ExpandablePostText> {
  bool _isExpanded = false; // 펼쳐졌는지 여부

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. 텍스트 스타일 정의
        const style = TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.5,
        );

        // 2. 텍스트가 maxLines를 넘는지 계산
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        // 3. 넘지 않으면 그냥 텍스트 출력
        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: style);
        }

        // 4. 넘으면 '더보기' 버튼 로직 적용
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              // 펼쳐졌으면 제한 없음(null), 닫혔으면 maxLines 적용
              maxLines: _isExpanded ? null : widget.maxLines,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (!_isExpanded) // 닫혀있을 때만 '더보기' 표시
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "더보기",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}