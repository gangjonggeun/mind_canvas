// core/presentation/psy_dashboard_components.dart

import 'dart:io';

import 'package:flutter/material.dart';

/// ✅ 공통 상태 Enum
enum PsyTaskStatus { notStarted, inProgress, completed }

/// 1️⃣ 헤더
class PsyHeader extends StatelessWidget {
  final String title;
  final String description;
  final bool isDarkMode;

  const PsyHeader({
    required this.title,
    required this.description,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
            letterSpacing: -0.8,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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

  // 동작 콜백
  final VoidCallback onStart;      // 시작/수정
  final VoidCallback onUpload;     // 업로드
  final VoidCallback onPreview;    // 미리보기

  const PsyTaskCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.status,
    required this.isDarkMode,
    required this.onStart,
    required this.onUpload,
    required this.onPreview,
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
          Column(
            children: [
              _buildBtn(status == PsyTaskStatus.notStarted ? "그리기" : "수정", status == PsyTaskStatus.notStarted ? Icons.brush : Icons.edit, color, onStart, true),
              const SizedBox(height: 6),
              _buildBtn("업로드", Icons.upload_file, Colors.grey, onUpload, false),
              if (status == PsyTaskStatus.completed) ...[
                const SizedBox(height: 6),
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
