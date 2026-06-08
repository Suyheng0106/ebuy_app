import 'package:ebuy/app/data/providers/api_provider.dart';
import 'package:ebuy/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final _api = Get.find<ApiProvider>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // TODO: Replace with your real API call
      // e.g. await AuthService.login(email, password);
      final response = await _api.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print("response ${response.data}");

      if (response.statusCode != 200) {
        throw Exception('${response.data['message']}');
      }

      //Get token from response
      final token = response.data['token'];
      await StorageService.write(key: 'token', value: token);

      Get.offAllNamed(Routes.HOME);

    } on UnauthorizedException catch (e) {
      _showErrorSnackbar('Login Failed', e.message);

    } on NetworkException catch (e) {
      _showErrorSnackbar('Network Error', e.message);

    } on FormatException {
      _showErrorSnackbar('Unexpected Error', 'Invalid response from server. Please try again.');

    } catch (e) {
      _showErrorSnackbar('Error', 'Something went wrong. Please try again later.');
      debugPrint('Login error: $e');

    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

// ---------------------------------------------------------------------------
// Custom exceptions — move to lib/app/core/exceptions/app_exceptions.dart
// ---------------------------------------------------------------------------
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}


