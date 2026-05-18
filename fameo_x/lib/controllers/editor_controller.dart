import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../controllers/home_controller.dart';
import '../controllers/upload_controller.dart';
import '../services/storage_service.dart';
import '../app/app_pages.dart';

class EditorController extends GetxController {
  final _storage = StorageService();
  final captionController = TextEditingController();
  final tagController = TextEditingController();

  final tags = <String>[].obs;
  final isPosting = false.obs;
  final charCount = 0.obs;

  static const int maxChars = 280;

  @override
  void onInit() {
    super.onInit();
    captionController.addListener(() {
      charCount.value = captionController.text.length;
    });
  }

  @override
  void onClose() {
    captionController.dispose();
    tagController.dispose();
    super.onClose();
  }

  void addTag(String tag) {
    final cleaned = tag.trim().replaceAll('#', '').toLowerCase();
    if (cleaned.isNotEmpty && !tags.contains(cleaned) && tags.length < 10) {
      tags.add(cleaned);
    }
    tagController.clear();
  }

  void removeTag(String tag) => tags.remove(tag);

  Future<void> post() async {
    if (captionController.text.trim().isEmpty) {
      Get.snackbar(
        'Caption required',
        'Please write something before posting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isPosting.value = true;
    await Future.delayed(const Duration(milliseconds: 600)); // simulate upload

    final uploadCtrl = Get.find<UploadController>();
    final homeCtrl = Get.find<HomeController>();

    final newPost = PostModel(
      id: const Uuid().v4(),
      userId: 'me',
      userName: _storage.userName,
      userHandle: _storage.userHandle,
      userAvatar: _storage.userAvatar ?? '',
      imageUrl: uploadCtrl.mediaType.value == MediaType.image
          ? uploadCtrl.selectedFile.value?.path
          : null,
      videoUrl: uploadCtrl.mediaType.value == MediaType.video
          ? uploadCtrl.selectedFile.value?.path
          : null,
      caption: captionController.text.trim(),
      tags: List.from(tags),
      createdAt: DateTime.now(),
    );

    homeCtrl.addPost(newPost);
    uploadCtrl.reset();
    _reset();

    isPosting.value = false;

    Get.until((route) => route.settings.name == Routes.home);
    Get.snackbar(
      'Posted!',
      'Your post is live.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF82),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  void _reset() {
    captionController.clear();
    tagController.clear();
    tags.clear();
    charCount.value = 0;
  }
}
