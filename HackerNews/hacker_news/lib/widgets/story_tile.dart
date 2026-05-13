import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../utils/time_utils.dart';

class StoryTile extends StatelessWidget {
  final Story story;
  final int index;
  final VoidCallback onTap;

  const StoryTile({
    super.key,
    required this.story,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final domain = story.domain;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number
            SizedBox(
              width: 28,
              child: Text(
                '$index.',
                style: const TextStyle(fontSize: 13, color: Color(0xFF828282)),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 4),
            // Upvote triangle
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.arrow_drop_up,
                size: 16,
                color: const Color(0xFF828282),
              ),
            ),
            const SizedBox(width: 2),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + domain
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: story.title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        if (domain.isNotEmpty)
                          TextSpan(
                            text: ' ($domain)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF828282),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Metadata row
                  Text(
                    '${story.score} points by ${story.by} ${timeAgo(story.time)} | hide | ${story.descendants} comment${story.descendants != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF828282),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
