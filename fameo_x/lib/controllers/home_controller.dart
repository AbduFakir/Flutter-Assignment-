import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/storage_service.dart';
import '../utils/mock_data.dart';

class HomeController extends GetxController {
  final _storage = StorageService();

  final posts = <PostModel>[].obs;
  final isLoading = false.obs;
  final currentNavIndex = 0.obs;

  // Stories
  final stories = MockData.stories.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPosts();
  }

  void _loadPosts() {
    isLoading.value = true;
    final stored = _storage.getPosts();
    if (stored.isEmpty) {
      // Seed with mock data on first launch
      posts.assignAll(MockData.samplePosts);
      _storage.savePosts(MockData.samplePosts);
    } else {
      posts.assignAll(stored);
    }
    isLoading.value = false;
  }

  void toggleLike(String postId) {
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final post = posts[idx];
    final updated = post.copyWith(
      isLiked: !post.isLiked,
      likes: post.isLiked ? post.likes - 1 : post.likes + 1,
    );
    posts[idx] = updated;
    _storage.updatePost(updated);
  }

  void toggleBookmark(String postId) {
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final post = posts[idx];
    final updated = post.copyWith(isBookmarked: !post.isBookmarked);
    posts[idx] = updated;
    _storage.updatePost(updated);
  }

  void addPost(PostModel post) {
    posts.insert(0, post);
    _storage.addPost(post);
  }

  void deletePost(String postId) {
    posts.removeWhere((p) => p.id == postId);
    _storage.deletePost(postId);
  }

  void setNavIndex(int index) => currentNavIndex.value = index;

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    _loadPosts();
  }
}
