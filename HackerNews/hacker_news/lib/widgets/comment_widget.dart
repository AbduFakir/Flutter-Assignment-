import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/comment_model.dart';
import '../utils/time_utils.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final int depth;

  const CommentWidget({super.key, required this.comment, this.depth = 0});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;
    final indent = widget.depth * 12.0;

    return Container(
      margin: EdgeInsets.only(left: indent),
      decoration: BoxDecoration(
        border: Border(
          left: widget.depth > 0
              ? const BorderSide(color: Color(0xFFE0E0E0), width: 1)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_drop_up,
                  size: 14,
                  color: const Color(0xFF828282),
                ),
                const SizedBox(width: 2),
                GestureDetector(
                  onTap: () => setState(() => _collapsed = !_collapsed),
                  child: Text(
                    c.by,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF828282),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${timeAgo(c.time)} | ',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF828282),
                  ),
                ),
                if (widget.depth > 0)
                  const Text(
                    'parent | ',
                    style: TextStyle(fontSize: 11, color: Color(0xFF828282)),
                  ),
                Text(
                  'next [${_collapsed ? '+' : '-'}]',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF828282),
                  ),
                ),
              ],
            ),
          ),
          // Comment body
          if (!_collapsed) ...[
            if (c.text != null && c.text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Html(
                  data: c.text!,
                  style: {
                    'body': Style(
                      fontSize: FontSize(13),
                      color: const Color(0xFF333333),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    'p': Style(margin: Margins.only(top: 4, bottom: 4)),
                    'a': Style(
                      color: const Color(0xFF828282),
                      textDecoration: TextDecoration.underline,
                    ),
                    'pre': Style(
                      fontSize: FontSize(11),
                      backgroundColor: const Color(0xFFF6F6EF),
                    ),
                    'code': Style(
                      fontSize: FontSize(11),
                      backgroundColor: const Color(0xFFF6F6EF),
                    ),
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
              child: Text(
                'reply',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF828282),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            // Children
            ...c.children.map(
              (child) => CommentWidget(comment: child, depth: widget.depth + 1),
            ),
          ],
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],
      ),
    );
  }
}
