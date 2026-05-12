import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/textured_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _nameController;
  late final AnimationController _taglineController;
  late final AnimationController _shimmerController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _shimmerOpacity;

  @override
  void initState() {
    super.initState();

    // Logo: scale from 0.6 → 1.0 + fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // App name: slide up + fade in
    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _nameOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _nameController, curve: Curves.easeIn));
    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _nameController, curve: Curves.easeOutCubic),
        );

    // Tagline: fade in
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Gold shimmer line
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shimmerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _shimmerController.forward();
    _nameController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Decorative gold circle top-right
            Positioned(
              top: -60.h,
              right: -60.w,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: .08),
                ),
              ),
            ),
            // Decorative gold circle bottom-left
            Positioned(
              bottom: -40.h,
              left: -40.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: .07),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: .35),
                              blurRadius: 32,
                              spreadRadius: 4,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: AppColors.primaryText.withValues(
                                alpha: .12,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: .5),
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.all(18.w),
                        child: Image.asset(
                          'assets/applogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  // Gold shimmer divider
                  FadeTransition(
                    opacity: _shimmerOpacity,
                    child: Container(
                      width: 48.w,
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.accent,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // App name
                  SlideTransition(
                    position: _nameSlide,
                    child: FadeTransition(
                      opacity: _nameOpacity,
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Tagline
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.quoteLineOne,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText.withValues(alpha: .65),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          AppStrings.quoteLineTwo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText.withValues(alpha: .65),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom brand mark
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _taglineOpacity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.w,
                      height: 1,
                      color: AppColors.accent.withValues(alpha: .5),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Guided by Dharma',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 20.w,
                      height: 1,
                      color: AppColors.accent.withValues(alpha: .5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
