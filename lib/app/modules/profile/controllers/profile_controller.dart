import 'package:ebuy/app/data/models/user_profile.model.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final _api = Get.find<ApiProvider>();
  Rx<UserProfile> userProfile = Rx<UserProfile>(UserProfile());

  @override
  void onInit() {
    // TODO: implement onInit
    getUserProfile();
    super.onInit();
  }

  void confirmLogout() {
    // confirm

    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      onConfirm: logout,
      onCancel: () {},
    );
  }

  void logout() async {
    try{
      final response = await _api.logout();
      Get.snackbar("Success", "Logout successfully");
      Get.offAndToNamed(Routes.LOGIN);
    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }
  }


  void getUserProfile () async {
    try{
      final response = await _api.me();

      if (response.statusCode != 200) {
        // error
        throw response.data['message'];
      }

      // get user profile from model
      final data = response.data;
      userProfile.value = UserProfile.fromJson(data);

      update();

    }catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
