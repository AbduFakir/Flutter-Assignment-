import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../models/task_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const background = Color(0xFFF0EFFA);
  static const primary = Color(0xFF4A32E8);
  static const textColor = Color(0xFF252B3A);
  static const muted = Color(0xFF8D8A9D);
  static const cardBg = Colors.white;
  static const green = Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width < 360 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(hPad),
            Expanded(
              child: Obx(() {
                final grouped = controller.groupedHistory;
                final completed = controller.completedTasks;
                return Column(
                  children: [
                    _summaryRow(
                      completed.length,
                      controller.streak.value,
                      hPad,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: grouped.isEmpty
                          ? _emptyState()
                          : ListView(
                              padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 24),
                              children: grouped.entries
                                  .map(
                                    (e) => _group(e.key, e.value, controller),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                );
              }),
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
          const Text(
            'History',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.filter_list_rounded, color: primary, size: 14),
                SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary row ─────────────────────────────────────────────────────────────

  Widget _summaryRow(int total, int streakVal, double hPad) {
    final rate = total == 0
        ? '0%'
        : '${((total / (total + 1)) * 100).toInt()}%';
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 12),
      child: Row(
        children: [
          _statCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: green,
            value: '$total',
            label: 'Completed',
          ),
          const SizedBox(width: 12),
          _statCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFFF6B35),
            value: '$streakVal',
            label: 'Day Streak',
          ),
          const SizedBox(width: 12),
          _statCard(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFF4A340),
            value: rate,
            label: 'Rate',
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6656BA).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Group ───────────────────────────────────────────────────────────────────

  Widget _group(
    String label,
    List<TaskModel> tasks,
    HomeController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _groupHeader(label, tasks.length),
        const SizedBox(height: 10),
        ...tasks.map((t) => _historyCard(t, controller)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _groupHeader(String label, int count) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ── History card ────────────────────────────────────────────────────────────

  Widget _historyCard(TaskModel task, HomeController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6656BA).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: green, size: 17),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: muted,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.toggleTask(task.id),
                      child: const Tooltip(
                        message: 'Mark as incomplete',
                        child: Icon(Icons.undo_rounded, size: 16, color: muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: green,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
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
  }

  // ── Empty state ─────────────────────────────────────────────────────────────

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFEDE9FB),
            child: Icon(Icons.history_rounded, color: primary, size: 36),
          ),
          SizedBox(height: 18),
          Text(
            'No completed tasks yet',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete tasks to see them here.',
            style: TextStyle(color: muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
