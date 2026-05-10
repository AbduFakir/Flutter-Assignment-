import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/quote_controller.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../widgets/task_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const background = Color(0xFFF0EFFA);
  static const primary = Color(0xFF4A32E8);
  static const textColor = Color(0xFF252B3A);
  static const muted = Color(0xFF8D8A9D);
  static const cardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final quoteCtrl = Get.put(QuoteController());
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width < 360 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(hPad),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _quoteCard(quoteCtrl),
                    const SizedBox(height: 20),
                    _progressRow(controller),
                    const SizedBox(height: 24),
                    _sectionHeader('Today\'s Tasks', 'View All'),
                    const SizedBox(height: 14),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primary,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }

                      final activeTasks = controller.activeTasks;
                      if (activeTasks.isEmpty) return _emptyTaskState();

                      return Column(
                        children: activeTasks
                            .map((t) => _taskCard(context, t, controller))
                            .toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ─────────────────────────────────────────────────────────────────

  Widget _topBar(double hPad) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 14),
      child: Row(
        children: [
          // const SizedBox(width: 10),
          const Text(
            'TaskFlow',
            style: TextStyle(
              color: primary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => AuthService().signOut(),
            child: const Icon(Icons.logout_rounded, color: primary, size: 22),
          ),
        ],
      ),
    );
  }

  // ── Quote card ──────────────────────────────────────────────────────────────

  Widget _quoteCard(QuoteController ctrl) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ctrl.isLoading.value
            ? _quoteLoading()
            : ctrl.hasError.value
            ? _quoteError(ctrl)
            : _quoteContent(ctrl),
      );
    });
  }

  Widget _quoteLoading() {
    return const SizedBox(
      height: 90,
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _quoteError(QuoteController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Could not load quote.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: ctrl.fetchQuote,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quoteContent(QuoteController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '❝',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            GestureDetector(
              onTap: ctrl.fetchQuote,
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white38,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '"${ctrl.quote.value}"',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '— ${ctrl.author.value}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Progress row ────────────────────────────────────────────────────────────

  Widget _progressRow(HomeController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6656BA).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Obx(() => _progressInfo(controller))),
          const SizedBox(width: 16),
          _streakBadge(controller),
        ],
      ),
    );
  }

  Widget _progressInfo(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Daily Progress',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${(controller.progress * 100).toInt()}%',
              style: const TextStyle(
                color: primary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: controller.progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFE8E4FB),
            valueColor: const AlwaysStoppedAnimation<Color>(primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${controller.doneTasks} of ${controller.totalTasks} tasks done',
          style: const TextStyle(
            color: muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _streakBadge(HomeController controller) {
    return Obx(
      () => Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${controller.streak.value} Day',
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Current Streak',
            style: TextStyle(
              color: muted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ──────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: primary,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: Text(action),
        ),
      ],
    );
  }

  // ── Task card ───────────────────────────────────────────────────────────────

  Widget _taskCard(
    BuildContext context,
    TaskModel task,
    HomeController controller,
  ) {
    final isDone = task.isDone;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6656BA).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 70,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _taskTitle(task.title, isDone)),
                    _taskActions(context, task, controller),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.dateLabel,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusChip(task.status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyTaskState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFEDE9FB),
              child: Icon(Icons.task_alt_rounded, color: primary, size: 34),
            ),
            SizedBox(height: 16),
            Text(
              'No active tasks',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Completed tasks are in History.',
              style: TextStyle(
                color: muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskTitle(String title, bool isDone) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        decoration: isDone ? TextDecoration.lineThrough : null,
        decorationColor: textColor,
      ),
    );
  }

  Widget _taskActions(
    BuildContext context,
    TaskModel task,
    HomeController controller,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => showEditTaskSheet(context, task),
          child: const Icon(Icons.edit_outlined, size: 17, color: muted),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => controller.deleteTask(task.id),
          child: const Icon(
            Icons.delete_outline_rounded,
            size: 17,
            color: muted,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => controller.toggleTask(task.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: task.isDone ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: task.isDone ? primary : const Color(0xFFD0CCDF),
                width: 1.5,
              ),
            ),
            child: task.isDone
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(TaskStatus status) {
    final (label, bg, fg) = switch (status) {
      TaskStatus.inProgress => (
        'In Progress',
        const Color(0xFFEDE9FB),
        primary,
      ),
      TaskStatus.completed => (
        'Completed',
        const Color(0xFFE8EDF5),
        const Color(0xFF7A8AA0),
      ),
      TaskStatus.highPriority => (
        'High Priority',
        Colors.transparent,
        const Color(0xFFE53935),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}
