import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/story_editor_controller.dart';
import 'text_editor_screen.dart';

class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<StoryEditorController>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen rainbow gradient background
          const GradientBackground(),

          // Top toolbar (same as screen 1)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: EditorToolbar(
              onColorTap: () => Get.back(),
            ),
          ),

          // Floating color picker card — centered
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ColorPickerCard(ctrl: ctrl),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE: GRADIENT BACKGROUND
// ─────────────────────────────────────────────────────────────────────────────

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFFD93D),
            Color(0xFF6BCB77),
            Color(0xFF845EC2),
            Color(0xFFFF9EBC),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FLOATING COLOR PICKER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ColorPickerCard extends StatelessWidget {
  const _ColorPickerCard({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tabs
          _PickerTabs(ctrl: ctrl),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Swatches row
          _SwatchRow(ctrl: ctrl),

          // Hue slider (top rainbow bar with thumb)
          _HueSlider(ctrl: ctrl),

          const SizedBox(height: 8),

          // 2D color spectrum
          _ColorSpectrum(ctrl: ctrl),

          const SizedBox(height: 12),

          // Bottom sliders + info
          _BottomControls(ctrl: ctrl),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TABS: Color / Image
// ─────────────────────────────────────────────────────────────────────────────

class _PickerTabs extends StatelessWidget {
  const _PickerTabs({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(
            children: [
              _Tab(
                label: 'Color',
                isActive: ctrl.activePickerTab.value == 0,
                onTap: () => ctrl.setTab(0),
              ),
              const SizedBox(width: 24),
              _Tab(
                label: 'Image',
                isActive: ctrl.activePickerTab.value == 1,
                onTap: () => ctrl.setTab(1),
              ),
            ],
          ),
        ));
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          color: isActive ? const Color(0xFF1A1A1A) : const Color(0xFFAAAAAA),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE: COLOR SWATCH
// ─────────────────────────────────────────────────────────────────────────────

class ColorSwatch extends StatelessWidget {
  const ColorSwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.white,
            width: isSelected ? 2.5 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.35),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
      ),
    );
  }
}

class _SwatchRow extends StatelessWidget {
  const _SwatchRow({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Row(
            children: List.generate(ctrl.swatches.length, (i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < ctrl.swatches.length - 1 ? 10 : 0),
                child: ColorSwatch(
                  color: ctrl.swatches[i],
                  isSelected: ctrl.selectedSwatchIndex.value == i,
                  onTap: () => ctrl.selectSwatch(i),
                ),
              );
            }),
          ),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE: HUE SLIDER
// ─────────────────────────────────────────────────────────────────────────────

class _HueSlider extends StatelessWidget {
  const _HueSlider({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        children: [
          // Rainbow bar with draggable thumb
          Obx(() => ColorSlider(
                value: ctrl.hue.value / 360.0,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFF7F00),
                    Color(0xFFFFFF00),
                    Color(0xFF00FF00),
                    Color(0xFF0000FF),
                    Color(0xFF8B00FF),
                    Color(0xFFFF00FF),
                    Color(0xFFFF0000),
                  ],
                ),
                thumbColor: Colors.white,
                onChanged: (v) => ctrl.setHue(v * 360),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE: COLOR SLIDER (rainbow / opacity)
// ─────────────────────────────────────────────────────────────────────────────

class ColorSlider extends StatelessWidget {
  const ColorSlider({
    super.key,
    required this.value,
    required this.gradient,
    required this.onChanged,
    this.thumbColor = Colors.white,
    this.height = 14,
  });

  final double value;
  final LinearGradient gradient;
  final ValueChanged<double> onChanged;
  final Color thumbColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final trackWidth = constraints.maxWidth;
      final thumbX = value.clamp(0.0, 1.0) * trackWidth;

      return GestureDetector(
        onHorizontalDragUpdate: (d) {
          final newVal = (d.localPosition.dx / trackWidth).clamp(0.0, 1.0);
          onChanged(newVal);
        },
        onTapDown: (d) {
          final newVal = (d.localPosition.dx / trackWidth).clamp(0.0, 1.0);
          onChanged(newVal);
        },
        child: SizedBox(
          height: height + 12,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Track
              Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Thumb
              Positioned(
                left: (thumbX - 10).clamp(0, trackWidth - 20),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2D COLOR SPECTRUM
// ─────────────────────────────────────────────────────────────────────────────

class _ColorSpectrum extends StatelessWidget {
  const _ColorSpectrum({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final hueColor = HSVColor.fromAHSV(1, ctrl.hue.value, 1, 1).toColor();
        final s = ctrl.saturation.value;
        final v = ctrl.brightness.value;

        return LayoutBuilder(builder: (context, constraints) {
          final w = constraints.maxWidth;
          const h = 180.0;

          return GestureDetector(
            onPanUpdate: (d) {
              final newS = (d.localPosition.dx / w).clamp(0.0, 1.0);
              final newV = (1 - d.localPosition.dy / h).clamp(0.0, 1.0);
              ctrl.setSaturationBrightness(newS, newV);
            },
            onTapDown: (d) {
              final newS = (d.localPosition.dx / w).clamp(0.0, 1.0);
              final newV = (1 - d.localPosition.dy / h).clamp(0.0, 1.0);
              ctrl.setSaturationBrightness(newS, newV);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: w,
                height: h,
                child: Stack(
                  children: [
                    // Base hue
                    Container(color: hueColor),
                    // White → transparent (left to right)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.transparent],
                        ),
                      ),
                    ),
                    // Transparent → black (top to bottom)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Circular selector
                    Positioned(
                      left: (s * w - 10).clamp(0, w - 20),
                      top: ((1 - v) * h - 10).clamp(0, h - 20),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ctrl.currentColor,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM CONTROLS: opacity slider + hex info
// ─────────────────────────────────────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.ctrl});
  final StoryEditorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Eyedropper + rainbow hue slider row
          Row(
            children: [
              const Icon(Icons.colorize_rounded,
                  color: Color(0xFF555555), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => ColorSlider(
                      value: ctrl.hue.value / 360.0,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF0000),
                          Color(0xFFFF7F00),
                          Color(0xFFFFFF00),
                          Color(0xFF00FF00),
                          Color(0xFF0000FF),
                          Color(0xFF8B00FF),
                          Color(0xFFFF00FF),
                          Color(0xFFFF0000),
                        ],
                      ),
                      thumbColor: const Color(0xFFFF5A5A),
                      onChanged: (v) => ctrl.setHue(v * 360),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Opacity slider (checkerboard + color fade)
          Obx(() {
            final baseColor = ctrl.currentColor.withValues(alpha: 1);
            return ColorSlider(
              value: ctrl.opacity.value,
              gradient: LinearGradient(
                colors: [Colors.transparent, baseColor],
              ),
              thumbColor: const Color(0xFFFF5A5A),
              onChanged: ctrl.setOpacity,
            );
          }),

          const SizedBox(height: 14),

          // Hex + opacity info row
          Obx(() => Row(
                children: [
                  // Hex label with dropdown arrow
                  Row(
                    children: [
                      Text(
                        'Hex',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: Color(0xFF555555)),
                    ],
                  ),
                  const Spacer(),
                  // Hex value
                  Text(
                    ctrl.hexString,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  // Opacity %
                  Text(
                    ctrl.opacityPercent,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
