import 'package:ebuy/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

import '../../../data/models/product.search.result.dart';

class SearchProductController extends GetxController {
  final _api = Get.find<ApiProvider>();
  var isLoading = false.obs;
  RxList<SearchProductResult> lstProducts = RxList([]);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // searchProduct();
  }

  void searchProduct({String? keyword}) async {
    if (keyword == null || keyword.trim().isEmpty) {
      lstProducts.clear();
      isLoading(false);
      return;
    }
    try {
      isLoading(true);
      final res = await _api.searchProduct(searchKeyword: keyword);
      if (res.statusCode != 200) {
        throw Exception("${res.data['message']}");
      }
      final lstPros = res.data as List;
      lstProducts.value = lstPros
          .map((pro) => SearchProductResult.fromJson(pro))
          .toList();
    } catch (e) {
      Get.snackbar("error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
