import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const background = Color(0xFFF7F6FE);
  static const primary = Color(0xFF4A32E8);
  static const textColor = Color(0xFF252B3A);
  static const muted = Color(0xFF8D8A9D);
  static const borderColor = Color(0xFFE0DDEC);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 365),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _brandHeader(),
                  const SizedBox(height: 28),
                  _loginCard(controller),
                  const SizedBox(height: 28),
                  _createAccountPrompt(controller),
                  const SizedBox(height: 48),
                  _securityDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Brand header ────────────────────────────────────────────────────────────

  Widget _brandHeader() {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.task_alt_rounded,
            color: Colors.white,
            size: 31,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'TaskFlow',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Simplify your daily routine.',
          style: TextStyle(
            color: muted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Login card ──────────────────────────────────────────────────────────────

  Widget _loginCard(AuthController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(27, 28, 27, 27),
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
          const Text(
            'Welcome Back',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Please enter your details to continue.',
            style: TextStyle(
              color: muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          _fieldLabel('Email Address'),
          const SizedBox(height: 6),
          AppTextField(
            hintText: 'name@example.com',
            icon: Icons.mail_outline_rounded,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _fieldLabel('Password')),
              TextButton(
                onPressed: controller.forgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text('Forgot?'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(
            () => AppTextField(
              hintText: '........',
              icon: Icons.lock_outline_rounded,
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              trailing: IconButton(
                onPressed: controller.togglePasswordVisibility,
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                color: const Color(0xFFC5C1D2),
                iconSize: 19,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Obx(
            () => PrimaryButton(
              label: 'Login',
              isLoading: controller.isLoading.value,
              onPressed: controller.login,
            ),
          ),
          const SizedBox(height: 24),
          _dividerLabel(),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SocialButton(
                  label: 'Google',
                  mark: const GoogleMark(),
                  onPressed: controller.signInWithGoogle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SocialButton(
                  label: 'Apple',
                  mark: const AppleMark(),
                  onPressed: controller.signInWithApple,
                ),
              ),
            ],
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

  // ── OR divider ──────────────────────────────────────────────────────────────

  Widget _dividerLabel() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFEFEDF5), height: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              color: Color(0xFFB1ADBE),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFEFEDF5), height: 1)),
      ],
    );
  }

  // ── Create account prompt ───────────────────────────────────────────────────

  Widget _createAccountPrompt(AuthController controller) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: muted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: controller.createAccount,
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
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  // ── Security dots ───────────────────────────────────────────────────────────

  Widget _securityDots() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_outlined, color: Color(0xFFDAD7E4), size: 12),
        SizedBox(width: 18),
        Icon(Icons.verified_user_outlined, color: Color(0xFFDAD7E4), size: 12),
        SizedBox(width: 18),
        Icon(Icons.lock_outline_rounded, color: Color(0xFFDAD7E4), size: 12),
      ],
    );
  }
}
