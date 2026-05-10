class UserModel {
  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.streak = 0,
    this.lastStreakDate,
  });

  final String uid;
  final String displayName;
  final String email;
  final DateTime createdAt;
  int streak;
  DateTime? lastStreakDate;

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'createdAt': createdAt.toIso8601String(),
    'streak': streak,
    'lastStreakDate': lastStreakDate?.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] as String,
    displayName: map['displayName'] as String,
    email: map['email'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    streak: (map['streak'] as int?) ?? 0,
    lastStreakDate: map['lastStreakDate'] != null
        ? DateTime.parse(map['lastStreakDate'] as String)
        : null,
  );
}
