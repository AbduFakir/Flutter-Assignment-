import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssetIcon extends StatelessWidget {
  const SvgAssetIcon({
    required this.assetPath,
    required this.fallbackIcon,
    this.size = 24,
    this.color,
    super.key,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      placeholderBuilder: (_) => SizedBox.square(
        dimension: size,
        child: Icon(fallbackIcon, size: size, color: color),
      ),
    );
  }
}
