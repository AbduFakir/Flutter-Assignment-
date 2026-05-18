import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/user_avatar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final box = GetStorage();

    final isDark = (box.read<bool>(AppConstants.keyDarkMode) ?? true).obs;
    final notifs = (box.read<bool>(AppConstants.keyNotifications) ?? true).obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            _ProfileHeader(storage: storage),
            const SizedBox(height: 8),

            // Appearance
            _SectionTitle(title: 'Appearance'),
            Obx(() => _ToggleTile(
                  icon: Icons.dark_mode_rounded,
                  iconColor: const Color(0xFF9D97FF),
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  value: isDark.value,
                  onChanged: (v) {
                    isDark.value = v;
                    storage.setDarkMode(v);
                  },
                )),

            // Notifications
            _SectionTitle(title: 'Notifications'),
            Obx(() => _ToggleTile(
                  icon: Icons.notifications_rounded,
                  iconColor: const Color(0xFFFF6584),
                  title: 'Push Notifications',
                  subtitle: 'Receive activity alerts',
                  value: notifs.value,
                  onChanged: (v) {
                    notifs.value = v;
                    storage.setNotifications(v);
                  },
                )),

            // Account
            _SectionTitle(title: 'Account'),
            _NavTile(
              icon: Icons.person_outline_rounded,
              iconColor: const Color(0xFF43C6AC),
              title: 'Edit Profile',
              onTap: () => _showEditProfile(context, storage),
            ),
            _NavTile(
              icon: Icons.lock_outline_rounded,
              iconColor: const Color(0xFFFFB74D),
              title: 'Privacy',
              onTap: () {},
            ),
            _NavTile(
              icon: Icons.help_outline_rounded,
              iconColor: AppColors.primary,
              title: 'Help & Support',
              onTap: () {},
            ),

            // Danger zone
            _SectionTitle(title: 'Data'),
            _NavTile(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              title: 'Clear All Data',
              titleColor: AppColors.error,
              onTap: () => _confirmClear(context, storage),
            ),

            const SizedBox(height: 40),
            const Text(
              'Fameo X  ·  v1.0.0',
              style: TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, StorageService storage) {
    final nameCtrl = TextEditingController(text: storage.userName);
    final handleCtrl = TextEditingController(text: storage.userHandle);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Display Name',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Handle',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                prefixText: '@',
                prefixStyle: TextStyle(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  storage.saveUserName(nameCtrl.text.trim());
                  storage.saveUserHandle(
                      '@${handleCtrl.text.replaceAll('@', '').trim()}');
                  Navigator.pop(context);
                  Get.snackbar('Saved', 'Profile updated.',
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, StorageService storage) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Data',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will delete all posts and settings. This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              storage.clearAll();
              Navigator.pop(context);
              Get.back();
              Get.snackbar('Done', 'All data cleared.',
                  snackPosition: SnackPosition.BOTTOM);
            },
            child:
                const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ── Profile Header ────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.storage});
  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          UserAvatar(
            imageUrl: storage.userAvatar ?? '',
            radius: 30,
            hasStory: false,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storage.userName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  storage.userHandle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textHint,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Toggle Tile ───────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }
}

// ── Nav Tile ──────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textHint, size: 20),
      ),
    );
  }
}
