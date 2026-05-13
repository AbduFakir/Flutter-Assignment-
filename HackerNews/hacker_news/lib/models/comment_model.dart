class Comment {
  final int id;
  final String by;
  final int time;
  final String? text;
  final List<int> kids;
  final int? parent;
  final bool deleted;
  final bool dead;
  List<Comment> children;

  Comment({
    required this.id,
    required this.by,
    required this.time,
    this.text,
    required this.kids,
    this.parent,
    required this.deleted,
    required this.dead,
    this.children = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      by: json['by'] ?? '[deleted]',
      time: json['time'] ?? 0,
      text: json['text'],
      kids: List<int>.from(json['kids'] ?? []),
      parent: json['parent'],
      deleted: json['deleted'] ?? false,
      dead: json['dead'] ?? false,
    );
  }
}
