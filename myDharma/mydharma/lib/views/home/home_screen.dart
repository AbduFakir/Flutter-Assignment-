import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/home_life_event.dart';
import '../event_details/event_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.controller = const HomeController(), super.key});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        const SliverToBoxAdapter(child: _JourneySection()),
        SliverToBoxAdapter(child: SizedBox(height: 22.h)),
        const SliverToBoxAdapter(child: _QuoteSection()),
        SliverToBoxAdapter(child: SizedBox(height: 22.h)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          sliver: SliverList.separated(
            itemCount: controller.todayEvents.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final event = controller.todayEvents[index];
              return _LifeEventTile(
                event: event,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(EventDetailsScreen.routeName, arguments: event),
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 96.h)),
      ],
    );
  }
}

class _JourneySection extends StatelessWidget {
  const _JourneySection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Image.asset(
        'assets/home/topImage.png',
        width: double.infinity,
        height: 400.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(height: 352.h);
        },
      ),
    );
  }
}

class _QuoteSection extends StatelessWidget {
  const _QuoteSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Text(
        '${AppStrings.quoteLineOne}\n${AppStrings.quoteLineTwo}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.primaryText,
          fontSize: 24.sp,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LifeEventTile extends StatelessWidget {
  const _LifeEventTile({required this.event, required this.onTap});

  final HomeLifeEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shadowColor: Colors.black.withValues(alpha: .12),
      elevation: 7,
      borderRadius: BorderRadius.circular(2.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 16.w, 18.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                event.iconAsset,
                width: 33.w,
                height: 33.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 17.sp,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Icon(Icons.arrow_forward, size: 15.sp, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }
}
