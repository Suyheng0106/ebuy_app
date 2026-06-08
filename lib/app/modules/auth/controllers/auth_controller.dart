import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';

class AuthController extends GetxController {

  final _api = Get.find<ApiProvider>();
  var isAuthenticated = false;

  @override
  void onInit() {
    // TODO: implement onInit
    _checkAuthState();
    super.onInit();
  }

  void _checkAuthState () async {
    try{
      final response = await _api.me();

      if (response.statusCode != 200) {
        // error
        throw response.data['message'];
      }
      isAuthenticated = true;
      update();

    }catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
