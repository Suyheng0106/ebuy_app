import 'dart:math';

import 'package:get/get.dart';
import '../../../data/models/req/address_req.model.dart';
import '../../../data/providers/api_provider.dart';

class AddAddressController extends GetxController {
  final _api = Get.find<ApiProvider>();
  
  void addAddress(AddressReq address) async {
    try {
      final response = await _api.addAddress(address);
      
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
