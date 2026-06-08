import 'package:ebuy/app/modules/home/controllers/home_controller.dart';
import 'package:ebuy/app/modules/home/views/home_view.dart';
import 'package:ebuy/app/modules/login/controllers/login_controller.dart';
import 'package:ebuy/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (logic) {
        if (logic.isAuthenticated) {
          final isRegistered = Get.isRegistered<HomeController>();
          if (!isRegistered) {
            Get.put(HomeController());
          }
          return HomeView();
        } else {
          final isRegistered = Get.isRegistered<LoginController>();
          if (!isRegistered) {
            Get.put(LoginController());
          }
          return LoginView();
        }
      },
    );
  }
}
