import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/story_editor_controller.dart';
import '../app/app_pages.dart';

class TextEditorScreen extends StatelessWidget {
  const TextEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<StoryEditorController>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Center story text
          Center(
            child: Obx(() => Text(
                  ctrl.storyText.value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                )),
          ),

          // Top toolbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: EditorToolbar(
              onColorTap: () => Get.toNamed(Routes.colorPicker),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE EDITOR TOOLBAR  (shared by both screens)
// ─────────────────────────────────────────────────────────────────────────────

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    this.onColorTap,
    this.onTextTap,
    this.onMusicTap,
    this.onSendTap,
  });

  final VoidCallback? onColorTap;
  final VoidCallback? onTextTap;
  final VoidCallback? onMusicTap;
  final VoidCallback? onSendTap;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Padding(
      padding:
          EdgeInsets.only(top: topPad + 10, left: 20, right: 20, bottom: 12),
      child: Row(
        children: [
          // Left tools
          _ToolBtn(
            child: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 22),
            onTap: () {},
          ),
          const SizedBox(width: 18),
          _ToolBtn(
            child: Text(
              'T',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: onTextTap ?? () {},
          ),
          const SizedBox(width: 18),
          // Rainbow color picker circle
          _ToolBtn(
            child: const _RainbowCircle(size: 24),
            onTap: onColorTap ?? () {},
          ),
          const SizedBox(width: 18),
          _ToolBtn(
            child: const Icon(Icons.music_note_rounded,
                color: Colors.white, size: 22),
            onTap: onMusicTap ?? () {},
          ),
          const Spacer(),
          // Right — send/arrow
          _ToolBtn(
            child: const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 24),
            onTap: onSendTap ?? () => Get.back(),
          ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  const _ToolBtn({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }
}

// Rainbow gradient circle icon
class _RainbowCircle extends StatelessWidget {
  const _RainbowCircle({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFFFF0000),
            Color(0xFFFFFF00),
            Color(0xFF00FF00),
            Color(0xFF00FFFF),
            Color(0xFF0000FF),
            Color(0xFFFF00FF),
            Color(0xFFFF0000),
          ],
        ),
      ),
    );
  }
}
