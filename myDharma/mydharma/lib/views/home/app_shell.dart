import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/navigation_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/textured_background.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../bundle/bundle_screen.dart';
import '../calendar/calendar_screen.dart';
import '../life_events/life_events_screen.dart';
import 'home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({this.initialIndex = 0, super.key});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final _navigationController = NavigationController(
    initialIndex: widget.initialIndex,
  );

  static const _screens = [
    HomeScreen(),
    CalendarScreen(),
    BundleScreen(),
    LifeEventsScreen(),
  ];

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const _TodayAppBar(),
        floatingActionButton: const _AiChatFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          top: false,
          bottom: false,
          child: AnimatedBuilder(
            animation: _navigationController,
            builder: (context, _) {
              return Stack(
                children: [
                  if (_navigationController.index == 0)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Image.asset(
                          'assets/home/feather.png',
                          width: 134.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  IndexedStack(
                    index: _navigationController.index,
                    children: _screens,
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: _navigationController,
          builder: (context, _) => _MaroonBottomNav(
            selectedIndex: _navigationController.index,
            onSelected: _navigationController.select,
          ),
        ),
      ),
    );
  }
}

class _TodayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TodayAppBar();

  @override
  Size get preferredSize => Size.fromHeight(42.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 42.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: .8,
      shadowColor: Colors.black.withValues(alpha: .25),
      titleSpacing: 10.w,
      title: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/applogo.png',
              width: 28.w,
              height: 28.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'myDharma',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            'Hyderabad',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontSize: 11.sp,
              height: 1,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 17.sp,
            color: Colors.black87,
          ),
          SizedBox(width: 12.w),
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.2),
            ),
            child: Icon(
              Icons.menu_rounded,
              color: AppColors.primaryText,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaroonBottomNav extends StatelessWidget {
  const _MaroonBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    _NavItem('Today', 'assets/home/navToday.png'),
    _NavItem('Calendar', 'assets/home/navCalendar.png'),
    _NavItem('My Bundle', 'assets/home/navBundles.png'),
    _NavItem('Life Events', 'assets/home/navLifeEvents.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.primaryText),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              for (final entry in _items.indexed)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(entry.$1),
                    child: _BottomNavButton(
                      item: entry.$2,
                      selected: selectedIndex == entry.$1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : Colors.white;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageIcon(AssetImage(item.asset), color: color, size: 22.sp),
        SizedBox(height: 3.h),
        Text(
          item.label,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontSize: 10.sp,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.asset);

  final String label;
  final String asset;
}

class _AiChatFab extends StatelessWidget {
  const _AiChatFab();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AiChatScreen.routeName),
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [AppColors.plum, AppColors.primaryDark],
            radius: 0.85,
          ),
          border: Border.all(color: AppColors.accent, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryText.withValues(alpha: .45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // AI image as background
              Positioned.fill(
                child: Image.asset(
                  'assets/ai_logo.png',
                  fit: BoxFit.cover,
                  color: Colors.white.withValues(alpha: .18),
                  colorBlendMode: BlendMode.srcATop,
                ),
              ),
              // Foreground icon + label
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ai_logo.png',
                    width: 26.w,
                    height: 26.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Ask AI',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: .4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
