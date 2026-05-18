import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryEditorController extends GetxController {
  // Story text
  final storyText = 'Lorem ipsum'.obs;
  final textController = TextEditingController(text: 'Lorem ipsum');

  // Color picker state
  final activePickerTab = 0.obs; // 0 = Color, 1 = Image

  // Selected hue (0–360)
  final hue = 0.0.obs;

  // Saturation & value for the 2D spectrum (0–1)
  final saturation = 1.0.obs;
  final brightness = 0.7.obs;

  // Opacity (0–1)
  final opacity = 1.0.obs;

  // Preset swatches
  final swatches = const [
    Color(0xFFFF5A5A),
    Color(0xFFFF9F43),
    Color(0xFF55EFC4),
    Color(0xFFA29BFE),
    Color(0xFFFD79A8),
  ];

  final selectedSwatchIndex = 0.obs;

  // Background gradient for Screen 2
  static const rainbowGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFFD93D),
      Color(0xFF6BCB77),
      Color(0xFF845EC2),
      Color(0xFFFF9EBC),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  Color get currentColor => HSVColor.fromAHSV(
        opacity.value,
        hue.value,
        saturation.value,
        brightness.value,
      ).toColor();

  String get hexString {
    final c = currentColor;
    return '${c.red.toRadixString(16).padLeft(2, '0')}'
            '${c.green.toRadixString(16).padLeft(2, '0')}'
            '${c.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  String get opacityPercent => '${(opacity.value * 100).round()}%';

  void setHue(double value) => hue.value = value.clamp(0.0, 360.0);

  void setSaturationBrightness(double s, double v) {
    saturation.value = s.clamp(0.0, 1.0);
    brightness.value = v.clamp(0.0, 1.0);
  }

  void setOpacity(double value) => opacity.value = value.clamp(0.0, 1.0);

  void selectSwatch(int index) {
    selectedSwatchIndex.value = index;
    final hsv = HSVColor.fromColor(swatches[index]);
    hue.value = hsv.hue;
    saturation.value = hsv.saturation;
    brightness.value = hsv.value;
  }

  void setTab(int index) => activePickerTab.value = index;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
