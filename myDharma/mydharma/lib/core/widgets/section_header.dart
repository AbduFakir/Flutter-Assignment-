import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.action,
    this.onActionTap,
    super.key,
  });

  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (action != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                action!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
