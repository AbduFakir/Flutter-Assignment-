import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const background = Color(0xFFF0EFFA);
  static const primary = Color(0xFF4A32E8);
  static const textColor = Color(0xFF252B3A);
  static const muted = Color(0xFF8D8A9D);
  static const cardBg = Colors.white;
  static const green = Color(0xFF2ECC71);
  static const orange = Color(0xFFFF6B35);
  static const gold = Color(0xFFF4A340);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width < 360 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(hPad),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
                child: Column(
                  children: [
                    _avatarCard(),
                    const SizedBox(height: 20),
                    Obx(() => _statsRow(controller)),
                    const SizedBox(height: 24),
                    _sectionLabel('Account'),
                    const SizedBox(height: 10),
                    _menuCard([
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        iconColor: primary,
                        label: 'Edit Profile',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none_rounded,
                        iconColor: const Color(0xFFFF6B35),
                        label: 'Notifications',
                        trailing: _toggleBadge('On'),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        iconColor: gold,
                        label: 'Change Password',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _sectionLabel('Preferences'),
                    const SizedBox(height: 10),
                    _menuCard([
                      _MenuItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF7C5CBF),
                        label: 'Dark Mode',
                        trailing: _toggleBadge('Off'),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.language_rounded,
                        iconColor: primary,
                        label: 'Language',
                        trailing: _valueBadge('English'),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.color_lens_outlined,
                        iconColor: green,
                        label: 'Theme',
                        trailing: _valueBadge('Purple'),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _sectionLabel('Support'),
                    const SizedBox(height: 10),
                    _menuCard([
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        iconColor: primary,
                        label: 'Help & FAQ',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: muted,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        iconColor: muted,
                        label: 'About TaskFlow',
                        trailing: _valueBadge('v1.0.0'),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _logoutButton(),
                    const SizedBox(height: 12),
                    const Text(
                      '© 2024 TaskFlow Productivity Suite',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
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

  // ── Top bar ─────────────────────────────────────────────────────────────────

  Widget _topBar(double hPad) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 14),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => AuthService().signOut(),
            child: const Icon(Icons.logout_rounded, color: primary, size: 22),
          ),
        ],
      ),
    );
  }

  // ── Avatar card ─────────────────────────────────────────────────────────────

  Widget _avatarCard() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.edit_rounded, color: primary, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'Pro Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ───────────────────────────────────────────────────────────────

  Widget _statsRow(HomeController controller) {
    return Row(
      children: [
        _statCard(
          icon: Icons.task_alt_rounded,
          iconColor: primary,
          value: '${controller.totalTasks}',
          label: 'Total Tasks',
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.check_circle_outline_rounded,
          iconColor: green,
          value: '${controller.doneTasks}',
          label: 'Completed',
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: orange,
          value: '${controller.streak.value}',
          label: 'Day Streak',
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6656BA).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section label ───────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ── Menu card ───────────────────────────────────────────────────────────────

  Widget _menuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6656BA).withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return _menuRow(e.value, isLast);
        }).toList(),
      ),
    );
  }

  Widget _menuRow(_MenuItem item, bool isLast) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (item.trailing != null) ...[
                  item.trailing!,
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.chevron_right_rounded, color: muted, size: 18),
              ],
            ),
          ),
          if (!isLast)
            const Divider(
              height: 1,
              indent: 64,
              endIndent: 16,
              color: Color(0xFFF0EEF8),
            ),
        ],
      ),
    );
  }

  // ── Trailing widgets ────────────────────────────────────────────────────────

  Widget _toggleBadge(String state) {
    final isOn = state == 'On';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOn ? green.withValues(alpha: 0.12) : const Color(0xFFEEECF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        state,
        style: TextStyle(
          color: isOn ? green : muted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _valueBadge(String value) {
    return Text(
      value,
      style: const TextStyle(
        color: muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ── Logout button ───────────────────────────────────────────────────────────

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () => AuthService().signOut(),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE53935),
          side: const BorderSide(color: Color(0xFFFFDAD9), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ── Menu item data class ─────────────────────────────────────────────────────

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
}
