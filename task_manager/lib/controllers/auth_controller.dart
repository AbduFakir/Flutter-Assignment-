import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class AuthController extends GetxController {
  final _service = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _snack('Error', 'Please fill in all fields.');
      return;
    }

    isLoading.value = true;
    try {
      await _service.signIn(email: email, password: password);
      // AuthGate listens to authStateChanges — navigation is automatic.
    } on FirebaseAuthException catch (e) {
      _snack('Login failed', _message(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _snack('Error', 'Enter your email address first.');
      return;
    }
    try {
      await _service.sendPasswordReset(email);
      _snack('Email sent', 'Check your inbox to reset your password.');
    } on FirebaseAuthException catch (e) {
      _snack('Error', _message(e.code));
    }
  }

  void createAccount() => Get.toNamed('/signup');

  void signInWithGoogle() =>
      _snack('Coming soon', 'Google sign-in is not yet configured.');

  void signInWithApple() =>
      _snack('Coming soon', 'Apple sign-in is not yet configured.');

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _snack(String title, String message) => Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
  );

  String _message(String code) => switch (code) {
    'user-not-found' => 'No account found for this email.',
    'wrong-password' => 'Incorrect password.',
    'invalid-email' => 'Please enter a valid email address.',
    'user-disabled' => 'This account has been disabled.',
    'too-many-requests' => 'Too many attempts. Try again later.',
    'invalid-credential' => 'Invalid email or password.',
    _ => 'Something went wrong. Please try again.',
  };

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
