import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppSpacing {
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 40.w;

  static double get radiusSm => 12.r;
  static double get radiusMd => 18.r;
  static double get radiusLg => 26.r;
}
