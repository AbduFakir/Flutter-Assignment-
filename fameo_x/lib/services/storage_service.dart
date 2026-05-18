import 'package:get_storage/get_storage.dart';
import '../models/post_model.dart';
import '../utils/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _box = GetStorage();

  // ── User ──────────────────────────────────────────────────────────────────

  String get userName =>
      _box.read<String>(AppConstants.keyUserName) ??
      AppConstants.defaultUserName;

  String get userHandle =>
      _box.read<String>(AppConstants.keyUserHandle) ??
      AppConstants.defaultUserHandle;

  String? get userAvatar => _box.read<String>(AppConstants.keyUserAvatar);

  Future<void> saveUserName(String name) =>
      _box.write(AppConstants.keyUserName, name);

  Future<void> saveUserHandle(String handle) =>
      _box.write(AppConstants.keyUserHandle, handle);

  Future<void> saveUserAvatar(String path) =>
      _box.write(AppConstants.keyUserAvatar, path);

  // ── Settings ──────────────────────────────────────────────────────────────

  bool get isDarkMode => _box.read<bool>(AppConstants.keyDarkMode) ?? true;

  bool get notificationsEnabled =>
      _box.read<bool>(AppConstants.keyNotifications) ?? true;

  Future<void> setDarkMode(bool value) =>
      _box.write(AppConstants.keyDarkMode, value);

  Future<void> setNotifications(bool value) =>
      _box.write(AppConstants.keyNotifications, value);

  // ── Posts ─────────────────────────────────────────────────────────────────

  List<PostModel> getPosts() {
    final raw = _box.read<List>(AppConstants.keyPosts);
    if (raw == null) return [];
    return raw
        .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> savePosts(List<PostModel> posts) =>
      _box.write(AppConstants.keyPosts, posts.map((p) => p.toJson()).toList());

  Future<void> addPost(PostModel post) async {
    final posts = getPosts();
    posts.insert(0, post);
    await savePosts(posts);
  }

  Future<void> updatePost(PostModel updated) async {
    final posts = getPosts();
    final idx = posts.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      posts[idx] = updated;
      await savePosts(posts);
    }
  }

  Future<void> deletePost(String id) async {
    final posts = getPosts()..removeWhere((p) => p.id == id);
    await savePosts(posts);
  }

  Future<void> clearAll() => _box.erase();
}
