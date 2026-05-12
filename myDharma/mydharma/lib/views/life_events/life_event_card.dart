import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/premium_card.dart';
import '../../models/life_event.dart';

class LifeEventCard extends StatelessWidget {
  const LifeEventCard({
    required this.event,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final LifeEvent event;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: EdgeInsets.all(compact ? 14.w : 16.w),
      child: Row(
        children: [
          Container(
            width: compact ? 58.w : 66.w,
            height: compact ? 58.w : 66.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: event.gradient),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(event.icon, color: Colors.white, size: 30.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  event.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _Chip(label: DateFormatters.shortMonthDay.format(event.date)),
                    _Chip(label: event.duration),
                    _Chip(label: event.price, highlighted: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.accent.withValues(alpha: .16)
            : AppColors.creamDeep.withValues(alpha: .52),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 11.sp,
                color: highlighted ? AppColors.primary : AppColors.muted,
              ),
        ),
      ),
    );
  }
}
