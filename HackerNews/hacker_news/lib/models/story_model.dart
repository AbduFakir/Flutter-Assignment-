class Story {
  final int id;
  final String title;
  final String by;
  final int score;
  final int time;
  final String? url;
  final List<int> kids;
  final int descendants;
  final String type;
  final String? text;

  Story({
    required this.id,
    required this.title,
    required this.by,
    required this.score,
    required this.time,
    this.url,
    required this.kids,
    required this.descendants,
    required this.type,
    this.text,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      by: json['by'] ?? '[deleted]',
      score: json['score'] ?? 0,
      time: json['time'] ?? 0,
      url: json['url'],
      kids: List<int>.from(json['kids'] ?? []),
      descendants: json['descendants'] ?? 0,
      type: json['type'] ?? 'story',
      text: json['text'],
    );
  }

  String get domain {
    if (url == null || url!.isEmpty) return '';
    try {
      final uri = Uri.parse(url!);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }
}
