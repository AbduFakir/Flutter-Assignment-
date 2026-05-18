import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../models/post_model.dart';
import '../utils/app_colors.dart';
import '../utils/time_utils.dart';
import '../app/app_pages.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      extendBody: true,
      body: Column(
        children: [
          const _FameoAppBar(),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: ctrl.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: ctrl.posts.length + 1, // +1 for stories header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _StoriesSection(stories: ctrl.stories);
                    }
                    final post = ctrl.posts[index - 1];
                    return Obx(() => PostCardWidget(
                          post: ctrl.posts[index - 1],
                          onLike: () => ctrl.toggleLike(post.id),
                          onBookmark: () => ctrl.toggleBookmark(post.id),
                          onDelete: post.userId == 'me'
                              ? () => ctrl.deletePost(post.id)
                              : null,
                        ));
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _FameoAppBar extends StatelessWidget {
  const _FameoAppBar();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      height: 70 + topPad,
      padding: EdgeInsets.only(
        top: topPad,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.appBarGradient,
      ),
      child: Row(
        children: [
          // Logo + name
          Row(
            children: [
              // Stylised "F"
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  'F',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'fameo - x',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Profile avatar with white border
          GradientAvatar(
            imageUrl: 'https://i.pravatar.cc/150?img=5',
            radius: 18,
            borderColor: Colors.white,
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STORIES SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _StoriesSection extends StatelessWidget {
  const _StoriesSection({required this.stories});
  final List<Map<String, String>> stories;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 92,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) {
            final s = stories[i];
            final isOwn = s['isOwn'] == 'true';
            return StoryWidget(
              name: isOwn ? 'Oracle' : (s['name'] ?? ''),
              avatarUrl: s['avatar'] ?? '',
              isOwn: isOwn,
              onTap: isOwn ? () => Get.toNamed(Routes.textEditor) : () {},
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STORY WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.isOwn = false,
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
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient ring
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.storyRingGradient,
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: avatarUrl.isEmpty
                      ? Container(
                          color: AppColors.surfaceLight,
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.primary, size: 28),
                        )
                      : CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: AppColors.surfaceLight),
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColors.surfaceLight),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
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

// ─────────────────────────────────────────────────────────────────────────────
// POST CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // 16 padding each side

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8AADE), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Full-width image — portrait aspect ratio ~0.72
              AspectRatio(
                aspectRatio: 0.72,
                child: post.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: post.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.surfaceLight,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceLight,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: AppColors.textHint, size: 48),
                        ),
                      )
                    : Container(color: AppColors.surfaceLight),
              ),

              // Dark gradient overlay (bottom 55%)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: AppColors.postOverlay,
                  ),
                ),
              ),

              // Top row: avatar + username + 3-dot
              Positioned(
                top: 12,
                left: 12,
                right: 8,
                child: _PostHeader(post: post, onDelete: onDelete),
              ),

              // Bottom: caption + action buttons
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _PostBottom(
                  post: post,
                  onLike: onLike,
                  onBookmark: onBookmark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Post Header ───────────────────────────────────────────────────────────────

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post, this.onDelete});
  final PostModel post;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientAvatar(
          imageUrl: post.userAvatar,
          radius: 18,
          borderColor: Colors.white,
          borderWidth: 1.5,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    const Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(0, 1))
                  ],
                ),
              ),
              Text(
                post.userHandle,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onDelete != null ? () => _showOptions(context) : () {},
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
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
            const SizedBox(height: 12),
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

// ── Post Bottom ───────────────────────────────────────────────────────────────

class _PostBottom extends StatelessWidget {
  const _PostBottom({
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
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Caption
          Expanded(
            child: Text(
              post.caption,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          // Action buttons
          _ActionOverlay(
            post: post,
            onLike: onLike,
            onBookmark: onBookmark,
          ),
        ],
      ),
    );
  }
}

// ── Action Overlay ────────────────────────────────────────────────────────────

class _ActionOverlay extends StatelessWidget {
  const _ActionOverlay({
    required this.post,
    required this.onLike,
    required this.onBookmark,
  });
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.black.withOpacity(0.35),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionItem(
              icon: post.isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              count: TimeUtils.formatCount(post.likes),
              color: AppColors.accent,
              onTap: onLike,
            ),
            const SizedBox(width: 10),
            _ActionItem(
              icon: Icons.chat_bubble_outline_rounded,
              count: TimeUtils.formatCount(post.comments),
              color: AppColors.accentCyan,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionItem(
              icon: Icons.send_rounded,
              count: '',
              color: AppColors.accentPurple,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.count,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 3),
            Text(
              count,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENT AVATAR
// ─────────────────────────────────────────────────────────────────────────────

class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
  });

  final String imageUrl;
  final double radius;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return Container(
      width: size + borderWidth * 2,
      height: size + borderWidth * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(borderWidth),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? Container(
                color: AppColors.surfaceLight,
                child:
                    const Icon(Icons.person_rounded, color: AppColors.primary),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.surfaceLight),
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.surfaceLight),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM BOTTOM BAR
// ─────────────────────────────────────────────────────────────────────────────

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(icon: Icons.home_rounded, isActive: true),
          const SizedBox(width: 8),
          // Center create button
          _CreateButton(onTap: () => Get.toNamed(Routes.upload)),
          const SizedBox(width: 8),
          _NavIcon(icon: Icons.notifications_none_rounded, isActive: false),
          _NavIcon(icon: Icons.person_outline_rounded, isActive: false),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.isActive});
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: Icon(
        icon,
        color: isActive ? AppColors.primary : AppColors.textHint,
        size: 24,
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              'Create',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
