import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _tasksRef(String uid) =>
      _userRef(uid).collection('tasks');

  // ── User document ────────────────────────────────────────────────────────────

  Future<void> createUser(UserModel user) =>
      _userRef(user.uid).set(user.toMap());

  Future<UserModel?> getUser(String uid) async {
    final doc = await _userRef(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  /// Real-time stream of the user document.
  Stream<UserModel?> userStream(String uid) => _userRef(
    uid,
  ).snapshots().map((s) => s.exists ? UserModel.fromMap(s.data()!) : null);

  /// Atomically updates streak and lastStreakDate on the user document.
  Future<void> updateStreak(String uid, int streak, DateTime lastStreakDate) =>
      _userRef(uid).update({
        'streak': streak,
        'lastStreakDate': lastStreakDate.toIso8601String(),
      });

  // ── Tasks sub-collection ─────────────────────────────────────────────────────

  Stream<List<TaskModel>> tasksStream(String uid) => _tasksRef(uid)
      .orderBy('dueDate')
      .snapshots()
      .map((s) => s.docs.map((d) => TaskModel.fromMap(d.data())).toList());

  Future<void> addTask(String uid, TaskModel task) =>
      _tasksRef(uid).doc(task.id).set(task.toMap());

  Future<void> updateTask(String uid, TaskModel task) =>
      _tasksRef(uid).doc(task.id).set(task.toMap());

  Future<void> deleteTask(String uid, String taskId) =>
      _tasksRef(uid).doc(taskId).delete();
}
