import 'package:shared_preferences/shared_preferences.dart';

/// Manages the local login flag stored in SharedPreferences.
/// This gives an instant local signal during the splash before
/// Firebase Auth resolves its async state.
class SessionService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUid = 'uid';

  // ── Write ────────────────────────────────────────────────────────────────────

  Future<void> saveSession(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUid, uid);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUid);
  }

  // ── Read ─────────────────────────────────────────────────────────────────────

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<String?> getSavedUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }
}
