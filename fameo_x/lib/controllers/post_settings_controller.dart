import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/upload_controller.dart';

enum AudienceType { everyone, followers, noOne }

class PostSettingsController extends GetxController {
  // Post image — synced from UploadController on init
  final postImageUrl =
      'https://picsum.photos/seed/aerialpost/800/500'.obs;

  @override
  void onInit() {
    super.onInit();
    // Pull the image chosen in the Upload/Editor screen
    try {
      final uploadCtrl = Get.find<UploadController>();
      if (uploadCtrl.selectedNetworkUrl.value != null) {
        postImageUrl.value = uploadCtrl.selectedNetworkUrl.value!;
      }
    } catch (_) {
      // UploadController not yet registered — keep default preview
    }
  }

  // Description
  final description =
      'Lorem ipsum dolor sit amet consectetur. Nulla ac tortor vitae ac gravida tempus. Mi integer duis sit amet et.'
          .obs;
  final currentCount = 1.obs;
  final maxCount = 32;

  // Post settings
  final likesView = 'Everyone'.obs;
  final hideLikesCount = '0 people'.obs;
  final allowComments = 'Everyone'.obs;
  final postSharing = 'Everyone'.obs;

  // Audience toggle
  final selectedAudience = AudienceType.everyone.obs;

  // Search
  final searchQuery = ''.obs;

  // Upload state
  final isUploading = false.obs;

  void setAudience(AudienceType type) => selectedAudience.value = type;

  void updateSearch(String val) => searchQuery.value = val;

  void onEditPost() => Get.back();

  Future<void> onUpload() async {
    isUploading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isUploading.value = false;
    Get.snackbar(
      '🎉 Uploaded!',
      'Your post has been published successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB455A0),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
