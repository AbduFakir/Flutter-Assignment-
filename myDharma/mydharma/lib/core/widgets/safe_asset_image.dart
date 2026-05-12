import 'package:flutter/material.dart';

class SafeAssetImage extends StatelessWidget {
  const SafeAssetImage({
    required this.assetPath,
    required this.fallback,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? assetPath;
  final Widget fallback;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null || path.isEmpty) return fallback;

    return Image.asset(
      path,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 220),
          child: child,
        );
      },
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
