import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class SignupController extends GetxController {
  final _service = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmVisibility() =>
      isConfirmVisible.value = !isConfirmVisible.value;

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _snack('Error', 'Please fill in all fields.');
      return;
    }
    if (password != confirm) {
      _snack('Error', 'Passwords do not match.');
      return;
    }
    if (password.length < 6) {
      _snack('Error', 'Password must be at least 6 characters.');
      return;
    }

    isLoading.value = true;
    try {
      await _service.signUp(
        email: email,
        password: password,
        displayName: name,
      );
      // AuthGate handles navigation automatically on auth state change.
    } on FirebaseAuthException catch (e) {
      _snack('Sign up failed', _message(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.back();

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _snack(String title, String message) => Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
  );

  String _message(String code) => switch (code) {
    'email-already-in-use' => 'An account already exists for this email.',
    'invalid-email' => 'Please enter a valid email address.',
    'weak-password' => 'Password is too weak.',
    'operation-not-allowed' => 'Email sign-up is not enabled.',
    _ => 'Something went wrong. Please try again.',
  };

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
