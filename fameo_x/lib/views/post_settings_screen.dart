import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/post_settings_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/description_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/setting_tile.dart';
import '../widgets/toggle_tile.dart';

class PostSettingsScreen extends StatelessWidget {
  const PostSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostSettingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ── Image preview + Edit post button ──────────────
                _PostImageSection(ctrl: ctrl),
                const SizedBox(height: 22),

                // ── Describe your feeling ─────────────────────────
                _SectionLabel(title: 'DESCRIBE YOUR FEELING'),
                Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DescriptionCard(
                        description: ctrl.description.value,
                        hashtags: const ['#Hashtag', '#Nature'],
                        currentCount: ctrl.currentCount.value,
                        maxCount: ctrl.maxCount,
                      ),
                    )),
                const SizedBox(height: 26),

                // ── Post Setting header ───────────────────────────
                _PostSettingHeader(),
                const SizedBox(height: 10),

                // ── Settings list card ────────────────────────────
                _SettingsCard(ctrl: ctrl),
                const SizedBox(height: 26),

                // ── Audience toggle section ───────────────────────
                _AudienceSection(ctrl: ctrl),
                const SizedBox(height: 26),
              ],
            ),
          ),

          // ── Pinned Upload button ──────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Obx(() => GradientButton(
                    label: 'Upload',
                    onTap: ctrl.onUpload,
                    isLoading: ctrl.isUploading.value,
                    width: double.infinity,
                    height: 54,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POST IMAGE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _PostImageSection extends StatelessWidget {
  const _PostImageSection({required this.ctrl});
  final PostSettingsController ctrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Image preview with rounded top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Obx(() => CachedNetworkImage(
                  imageUrl: ctrl.postImageUrl.value,
                  width: width,
                  height: 190,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: width,
                    height: 190,
                    color: AppColors.surfaceLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: width,
                    height: 190,
                    color: AppColors.surfaceLight,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.textHint,
                    ),
                  ),
                )),
          ),

          // Edit post button — full width, attached below image
          SizedBox(
            width: width,
            height: 40,
            child: ElevatedButton(
              onPressed: ctrl.onEditPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              child: Text(
                'Edit post',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POST SETTING HEADER (title + All pill + Select)
// ─────────────────────────────────────────────────────────────────────────────

class _PostSettingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'POST SETTING',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'All',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Select',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.ctrl});
  final PostSettingsController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.border.withValues(alpha: 0.7),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() => Column(
              children: [
                SettingTile(
                  title: 'Likes & View',
                  value: ctrl.likesView.value,
                ),
                _TileDivider(),
                SettingTile(
                  title: 'Hide like & views control',
                  subtitle: 'Manage your likes and view on your post',
                  value: ctrl.hideLikesCount.value,
                ),
                _TileDivider(),
                SettingTile(
                  title: 'Allow comments from',
                  value: ctrl.allowComments.value,
                ),
                _TileDivider(),
                SettingTile(
                  title: 'Post Sharing',
                  value: ctrl.postSharing.value,
                ),
              ],
            )),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AUDIENCE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _AudienceSection extends StatelessWidget {
  const _AudienceSection({required this.ctrl});
  final PostSettingsController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'Allow Like And View from',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border.withValues(alpha: 0.7),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() {
              final selected = ctrl.selectedAudience.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleTile(
                    title: 'Everyone',
                    isSelected: selected == AudienceType.everyone,
                    onTap: () => ctrl.setAudience(AudienceType.everyone),
                  ),
                  _TileDivider(),
                  ToggleTile(
                    title: 'Your Followers',
                    subtitle: '53 people',
                    isSelected: selected == AudienceType.followers,
                    onTap: () => ctrl.setAudience(AudienceType.followers),
                  ),
                  _TileDivider(),
                  ToggleTile(
                    title: 'No One Except Specific Profiles',
                    isSelected: selected == AudienceType.noOne,
                    onTap: () => ctrl.setAudience(AudienceType.noOne),
                  ),

                  // Search bar shown when noOne is selected
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: selected == AudienceType.noOne
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TileDivider(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: Text(
                                  'No One Except Specific Profiles',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                              _SearchBar(ctrl: ctrl),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.ctrl});
  final PostSettingsController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: TextField(
        onChanged: ctrl.updateSearch,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textHint,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED DIVIDER
// ─────────────────────────────────────────────────────────────────────────────

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF3EEF8),
    );
  }
}
