import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/upload_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UploadController>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // "Update Post" title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    child: Text(
                      'Update Post',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                // Category tabs
                SliverToBoxAdapter(
                  child: _CategoryTabs(ctrl: ctrl),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Image grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ImageGrid(ctrl: ctrl),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
      // Confirm FAB when something is selected
      floatingActionButton: Obx(() {
        if (ctrl.selectedGridIndex.value == null)
          return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton.extended(
            onPressed: ctrl.confirmSelection,
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.check_rounded, color: Colors.white),
            label: Text(
              'Next',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY TABS
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.ctrl});
  final UploadController ctrl;

  static const _tabs = [
    (label: 'Text', tab: GalleryTab.text),
    (label: 'v-Magz', tab: GalleryTab.vMagz),
    (label: 'Gallery', tab: GalleryTab.gallery),
    (label: 'Camera', tab: GalleryTab.camera),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final item = _tabs[i];
          return Obx(() {
            final isActive = ctrl.activeTab.value == item.tab;
            return GestureDetector(
              onTap: () => ctrl.setTab(item.tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFD8A8D8)
                      : const Color(0xFFF0E4F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppColors.primaryDark : AppColors.primary,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE GRID  (MasonryGridView — staggered Pinterest style)
// ─────────────────────────────────────────────────────────────────────────────

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.ctrl});
  final UploadController ctrl;

  @override
  Widget build(BuildContext context) {
    final images = ctrl.galleryImages;
    final totalItems = images.length + 1; // +1 for the "+" tile at index 2

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1, // perfect squares
      ),
      itemCount: totalItems,
      itemBuilder: (_, i) {
        if (i == 2) return const _AddMoreTile();

        final imgIndex = i < 2 ? i : i - 1;
        if (imgIndex >= images.length) return const SizedBox.shrink();

        return Obx(() {
          final isSelected = ctrl.selectedGridIndex.value == imgIndex;
          return _GridImageTile(
            imageUrl: images[imgIndex],
            isSelected: isSelected,
            onTap: () => ctrl.selectGridImage(imgIndex),
          );
        });
      },
    );
  }
}

class _GridImageTile extends StatelessWidget {
  const _GridImageTile({
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: AppColors.accentCyan, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 4 : 6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.surfaceLight,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(Icons.image_outlined,
                      color: AppColors.textHint),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.accentCyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: const Center(
        child:
            Icon(Icons.add_rounded, color: AppColors.textSecondary, size: 32),
      ),
    );
  }
}
