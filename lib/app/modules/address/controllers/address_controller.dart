import '../../../data/models/address.model.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';

class AddressController extends GetxController {
  final _provider = Get.find<ApiProvider>();
  Rx<Address> address = Rx(Address());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fectchAddress();
  }

  void fectchAddress() async {
    try {
      final response = await _provider.getAddress();
      if (response.statusCode != 200) {
        throw Exception(response.data["message"]);
      }
      final data = response.data;
      address.value = Address.fromJson(data);
      print('address ${address.value.data}');
    }catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
