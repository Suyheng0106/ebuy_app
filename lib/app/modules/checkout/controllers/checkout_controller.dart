import 'package:ebuy/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

import '../../../data/models/address.model.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
  final cartData = {}.obs;
  final _api = Get.find<ApiProvider>();
  List<Data> addresses = <Data>[].obs;
  RxBool isLoading = false.obs;
  // selected address
  Rxn<Data> selectedAddress = Rxn<Data>();

  @override
  void onInit() {
    getCartItems();
    getAddress();
    super.onInit();
  }

  void getCartItems() {
    final data = Get.arguments;
    print("data ${data}");
    if (data != null) {
      cartData.value = data;
    }
  }

  //getAddress
  void getAddress() async {
    try {
      final response = await _api.getAddress();
      if (response.statusCode == 200) {
        final rawData = response.data['data'] as List;
        addresses = rawData.map((e) => Data.fromJson(e)).toList();
        selectedAddress?.value = addresses.first;
      } else {
        Get.snackbar('Error', 'Failed to get address');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
