import 'package:get/get.dart';
import '../../../data/models/order.model.dart';
import '../../../data/providers/api_provider.dart';

class OrderController extends GetxController {
  final _api = Get.find<ApiProvider>();
  var isLoading = true.obs;
  var orders = <Order>[].obs;
  var selectedStatus = 'pending'.obs;

  final statuses = ['pending', 'shipped', 'delivered'];

  List<Order> get filteredOrders =>
      orders.where((o) => o.status == selectedStatus.value).toList();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      isLoading(true);
      final res = await _api.getOrders();
      if (res.statusCode != 200) {
        throw Exception(res.data['message']);
      }
      final data = res.data as List;
      orders.value = data.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}