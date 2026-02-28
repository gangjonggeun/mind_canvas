// core/presentation/psy_dashboard_components.dart

import 'dart:io';

import 'package:flutter/material.dart';

/// ✅ 공통 상태 Enum
enum PsyTaskStatus { notStarted, inProgress, completed }

/// 1️⃣ 헤더
class PsyHeader extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon; // ✅ 카드 배경에 은은하게 깔릴 아이콘 추가
  final bool isDarkMode;

  const PsyHeader({
    required this.title,
    required this.description,
    required this.icon,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // 다크모드/라이트모드에 따른 세련된 그라데이션 배경
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF3182CE), const Color(0xFF2B6CB0)], // 라이트모드는 블루톤
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : const Color(0xFF3182CE)).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 💡 배경에 은은하게 깔리는 워터마크 아이콘 (고급스러움 연출)
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              icon,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          // 텍스트 영역
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 작은 뱃지 느낌의 장식
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Mind Canvas',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 2️⃣ 진행바
class PsyProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final bool isDarkMode;

  const PsyProgressBar({
    required this.current,
    required this.total,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : current / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B).withOpacity(0.8) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('진행 상황', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : Colors.black87)),
              Text('$current / $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF38A169))),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: isDarkMode ? Colors.white24 : Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38A169)),
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

/// 3️⃣ 작업 카드 (로직 없이 UI만 담당)
class PsyTaskCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final PsyTaskStatus status;
  final bool isDarkMode;

  final VoidCallback onStart;
  final VoidCallback onUpload;
  final VoidCallback onPreview;

  // ✅ 추가된 옵션들 (텍스트, 아이콘, 업로드 버튼 숨김 여부)
  final bool showUpload;
  final String actionText;
  final String completedActionText;
  final IconData actionIcon;

  const PsyTaskCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.status,
    required this.isDarkMode,
    required this.onStart,
    required this.onUpload,
    required this.onPreview,
    this.showUpload = true,                  // 기본은 보이게
    this.actionText = '그리기',                 // 기본 텍스트
    this.completedActionText = '수정',         // 기본 완료 텍스트
    this.actionIcon = Icons.brush,           // 기본 아이콘
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B).withOpacity(0.8) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == PsyTaskStatus.completed ? const Color(0xFF38A169) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // 아이콘 및 텍스트 영역 (기존과 동일)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87)),
                Text(
                  status == PsyTaskStatus.completed ? "완료됨" : "미완료",
                  style: TextStyle(fontSize: 12, color: status == PsyTaskStatus.completed ? const Color(0xFF38A169) : Colors.grey),
                ),
              ],
            ),
          ),

          // 💡 버튼 영역 (수정됨)
          Column(
            children: [
              // 1. 메인 액션 버튼 (텍스트/아이콘 동적 적용)
              _buildBtn(
                status == PsyTaskStatus.notStarted ? actionText : completedActionText,
                status == PsyTaskStatus.notStarted ? actionIcon : Icons.edit,
                color,
                onStart,
                true,
              ),
              const SizedBox(height: 6),

              // 2. 업로드 버튼 (showUpload가 true일 때만 렌더링)
              if (showUpload) ...[
                _buildBtn("업로드", Icons.upload_file, Colors.grey, onUpload, false),
                const SizedBox(height: 6),
              ],

              // 3. 미리보기 버튼 (완료 상태일 때만)
              if (status == PsyTaskStatus.completed) ...[
                _buildBtn("확인", Icons.visibility, Colors.blueGrey, onPreview, false),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBtn(String txt, IconData icn, Color col, VoidCallback onTap, bool primary) {
    return SizedBox(
      width: 90, height: 32,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icn, size: 14),
        label: Text(txt, style: const TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? col : Colors.transparent,
          foregroundColor: primary ? Colors.white : col,
          elevation: primary ? 2 : 0,
          padding: EdgeInsets.zero,
          side: primary ? null : BorderSide(color: col.withOpacity(0.5)),
        ),
      ),
    );
  }
}

/// 4️⃣ 제출 버튼
class PsySubmitButton extends StatelessWidget {
  final bool isEnabled;
  final bool isSubmitting;
  final String text;
  final VoidCallback onPressed;

  const PsySubmitButton({
    required this.isEnabled,
    required this.isSubmitting,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 56,
      child: ElevatedButton(
        onPressed: (isEnabled && !isSubmitting) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? const Color(0xFF38A169) : Colors.grey[400],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isSubmitting
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}


class PsyInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const PsyInfoRow({required this.label, required this.value, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// 6️⃣ 미리보기 다이얼로그 (UI만 담당)
class PsyPreviewDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final File imageFile;
  final Map<String, String> metaData; // 소요시간, 획수 등
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  const PsyPreviewDialog({
    required this.title,
    required this.icon,
    required this.imageFile,
    required this.metaData, // {'소요 시간': '10초', '획수': '5회'}
    required this.onEdit,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 24),
                const SizedBox(width: 12),
                Text('$title 미리보기', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          // 이미지
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              maxWidth: double.infinity,
            ),
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
          // 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: metaData.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PsyInfoRow(
                  label: e.key,
                  value: e.value,
                  icon: _getIconForLabel(e.key),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('수정하기'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('확인'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    if (label.contains('시간')) return Icons.timer_outlined;
    if (label.contains('수정')) return Icons.edit_rounded;
    return Icons.gesture_rounded;
  }
}


/// PDI 질문 데이터 모델
class PdiQuestion {
  final String id;
  final String questionText;
  final String? hintText;
  final bool isMultiline; // 여러 줄 입력 여부

  PdiQuestion({
    required this.id,
    required this.questionText,
    this.hintText,
    this.isMultiline = true,
  });
}

/// 🎨 PDI (그림 완성 후 질문) 전용 대형 다이얼로그
class PsyPdiDialog extends StatefulWidget {
  final String title;
  final List<PdiQuestion> questions;
  final Map<String, String>? initialAnswers; // 기존 답변이 있다면 불러오기
  final Function(Map<String, String>) onSubmit;

  const PsyPdiDialog({
    required this.title,
    required this.questions,
    required this.onSubmit,
    this.initialAnswers,
    super.key,
  });

  @override
  State<PsyPdiDialog> createState() => _PsyPdiDialogState();
}

class _PsyPdiDialogState extends State<PsyPdiDialog> {
  // 각 질문의 답변을 저장할 컨트롤러 맵
  final Map<String, TextEditingController> _controllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 질문 개수만큼 컨트롤러 생성 및 초기값 세팅
    for (var q in widget.questions) {
      _controllers[q.id] = TextEditingController(
        text: widget.initialAnswers?[q.id] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    // 👈 2. 수정: 스낵바 로직 대신 폼 검증(validate) 실행
    if (!_formKey.currentState!.validate()) {
      return; // 빈칸이 있으면 자동으로 TextFormField 아래에 에러 메시지가 뜹니다.
    }

    final Map<String, String> answers = {};
    _controllers.forEach((id, controller) {
      answers[id] = controller.text.trim();
    });

    widget.onSubmit(answers);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Dialog 안에 Scaffold를 넣어서 키보드 리사이징 방지
    return Dialog(
      backgroundColor: Colors.transparent, // 배경 투명 (Scaffold 색상 사용)
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Scaffold(
          // 🌟 [핵심] 키보드가 올라와도 화면(버튼)을 밀어 올리지 않음 -> 렉 제거
          resizeToAvoidBottomInset: false,
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,

          // 헤더와 리스트는 Column으로 배치
          body: Column(
            children: [
              // 1. 헤더 (고정)
              Container(
                padding: const EdgeInsets.all(20),
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                child: Row(
                  children: [
                    const Icon(Icons.forum_rounded, color: Color(0xFF38A169)),
                    const SizedBox(width: 12),
                    Text(
                      '${widget.title} (PDI)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 2. 폼 영역 (스크롤 가능)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // 하단 여백 충분히 줌
                    itemCount: widget.questions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final q = widget.questions[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${index + 1}. ${q.questionText}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _controllers[q.id],
                            maxLines: q.isMultiline ? 3 : 1,
                            validator: (v) => (v == null || v.trim().isEmpty) ? '내용을 입력해주세요' : null,
                            decoration: InputDecoration(
                              hintText: q.hintText ?? '답변을 입력해주세요',
                              filled: true,
                              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // 3. 하단 버튼 (Scaffold의 bottomNavigationBar를 활용하여 바닥 고정)
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black12)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38A169),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  '답변 저장하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}