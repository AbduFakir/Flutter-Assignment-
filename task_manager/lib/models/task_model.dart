enum TaskStatus { inProgress, completed, highPriority }

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.isDone = false,
    this.completedAt,
  });

  final String id;
  String title;
  String description;
  DateTime dueDate;
  TaskStatus status;
  bool isDone;
  DateTime? completedAt;

  // ── Serialisation ────────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'status': status.name,
    'isDone': isDone,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    dueDate: DateTime.parse(map['dueDate'] as String),
    status: TaskStatus.values.byName(map['status'] as String),
    isDone: map['isDone'] as bool? ?? false,
    completedAt: map['completedAt'] != null
        ? DateTime.parse(map['completedAt'] as String)
        : null,
  );

  // ── Display helpers ──────────────────────────────────────────────────────────

  String get dateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';
    return '${_month(dueDate.month)} ${dueDate.day}';
  }

  static String _month(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
}

String taskMonthLabel(int m) => const [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][m];
