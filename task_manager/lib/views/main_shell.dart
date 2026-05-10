import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/task_bottom_sheet.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const primary = Color(0xFF4A32E8);

  static const _pages = [HomeScreen(), HistoryScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
      ),
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _fab() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => showAddTaskSheet(context),
        child: Container(
          width: 52,
          height: 52,
          margin: const EdgeInsets.only(bottom: 8, right: 4),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
