import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const background = Color(0xFFF0EFFA);
  static const primary = Color(0xFF4A32E8);
  static const textColor = Color(0xFF252B3A);
  static const muted = Color(0xFF8D8A9D);
  static const borderColor = Color(0xFFE0DDEC);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _header(),
                        const SizedBox(height: 28),
                        _signupCard(controller),
                        const SizedBox(height: 20),
                        _loginPrompt(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ─────────────────────────────────────────────────────────────────

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TaskFlow',
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.3),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: muted,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _header() {
    return const Column(
      children: [
        Text(
          'Join TaskFlow',
          style: TextStyle(
            color: primary,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Start managing your workflow with effortless productivity.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Signup card ─────────────────────────────────────────────────────────────

  Widget _signupCard(SignupController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6656BA).withValues(alpha: 0.07),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Full Name'),
          const SizedBox(height: 6),
          AppTextField(
            hintText: 'John Doe',
            icon: Icons.person_outline_rounded,
            controller: controller.nameController,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          _fieldLabel('Email Address'),
          const SizedBox(height: 6),
          AppTextField(
            hintText: 'name@company.com',
            icon: Icons.mail_outline_rounded,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _fieldLabel('Password'),
          const SizedBox(height: 6),
          Obx(
            () => AppTextField(
              hintText: '........',
              icon: Icons.lock_outline_rounded,
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              trailing: _visibilityToggle(
                visible: controller.isPasswordVisible.value,
                onTap: controller.togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Confirm'),
          const SizedBox(height: 6),
          Obx(
            () => AppTextField(
              hintText: '........',
              icon: Icons.lock_outline_rounded,
              controller: controller.confirmController,
              obscureText: !controller.isConfirmVisible.value,
              trailing: _visibilityToggle(
                visible: controller.isConfirmVisible.value,
                onTap: controller.toggleConfirmVisibility,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Obx(
            () => PrimaryButton(
              label: 'Create Account',
              isLoading: controller.isLoading.value,
              onPressed: controller.createAccount,
            ),
          ),
        ],
      ),
    );
  }

  // ── Field label ─────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: muted,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    );
  }

  // ── Visibility toggle ───────────────────────────────────────────────────────

  Widget _visibilityToggle({
    required bool visible,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
      color: const Color(0xFFC5C1D2),
      iconSize: 19,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    );
  }

  // ── Login prompt ────────────────────────────────────────────────────────────

  Widget _loginPrompt(SignupController controller) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
            color: muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: controller.goToLogin,
          style: TextButton.styleFrom(
            foregroundColor: primary,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: const Text('Log in'),
        ),
      ],
    );
  }
}
