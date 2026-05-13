import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/story_model.dart';
import '../models/comment_model.dart';
import '../services/hn_api_service.dart';
import '../utils/time_utils.dart';
import '../widgets/comment_widget.dart';

class DetailScreen extends StatefulWidget {
  final Story story;

  const DetailScreen({super.key, required this.story});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _api = HnApiService();
  List<Comment> _comments = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final kids = widget.story.kids.take(20).toList();
      final futures = kids.map((id) => _api.fetchCommentWithChildren(id));
      final results = await Future.wait(futures);
      setState(() {
        _comments = results.whereType<Comment>().toList();
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      body: Column(
        children: [
          _buildAppBar(context, story),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6600)),
                  )
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(fontSize: 13),
                        ),
                        TextButton(
                          onPressed: _loadComments,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      _buildStoryHeader(story),
                      const Divider(height: 1, color: Color(0xFFE8E8E8)),
                      ..._comments.map(
                        (c) => CommentWidget(comment: c, depth: 0),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Story story) {
    return Container(
      color: const Color(0xFFFF6600),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'Y',
                        style: TextStyle(
                          color: Color(0xFFFF6600),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Hacker News',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'back',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: const Text(
                'new | past | comments | ask | show | jobs | submit',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryHeader(Story story) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            story.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Color(0xFF000000),
            ),
          ),
          if (story.domain.isNotEmpty)
            Text(
              '(${story.domain})',
              style: const TextStyle(fontSize: 11, color: Color(0xFF828282)),
            ),
          const SizedBox(height: 4),
          // Metadata
          Text(
            '${story.score} points by ${story.by} ${timeAgo(story.time)} | prev | next',
            style: const TextStyle(fontSize: 11, color: Color(0xFF828282)),
          ),
          // Story text if any (Ask HN etc.)
          if (story.text != null && story.text!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Html(
              data: story.text!,
              style: {
                'body': Style(
                  fontSize: FontSize(13),
                  color: const Color(0xFF333333),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                'a': Style(
                  color: const Color(0xFF828282),
                  textDecoration: TextDecoration.underline,
                ),
              },
            ),
          ],
          const SizedBox(height: 4),
          Text(
            '${story.descendants} comment${story.descendants != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF828282)),
          ),
        ],
      ),
    );
  }
}
