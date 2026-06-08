import 'package:ebuy/app/modules/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';
import '../../../data/models/product.model.dart';
import '../../../data/providers/api_provider.dart';

class ProductController extends GetxController {
  final _api = Get.find<ApiProvider>();
  Rx<Product> product = Rx(Product());
  final isLoading = true.obs;
  final cartController = Get.find<CartController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProducts();
  }

  void addToCart (int proId) async {
    cartController.addToCart(proId);
  }

  void fetchProducts() async {
    try{
      final response = await _api.getProducts();
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      final data = response.data;

      product.value = Product.fromJson(data);

    }catch (e) {
      Get.snackbar("Message", e.toString());
    }
    finally{
      isLoading.value = false;
    }
  }
}
