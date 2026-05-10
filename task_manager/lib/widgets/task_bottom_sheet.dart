import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../models/task_model.dart';

const _primary = Color(0xFF4A32E8);
const _textColor = Color(0xFF252B3A);
const _muted = Color(0xFF8D8A9D);
const _border = Color(0xFFE0DDEC);
const _bg = Color(0xFFF0EFFA);

/// Call this to open the Add sheet.
void showAddTaskSheet(BuildContext context) {
  _showSheet(context, null);
}

/// Call this to open the Edit sheet for an existing task.
void showEditTaskSheet(BuildContext context, TaskModel task) {
  _showSheet(context, task);
}

void _showSheet(BuildContext context, TaskModel? task) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaskSheet(task: task),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _TaskSheet extends StatefulWidget {
  const _TaskSheet({this.task});
  final TaskModel? task;

  @override
  State<_TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<_TaskSheet> {
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late DateTime _dueDate;
  late TaskStatus _status;

  bool get _isEdit => widget.task != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.task?.title ?? '');
    _desc = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _status = widget.task?.status ?? TaskStatus.inProgress;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _title.text.trim();
    final desc = _desc.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Title is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final controller = Get.find<HomeController>();

    if (_isEdit) {
      controller.updateTask(
        id: widget.task!.id,
        title: title,
        description: desc,
        dueDate: _dueDate,
        status: _status,
      );
    } else {
      controller.addTask(
        title: title,
        description: desc,
        dueDate: _dueDate,
        status: _status,
      );
    }

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _primary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),
          _sheetHeader(),
          const SizedBox(height: 20),
          _fieldLabel('Task Title'),
          const SizedBox(height: 8),
          _textField(
            controller: _title,
            hint: 'e.g. Design System Update',
            icon: Icons.title_rounded,
          ),
          const SizedBox(height: 16),
          _fieldLabel('Description'),
          const SizedBox(height: 8),
          _textField(
            controller: _desc,
            hint: 'Add a short description...',
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Due Date'),
                    const SizedBox(height: 8),
                    _datePicker(),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Status'),
                    const SizedBox(height: 8),
                    _statusPicker(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _submitButton(),
        ],
      ),
    );
  }

  // ── Drag handle ─────────────────────────────────────────────────────────────

  Widget _handle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFDDDAEA),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── Sheet header ────────────────────────────────────────────────────────────

  Widget _sheetHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _isEdit ? Icons.edit_rounded : Icons.add_task_rounded,
            color: _primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Edit Task' : 'New Task',
              style: const TextStyle(
                color: _textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              _isEdit ? 'Update the task details' : 'Fill in the details below',
              style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close_rounded, color: _muted, size: 16),
          ),
        ),
      ],
    );
  }

  // ── Field label ─────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _muted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ── Text field ──────────────────────────────────────────────────────────────

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: _primary,
      style: const TextStyle(
        color: _textColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFD4D1DF),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: _muted, size: 18)
            : Padding(
                padding: const EdgeInsets.only(left: 12, top: 12),
                child: Icon(icon, color: _muted, size: 18),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        filled: true,
        fillColor: _bg,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines > 1 ? 12 : 14,
        ),
        enabledBorder: _outlineBorder(_border),
        focusedBorder: _outlineBorder(_primary),
        border: _outlineBorder(_border),
      ),
    );
  }

  OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.4),
  );

  // ── Date picker ─────────────────────────────────────────────────────────────

  Widget _datePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border, width: 1.4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: _muted, size: 16),
            const SizedBox(width: 8),
            Text(
              _formatDate(_dueDate),
              style: const TextStyle(
                color: _textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${taskMonthLabel(d.month)} ${d.day}, ${d.year}';
  }

  // ── Status picker ───────────────────────────────────────────────────────────

  Widget _statusPicker() {
    return GestureDetector(
      onTap: _showStatusMenu,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border, width: 1.4),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _statusColor(_status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _statusLabel(_status),
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.expand_more_rounded, color: _muted, size: 16),
          ],
        ),
      ),
    );
  }

  void _showStatusMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDAEA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Select Status',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ...TaskStatus.values.map((s) => _statusOption(s)),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(TaskStatus s) {
    final selected = _status == s;
    return GestureDetector(
      onTap: () {
        setState(() => _status = s);
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEDE9FB) : _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _primary : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _statusColor(s),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _statusLabel(s),
              style: TextStyle(
                color: selected ? _primary : _textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_rounded, color: _primary, size: 18),
          ],
        ),
      ),
    );
  }

  String _statusLabel(TaskStatus s) => switch (s) {
    TaskStatus.inProgress => 'In Progress',
    TaskStatus.completed => 'Completed',
    TaskStatus.highPriority => 'High Priority',
  };

  Color _statusColor(TaskStatus s) => switch (s) {
    TaskStatus.inProgress => _primary,
    TaskStatus.completed => const Color(0xFF2ECC71),
    TaskStatus.highPriority => const Color(0xFFE53935),
  };

  // ── Submit button ───────────────────────────────────────────────────────────

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: _submit,
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        child: Text(_isEdit ? 'Save Changes' : 'Add Task'),
      ),
    );
  }
}
