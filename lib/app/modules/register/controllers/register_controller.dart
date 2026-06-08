import 'dart:io';

import 'package:ebuy/app/data/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final _api = Get.find<ApiProvider>();
  File? image;
  final _imagePicker = ImagePicker();

  // pick image from gallery
  void pickImage() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = File(file.path);
      update();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ── Validators ─────────────────────────────────────────────────────────────

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // TODO: Replace with your real API call
      // e.g. await AuthService.register(name, email, password);
      final response = await _api.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Get.snackbar(
        'Account Created',
        'Welcome! Your account has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.LOGIN);

    } on EmailAlreadyExistsException catch (e) {
      _showErrorSnackbar('Registration Failed', e.message);

    } on NetworkException catch (e) {
      _showErrorSnackbar('Network Error', e.message);

    } on FormatException {
      _showErrorSnackbar('Unexpected Error', 'Invalid response from server. Please try again.');

    } catch (e) {
      _showErrorSnackbar('Error', 'Something went wrong. Please try again later.');
      debugPrint('Register error: $e');

    } finally {
      isLoading.value = false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

// ── Custom Exceptions ─────────────────────────────────────────────────────────
// Move to lib/app/core/exceptions/app_exceptions.dart in a real project

class EmailAlreadyExistsException implements Exception {
  final String message;
  const EmailAlreadyExistsException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}