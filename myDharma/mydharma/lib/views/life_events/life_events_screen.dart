import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/life_events_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatters.dart';
import '../../models/life_event.dart';
import '../event_details/event_details_screen.dart';

class LifeEventsScreen extends StatefulWidget {
  const LifeEventsScreen({
    this.controller = const LifeEventsController(),
    super.key,
  });

  final LifeEventsController controller;

  @override
  State<LifeEventsScreen> createState() => _LifeEventsScreenState();
}

class _LifeEventsScreenState extends State<LifeEventsScreen> {
  int _selectedCategory = 0;

  static const _categories = ['All', 'Birth', 'Marriage', 'Home', 'Wellness'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Life Events',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Thoughtfully arranged rituals for meaningful family moments.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 18.h),
                // Category filter
                SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final selected = _selectedCategory == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryText
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryText
                                  : AppColors.line,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppColors.muted,
                                fontSize: 12.sp,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Recommended for You',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 100.h),
          sliver: SliverList.separated(
            itemCount: widget.controller.events.length,
            separatorBuilder: (_, _) => SizedBox(height: 14.h),
            itemBuilder: (context, index) {
              final event = widget.controller.events[index];
              return OpenContainer(
                closedElevation: 0,
                openElevation: 0,
                closedColor: Colors.transparent,
                openColor: AppColors.cream,
                transitionDuration: const Duration(milliseconds: 400),
                closedBuilder: (_, open) =>
                    _LifeEventCard(event: event, onTap: open),
                openBuilder: (_, _) => EventDetailsScreen(event: event),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LifeEventCard extends StatelessWidget {
  const _LifeEventCard({required this.event, required this.onTap});

  final LifeEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: .06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header
            Container(
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: event.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(13.r)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10.w,
                    top: -10.h,
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            event.icon,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                event.subtitle,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white70,
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details row
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: DateFormatters.shortMonthDay.format(event.date),
                      ),
                      SizedBox(width: 8.w),
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: event.duration,
                      ),
                      const Spacer(),
                      Text(
                        event.price,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Inclusions',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  for (final item in event.inclusions)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        children: [
                          Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.accentSoft.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: AppColors.primaryText),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
