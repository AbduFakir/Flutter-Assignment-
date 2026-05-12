import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    required this.child,
    this.padding,
    this.color = AppColors.card,
    this.margin,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSpacing.radiusLg);
    final card = Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.white.withValues(alpha: .7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: .08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: card,
      ),
    );
  }
}
