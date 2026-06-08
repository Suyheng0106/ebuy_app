import 'package:ebuy/app/utils/helper/awesome_notifications_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/dependency_injection.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/helper/fcm_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmHelper.initFcm();
  await AwesomeNotificationsHelper.init();

  DependencyInjection.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
