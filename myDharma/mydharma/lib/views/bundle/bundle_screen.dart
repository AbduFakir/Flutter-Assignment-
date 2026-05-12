import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/bundle_controller.dart';
import '../../core/theme/app_colors.dart';

class BundleScreen extends StatelessWidget {
  const BundleScreen({this.controller = const BundleController(), super.key});

  final BundleController controller;

  static const _bundleDetails = [
    _BundleData(
      title: 'Wedding Rituals',
      subtitle: 'Complete sacred union ceremonies',
      description:
          'Saptapadi, Kanyadaan, Mangalsutra & more — guided step by step.',
      ritualCount: 7,
      duration: '3–4 hrs',
      price: '₹8,999',
      iconAsset: 'assets/home/marriage.png',
      gradientColors: [Color(0xFF6E2453), Color(0xFFB05B72)],
    ),
    _BundleData(
      title: 'New Home Bundle',
      subtitle: 'Bless your new dwelling',
      description:
          'Griha Pravesh, Vastu Puja, and Navagraha Shanti for a blessed start.',
      ritualCount: 4,
      duration: '2 hrs',
      price: '₹5,499',
      iconAsset: 'assets/home/parenting.png',
      gradientColors: [Color(0xFF7A531A), Color(0xFFD8AD49)],
    ),
    _BundleData(
      title: 'Baby Milestones',
      subtitle: 'From birth to first year',
      description:
          'Naamkaran, Annaprashana, Mundan — every sacred first, guided.',
      ritualCount: 5,
      duration: '1–2 hrs each',
      price: '₹6,299',
      iconAsset: 'assets/home/baby.png',
      gradientColors: [Color(0xFF4C5878), Color(0xFFA7B2D7)],
    ),
    _BundleData(
      title: 'Wellness & Peace',
      subtitle: 'Healing and harmony rituals',
      description: 'Satyanarayan Katha, Rudrabhishek, and Mrityunjaya Homa.',
      ritualCount: 3,
      duration: '1.5 hrs',
      price: '₹3,999',
      iconAsset: 'assets/home/parenting.png',
      gradientColors: [Color(0xFF2C6E49), Color(0xFF74C69D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 100.h),
          sliver: SliverList.list(
            children: [
              Text(
                'Ritual Bundles',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 4.h),
              Text(
                'Curated ceremony sets with preparation, reminders, and guidance.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.h),
              // Featured banner
              _FeaturedBanner(context),
              SizedBox(height: 22.h),
              Text(
                'All Bundles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 14.h),
              for (final bundle in _bundleDetails) ...[
                _BundleCard(context, bundle: bundle),
                SizedBox(height: 14.h),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _FeaturedBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: .25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Wedding Rituals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '7 sacred ceremonies, fully guided',
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Explore Bundle',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Image.asset(
            'assets/home/marriage.png',
            width: 90.w,
            height: 90.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _BundleCard(BuildContext context, {required _BundleData bundle}) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon box with gradient
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: bundle.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Image.asset(
                    bundle.iconAsset,
                    fit: BoxFit.contain,
                    color: Colors.white.withValues(alpha: .9),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        bundle.subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        bundle.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          _Tag('${bundle.ritualCount} rituals'),
                          SizedBox(width: 8.w),
                          _Tag(bundle.duration),
                          const Spacer(),
                          Text(
                            bundle.price,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Tag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.accentSoft.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BundleData {
  const _BundleData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ritualCount,
    required this.duration,
    required this.price,
    required this.iconAsset,
    required this.gradientColors,
  });

  final String title;
  final String subtitle;
  final String description;
  final int ritualCount;
  final String duration;
  final String price;
  final String iconAsset;
  final List<Color> gradientColors;
}
