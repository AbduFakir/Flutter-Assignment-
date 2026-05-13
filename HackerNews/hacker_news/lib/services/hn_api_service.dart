import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story_model.dart';
import '../models/comment_model.dart';

class HnApiService {
  static const String _base = 'https://hacker-news.firebaseio.com/v0';

  Future<List<int>> fetchTopStoryIds() async {
    final res = await http.get(Uri.parse('$_base/topstories.json'));
    if (res.statusCode == 200) {
      return List<int>.from(jsonDecode(res.body));
    }
    throw Exception('Failed to load top stories');
  }

  Future<Story?> fetchStory(int id) async {
    final res = await http.get(Uri.parse('$_base/item/$id.json'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data == null) return null;
      return Story.fromJson(data);
    }
    return null;
  }

  Future<Comment?> fetchComment(int id) async {
    final res = await http.get(Uri.parse('$_base/item/$id.json'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data == null) return null;
      return Comment.fromJson(data);
    }
    return null;
  }

  Future<Comment?> fetchCommentWithChildren(int id, {int depth = 0}) async {
    if (depth > 4) return null; // limit recursion depth
    final comment = await fetchComment(id);
    if (comment == null || comment.deleted || comment.dead) return null;

    if (comment.kids.isNotEmpty) {
      final futures = comment.kids
          .take(10)
          .map((kid) => fetchCommentWithChildren(kid, depth: depth + 1));
      final results = await Future.wait(futures);
      comment.children = results.whereType<Comment>().toList();
    }
    return comment;
  }
}
