import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constant.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E), size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Avatar picker ──────────────────────────────────────
                _buildAvatarPicker(),
                const SizedBox(height: 24),

                // ── Header ─────────────────────────────────────────────
                _buildHeader(),
                const SizedBox(height: 32),

                // ── Fields ─────────────────────────────────────────────
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 32),

                // ── Register Button ────────────────────────────────────
                _buildRegisterButton(),
                const SizedBox(height: 24),

                // ── Sign In Link ───────────────────────────────────────
                _buildSignInLink(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GetBuilder<RegisterController>(
            builder: (logic) => CircleAvatar(
              radius: 56,
              backgroundColor: const Color(0xFFF0F0F5),
              backgroundImage: controller.image != null
                  ? FileImage(controller.image!) as ImageProvider
                  : NetworkImage(kDefaultProfile),
            ),
          ),
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE63946),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Fill in the details below to get started',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: controller.validateName,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: _inputDecoration(
        label: 'Full Name',
        hint: 'John Doe',
        icon: Icons.person_outline_rounded,
      ),
    );
  }

  Widget _buildEmailField() {
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

  Widget _buildPasswordField() {
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

  Widget _buildConfirmPasswordField() {
    return Obx(() => TextFormField(
      controller: controller.confirmPasswordController,
      obscureText: !controller.isConfirmPasswordVisible.value,
      validator: controller.validateConfirmPassword,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: _inputDecoration(
        label: 'Confirm Password',
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            controller.isConfirmPasswordVisible.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF9E9E9E),
            size: 20,
          ),
          onPressed: controller.toggleConfirmPasswordVisibility,
        ),
      ),
    ));
  }

  Widget _buildRegisterButton() {
    return Obx(() => ElevatedButton(
      onPressed:
      controller.isLoading.value ? null : controller.register,
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
        'Create Account',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Text(
            'Sign In',
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