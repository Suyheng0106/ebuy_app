import 'package:get/get.dart';
import 'data/providers/api_provider.dart';

class DependencyInjection {
  static void init() async {
    Get.put(ApiProvider(), permanent: true);
  }
}