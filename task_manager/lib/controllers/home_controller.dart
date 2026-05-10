import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../services/firestore_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final _firestore = FirestoreService();

  final currentIndex = 0.obs;
  final tasks = <TaskModel>[].obs;
  final isLoading = true.obs;

  // Streak state — driven by the user document stream.
  final streak = 0.obs;
  final lastStreakDate = Rxn<DateTime>();

  StreamSubscription? _tasksSub;
  StreamSubscription? _userSub;
  Timer? _midnightTimer;
  bool _isEvaluatingStreak = false;
  bool _hasLoadedUser = false;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Listen to tasks.
    _tasksSub = _firestore.tasksStream(_uid).listen((list) {
      tasks.assignAll(list);
      isLoading.value = false;
      unawaited(_evaluatePendingStreakDays(showCelebration: false));
    }, onError: (_) => isLoading.value = false);

    // Listen to user document for streak.
    _userSub = _firestore.userStream(_uid).listen((user) {
      if (user == null) return;
      streak.value = user.streak;
      lastStreakDate.value = user.lastStreakDate;
      _hasLoadedUser = true;
      unawaited(_evaluatePendingStreakDays(showCelebration: false));
    });

    _scheduleMidnightStreakCheck();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _tasksSub?.cancel();
    _userSub?.cancel();
    _midnightTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    _scheduleMidnightStreakCheck();
    unawaited(_evaluatePendingStreakDays(showCelebration: false));
  }

  // ── Computed ─────────────────────────────────────────────────────────────────

  int get totalTasks => tasks.length;
  int get doneTasks => tasks.where((t) => t.isDone).length;
  double get progress => totalTasks == 0 ? 0 : doneTasks / totalTasks;

  List<TaskModel> get activeTasks => tasks.where((t) => !t.isDone).toList();

  List<TaskModel> get completedTasks => tasks.where((t) => t.isDone).toList()
    ..sort(
      (a, b) => (b.completedAt ?? DateTime(0)).compareTo(
        a.completedAt ?? DateTime(0),
      ),
    );

  Map<String, List<TaskModel>> get groupedHistory {
    final map = <String, List<TaskModel>>{};
    for (final task in completedTasks) {
      final label = _groupLabel(task.completedAt);
      map.putIfAbsent(label, () => []).add(task);
    }
    return map;
  }

  String _groupLabel(DateTime? dt) {
    if (dt == null) return 'Earlier';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${dt.day} ${taskMonthLabel(dt.month)} ${dt.year}';
  }

  // ── Streak logic ─────────────────────────────────────────────────────────────

  /// Credits completed task-days after they end. Today's tasks are evaluated
  /// at the next midnight, so the streak changes at 12:00 AM.
  Future<void> _evaluatePendingStreakDays({
    required bool showCelebration,
  }) async {
    if (!_hasLoadedUser || _isEvaluatingStreak || tasks.isEmpty) return;

    final yesterday = _dateOnly(DateTime.now()).subtract(
      const Duration(days: 1),
    );
    final firstPendingDay = _firstPendingStreakDay(yesterday);
    if (firstPendingDay == null || firstPendingDay.isAfter(yesterday)) return;

    _isEvaluatingStreak = true;
    try {
      var nextStreak = streak.value;
      DateTime? latestCreditedDay;

      for (
        var day = firstPendingDay;
        !day.isAfter(yesterday);
        day = day.add(const Duration(days: 1))
      ) {
        if (!_areAllTasksDoneForDay(day)) continue;

        nextStreak += 1;
        latestCreditedDay = day;
      }

      if (latestCreditedDay == null) return;

      await _firestore.updateStreak(_uid, nextStreak, latestCreditedDay);
      streak.value = nextStreak;
      lastStreakDate.value = latestCreditedDay;

      if (showCelebration) {
        _maybeShowStreakCelebration(nextStreak);
      }
    } finally {
      _isEvaluatingStreak = false;
    }
  }

  DateTime? _firstPendingStreakDay(DateTime yesterday) {
    final last = lastStreakDate.value != null
        ? _dateOnly(lastStreakDate.value!)
        : null;

    if (last != null) return last.add(const Duration(days: 1));

    final eligibleDays = tasks
        .map((task) => _dateOnly(task.dueDate))
        .where((day) => !day.isAfter(yesterday))
        .toList();

    if (eligibleDays.isEmpty) return null;
    eligibleDays.sort();
    return eligibleDays.first;
  }

  bool _areAllTasksDoneForDay(DateTime day) {
    final nextDay = day.add(const Duration(days: 1));
    final dayTasks = tasks.where((task) => _dateOnly(task.dueDate) == day);
    return dayTasks.isNotEmpty &&
        dayTasks.every(
          (task) =>
              task.isDone &&
              task.completedAt != null &&
              task.completedAt!.isBefore(nextDay),
        );
  }

  void _scheduleMidnightStreakCheck() {
    _midnightTimer?.cancel();

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final delay = tomorrow.difference(now);

    _midnightTimer = Timer(delay, () async {
      await _evaluatePendingStreakDays(showCelebration: true);
      _scheduleMidnightStreakCheck();
    });
  }

  void _maybeShowStreakCelebration(int s) {
    if (s == 1) {
      Get.snackbar(
        '🔥 Streak started!',
        'You completed all tasks today!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else if (s % 7 == 0) {
      Get.snackbar(
        '🏆 $s day streak!',
        'Amazing consistency — keep it up!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        '🔥 $s day streak!',
        'All tasks done — great work!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskStatus status,
  }) async {
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      isDone: status == TaskStatus.completed,
      completedAt: status == TaskStatus.completed ? DateTime.now() : null,
    );
    await _firestore.addTask(_uid, task);
  }

  Future<void> updateTask({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskStatus status,
  }) async {
    final task = tasks.firstWhere((t) => t.id == id);
    task.title = title;
    task.description = description;
    task.dueDate = dueDate;
    task.status = status;

    if (status == TaskStatus.completed && !task.isDone) {
      task.isDone = true;
      task.completedAt = DateTime.now();
    } else if (status != TaskStatus.completed && task.isDone) {
      task.isDone = false;
      task.completedAt = null;
    }

    await _firestore.updateTask(_uid, task);
  }

  Future<void> toggleTask(String id) async {
    final task = tasks.firstWhere((t) => t.id == id);
    task.isDone = !task.isDone;
    if (task.isDone) {
      task.completedAt = DateTime.now();
      task.status = TaskStatus.completed;
    } else {
      task.completedAt = null;
      task.status = TaskStatus.inProgress;
    }
    await _firestore.updateTask(_uid, task);
  }

  Future<void> deleteTask(String id) async {
    await _firestore.deleteTask(_uid, id);
  }

  void changeTab(int index) => currentIndex.value = index;
}
