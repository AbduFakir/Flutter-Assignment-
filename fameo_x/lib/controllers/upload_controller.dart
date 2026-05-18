import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../app/app_pages.dart';

enum MediaType { none, image, video }

enum GalleryTab { text, vMagz, gallery, camera }

class UploadController extends GetxController {
  final _picker = ImagePicker();

  final selectedFile = Rxn<File>();
  final selectedNetworkUrl = RxnString();
  final mediaType = MediaType.none.obs;
  final isLoading = false.obs;
  final activeTab = GalleryTab.gallery.obs;
  final selectedGridIndex = RxnInt();

  // Mock gallery images (network URLs for demo)
  final galleryImages = <String>[
    'https://picsum.photos/seed/g1/400/500',
    'https://picsum.photos/seed/g2/400/400',
    'https://picsum.photos/seed/g3/400/600',
    'https://picsum.photos/seed/g4/400/400',
    'https://picsum.photos/seed/g5/400/500',
    'https://picsum.photos/seed/g6/400/400',
    'https://picsum.photos/seed/g7/400/600',
    'https://picsum.photos/seed/g8/400/400',
    'https://picsum.photos/seed/g9/400/500',
    'https://picsum.photos/seed/g10/400/400',
    'https://picsum.photos/seed/g11/400/600',
    'https://picsum.photos/seed/g12/400/400',
  ].obs;

  void setTab(GalleryTab tab) => activeTab.value = tab;

  void selectGridImage(int index) {
    selectedGridIndex.value = index;
    selectedNetworkUrl.value = galleryImages[index];
    mediaType.value = MediaType.image;
  }

  void confirmSelection() {
    if (selectedNetworkUrl.value != null) {
      Get.toNamed(Routes.editor);
    }
  }

  Future<void> pickFromGallery() async {
    try {
      isLoading.value = true;
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        selectedFile.value = File(picked.path);
        selectedNetworkUrl.value = null;
        mediaType.value = MediaType.image;
        Get.toNamed(Routes.editor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFromCamera() async {
    try {
      isLoading.value = true;
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        selectedFile.value = File(picked.path);
        selectedNetworkUrl.value = null;
        mediaType.value = MediaType.image;
        Get.toNamed(Routes.editor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open camera: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickVideo() async {
    try {
      isLoading.value = true;
      final picked = await _picker.pickVideo(source: ImageSource.gallery);
      if (picked != null) {
        selectedFile.value = File(picked.path);
        selectedNetworkUrl.value = null;
        mediaType.value = MediaType.video;
        Get.toNamed(Routes.editor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick video: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    selectedFile.value = null;
    selectedNetworkUrl.value = null;
    mediaType.value = MediaType.none;
    selectedGridIndex.value = null;
  }
}
