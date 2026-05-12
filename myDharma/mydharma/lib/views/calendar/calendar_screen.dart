import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/calendar_controller.dart';
import '../../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    this.controller = const CalendarController(),
    super.key,
  });

  final CalendarController controller;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime(2026, 5);
  int? _selectedDay;

  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Auspicious days for the month (mock)
  static const _auspiciousDays = {5, 10, 14, 18, 22, 27};
  static const _observanceDays = {3, 14, 22, 29};

  int get _daysInMonth =>
      DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);

  int get _firstWeekday =>
      DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

  String get _monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  void _prevMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    _selectedDay = null;
  });

  void _nextMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    _selectedDay = null;
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 100.h),
          sliver: SliverList.list(
            children: [
              _ScreenTitle(context),
              SizedBox(height: 18.h),
              _CalendarCard(context),
              SizedBox(height: 20.h),
              _SectionLabel('Upcoming Observances'),
              SizedBox(height: 12.h),
              ...widget.controller.observances.indexed.map(
                (entry) => _ObservanceTile(
                  context,
                  day: 14 + entry.$1,
                  label: entry.$2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ScreenTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dharma Calendar',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 4.h),
        Text(
          'Auspicious days and sacred observances for your family.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _CalendarCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.accent.withValues(alpha: .4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: .07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.primaryText,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _prevMonth,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.accent,
                      size: 22.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _monthLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _nextMonth,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.accent,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Weekday labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Row(
              children: _weekDays
                  .map(
                    (d) => Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .3,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Day grid
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 14.h),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: _firstWeekday + _daysInMonth,
              itemBuilder: (context, index) {
                if (index < _firstWeekday) return const SizedBox();
                final day = index - _firstWeekday + 1;
                final isAuspicious = _auspiciousDays.contains(day);
                final isObservance = _observanceDays.contains(day);
                final isSelected = _selectedDay == day;
                final isToday =
                    day == 12 &&
                    _focusedMonth.month == 5 &&
                    _focusedMonth.year == 2026;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryText
                          : isToday
                          ? AppColors.accent.withValues(alpha: .15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.accent, width: 1.2)
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isAuspicious
                                ? AppColors.primaryText
                                : Colors.black87,
                            fontSize: 13.sp,
                            fontWeight: isAuspicious || isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        if (isObservance && !isSelected)
                          Positioned(
                            bottom: 3.h,
                            child: Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Legend
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            child: Row(
              children: [
                _LegendDot(color: AppColors.primaryText, label: 'Auspicious'),
                SizedBox(width: 16.w),
                _LegendDot(
                  color: AppColors.accent,
                  label: 'Observance',
                  isDot: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _SectionLabel(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _ObservanceTile(
    BuildContext context, {
    required int day,
    required String label,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14.sp),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.muted,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.isDot = false,
  });

  final Color color;
  final String label;
  final bool isDot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: isDot ? 8.w : 14.w,
          height: isDot ? 8.w : 14.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(color: AppColors.muted, fontSize: 11.sp),
        ),
      ],
    );
  }
}
