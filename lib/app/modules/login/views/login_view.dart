import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),

                  // ── Header ───────────────────────────────────────────
                  _buildHeader(),
                  const SizedBox(height: 40),

                  // ── Fields ───────────────────────────────────────────
                  _buildEmailField(controller),
                  const SizedBox(height: 16),
                  _buildPasswordField(controller),
                  const SizedBox(height: 8),
                  _buildForgotPassword(),
                  const SizedBox(height: 24),

                  // ── Login Button ─────────────────────────────────────
                  _buildLoginButton(controller),
                  const SizedBox(height: 32),

                  // ── Sign Up Link ─────────────────────────────────────
                  _buildSignUpLink(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEEEF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 40,
            color: Color(0xFFE63946),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
        ),
      ],
    );
  }

  Widget _buildEmailField(LoginController controller) {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: controller.validateEmail,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: _inputDecoration(
        label: 'Email',
        hint: 'you@example.com',
        icon: Icons.email_outlined,
      ),
    );
  }

  Widget _buildPasswordField(LoginController controller) {
    return Obx(() => TextFormField(
      controller: controller.passwordController,
      obscureText: !controller.isPasswordVisible.value,
      validator: controller.validatePassword,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: _inputDecoration(
        label: 'Password',
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF9E9E9E),
            size: 20,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
    ));
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.snackbar('Info', 'Forgot password tapped'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFFE63946),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(() => ElevatedButton(
      onPressed:
      controller.isLoading.value ? null : controller.login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE63946),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFCCCCCC),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: controller.isLoading.value
          ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      )
          : const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.REGISTER),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFE63946),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
      hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        const BorderSide(color: Color(0xFFE63946), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}