import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';
import 'session_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreService();
  final _session = SessionService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Persist the login flag locally.
    await _session.saveSession(cred.user!.uid);
    return cred;
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);

    // Create the Firestore user document.
    await _firestore.createUser(
      UserModel(
        uid: cred.user!.uid,
        displayName: displayName,
        email: email,
        createdAt: DateTime.now(),
      ),
    );

    // Persist the login flag locally.
    await _session.saveSession(cred.user!.uid);
    return cred;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() async {
    await _session.clearSession();
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
