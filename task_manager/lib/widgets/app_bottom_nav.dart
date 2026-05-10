import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

const _primary = Color(0xFF4A32E8);
const _muted = Color(0xFF8D8A9D);

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _items = [
    (icon: Icons.task_alt_rounded, label: 'Tasks'),
    (icon: Icons.history_rounded, label: 'History'),
    (icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final selected = controller.currentIndex.value;

      return Container(
        height: 68,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEECF6), width: 1)),
        ),
        child: Row(
          children: [
            ..._items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isSelected = selected == i;

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEDE9FB)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isSelected ? _primary : _muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? _primary : _muted,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Space reserved for FAB
            const SizedBox(width: 64),
          ],
        ),
      );
    });
  }
}
