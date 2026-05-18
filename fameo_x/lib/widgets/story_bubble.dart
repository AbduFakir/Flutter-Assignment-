import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'user_avatar.dart';

class StoryBubble extends StatelessWidget {
  const StoryBubble({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOwn,
    this.onTap,
  });

  final String name;
  final String avatarUrl;
  final bool isOwn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                UserAvatar(
                  imageUrl: avatarUrl,
                  radius: 28,
                  hasStory: !isOwn,
                  isOwn: isOwn,
                ),
                if (isOwn)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              isOwn ? 'Your Story' : name,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
