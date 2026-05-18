import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/editor_controller.dart';
import '../controllers/upload_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/gradient_button.dart';
import '../widgets/tag_chip.dart';
import '../app/app_pages.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadCtrl = Get.find<UploadController>();

    // If a network image was selected from gallery grid → show cinematic editor
    // If a local file was picked → show caption editor
    return Obx(() {
      final hasNetwork = uploadCtrl.selectedNetworkUrl.value != null;
      final hasFile = uploadCtrl.selectedFile.value != null;

      if (hasNetwork) {
        return _CinematicEditorScreen(
            imageUrl: uploadCtrl.selectedNetworkUrl.value!);
      }
      if (hasFile) {
        return _CaptionEditorScreen(file: uploadCtrl.selectedFile.value!);
      }
      return const _CaptionEditorScreen(file: null);
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 2A — CINEMATIC FULLSCREEN EDITOR  (matches reference screenshot 2)
// ─────────────────────────────────────────────────────────────────────────────

class _CinematicEditorScreen extends StatelessWidget {
  const _CinematicEditorScreen({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen image
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            placeholder: (_, __) => Container(color: Colors.black),
            errorWidget: (_, __, ___) => Container(color: Colors.black87),
          ),

          // Top toolbar overlay
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopToolbar(),
          ),

          // Remove button — bottom right, above action bar
          const Positioned(
            bottom: 90,
            right: 16,
            child: _RemoveButton(),
          ),

          // Bottom action controls
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomActionBar(),
          ),
        ],
      ),
    );
  }
}

// ── Top Toolbar ───────────────────────────────────────────────────────────────

class _TopToolbar extends StatelessWidget {
  const _TopToolbar();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Padding(
      padding:
          EdgeInsets.only(top: topPad + 8, left: 16, right: 16, bottom: 12),
      child: Row(
        children: [
          // Left tools
          Row(
            children: [
              _ToolIcon(icon: Icons.more_vert_rounded, onTap: () {}),
              const SizedBox(width: 16),
              // T text label (matching reference)
              GestureDetector(
                onTap: () {},
                child: Text(
                  'T',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    shadows: const [
                      Shadow(color: Colors.black45, blurRadius: 4),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _ToolIcon(icon: Icons.music_note_rounded, onTap: () {}),
            ],
          ),
          const Spacer(),
          // Right — forward arrow circle button
          GestureDetector(
            onTap: () => Get.toNamed(Routes.postSettings),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon,
          color: Colors.white,
          size: 24,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 6)]),
    );
  }
}

// ── Remove Button ─────────────────────────────────────────────────────────────

class _RemoveButton extends StatelessWidget {
  const _RemoveButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Remove',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bottom Action Bar ─────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding:
          EdgeInsets.only(left: 16, right: 16, bottom: bottomPad + 16, top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _GlassActionButton(
              icon: Icons.rotate_left_rounded,
              label: 'Rotate',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _GlassActionButton(
              icon: Icons.crop_rounded,
              label: 'Crop',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _GlassActionButton(
              icon: Icons.tune_rounded,
              label: 'Adjustment',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            // Next / confirm
            GestureDetector(
              onTap: () => Get.toNamed(Routes.postSettings),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Next →',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), // Row
      ), // SingleChildScrollView
    );
  }
}

class _GlassActionButton extends StatelessWidget {
  const _GlassActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 2B — CAPTION EDITOR  (for locally picked files)
// ─────────────────────────────────────────────────────────────────────────────

class _CaptionEditorScreen extends StatelessWidget {
  const _CaptionEditorScreen({required this.file});
  final File? file;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EditorController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Edit Post',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (file != null) _LocalMediaPreview(file: file!),
              const SizedBox(height: 20),
              _FieldLabel(label: 'Caption'),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: ctrl.captionController,
                    maxLines: 4,
                    maxLength: EditorController.maxChars,
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      counterStyle: GoogleFonts.poppins(
                          color: AppColors.textHint, fontSize: 12),
                      counterText:
                          '${ctrl.charCount.value}/${EditorController.maxChars}',
                    ),
                  )),
              const SizedBox(height: 20),
              _FieldLabel(label: 'Tags'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl.tagController,
                      style: GoogleFonts.poppins(
                          color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Add a tag...',
                        prefixText: '# ',
                        prefixStyle: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      onSubmitted: ctrl.addTag,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => ctrl.addTag(ctrl.tagController.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: AppColors.primary, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => ctrl.tags.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ctrl.tags
                          .map((t) => TagChip(
                                label: t,
                                onRemove: () => ctrl.removeTag(t),
                              ))
                          .toList(),
                    )),
              const SizedBox(height: 32),
              Obx(() => GradientButton(
                    label: 'Share Post',
                    icon: Icons.send_rounded,
                    isLoading: ctrl.isPosting.value,
                    width: double.infinity,
                    onTap: ctrl.post,
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalMediaPreview extends StatelessWidget {
  const _LocalMediaPreview({required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceLight,
            child: const Center(
              child: Icon(Icons.broken_image_outlined,
                  color: AppColors.textHint, size: 48),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
