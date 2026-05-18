import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/post_model.dart';
import '../utils/app_colors.dart';
import '../utils/time_utils.dart';
import 'user_avatar.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onBookmark,
    this.onDelete,
  });

  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback? onDelete;

  bool get _isLocalImage =>
      post.imageUrl != null && !post.imageUrl!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(post: post, onDelete: onDelete),
          if (post.imageUrl != null)
            _MediaSection(post: post, isLocal: _isLocalImage),
          _CaptionSection(post: post),
          _ActionBar(post: post, onLike: onLike, onBookmark: onBookmark),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.post, this.onDelete});
  final PostModel post;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 10),
      child: Row(
        children: [
          UserAvatar(imageUrl: post.userAvatar, radius: 20, hasStory: true),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${post.userHandle}  ·  ${TimeUtils.timeAgo(post.createdAt)}',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded,
                  color: AppColors.textHint),
              onPressed: () => _showOptions(context),
            )
          else
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded,
                  color: AppColors.textHint),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              title: const Text('Delete post',
                  style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Media ─────────────────────────────────────────────────────────────────────

class _MediaSection extends StatelessWidget {
  const _MediaSection({required this.post, required this.isLocal});
  final PostModel post;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.zero),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: isLocal
            ? Image.file(
                File(post.imageUrl!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : CachedNetworkImage(
                imageUrl: post.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: AppColors.surfaceLight,
                  highlightColor: AppColors.border,
                  child: Container(color: AppColors.surfaceLight),
                ),
                errorWidget: (_, __, ___) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.surfaceLight,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: AppColors.textHint, size: 40),
        ),
      );
}

// ── Caption ───────────────────────────────────────────────────────────────────

class _CaptionSection extends StatelessWidget {
  const _CaptionSection({required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.caption,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.tags
                  .map((t) => Text(
                        '#$t',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Action Bar ────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.post,
    required this.onLike,
    required this.onBookmark,
  });
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: [
          _ActionBtn(
            icon: post.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: TimeUtils.formatCount(post.likes),
            color: post.isLiked ? AppColors.accent : AppColors.textSecondary,
            onTap: onLike,
          ),
          _ActionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: TimeUtils.formatCount(post.comments),
            color: AppColors.textSecondary,
            onTap: () {},
          ),
          _ActionBtn(
            icon: Icons.send_rounded,
            label: TimeUtils.formatCount(post.shares),
            color: AppColors.textSecondary,
            onTap: () {},
          ),
          const Spacer(),
          _ActionBtn(
            icon: post.isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: '',
            color:
                post.isBookmarked ? AppColors.primary : AppColors.textSecondary,
            onTap: onBookmark,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
