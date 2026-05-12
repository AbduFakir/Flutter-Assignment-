import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TexturedBackground extends StatelessWidget {
  const TexturedBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.cream,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 0),
            ],
          ),
        ),
        child: CustomPaint(
          painter: const _TexturePainter(),
          child: child,
        ),
      ),
    );
  }
}

class _TexturePainter extends CustomPainter {
  const _TexturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: .035)
      ..strokeWidth = 1;

    for (var i = 0.0; i < size.height; i += 28) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i + 20), paint);
    }

    final goldPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: .05)
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(Offset(size.width * .86, size.height * .12), 92, goldPaint)
      ..drawCircle(Offset(size.width * .06, size.height * .74), 70, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
