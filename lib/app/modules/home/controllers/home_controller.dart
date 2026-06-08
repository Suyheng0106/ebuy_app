import 'package:ebuy/app/modules/cart/bindings/cart_binding.dart';
import 'package:ebuy/app/modules/cart/views/cart_view.dart';
import 'package:ebuy/app/modules/product/bindings/product_binding.dart';
import 'package:ebuy/app/modules/product/views/product_view.dart';
import 'package:ebuy/app/modules/profile/bindings/profile_binding.dart';
import 'package:ebuy/app/modules/profile/views/profile_view.dart';
import 'package:ebuy/app/modules/search-product/bindings/search_product_binding.dart';
import 'package:ebuy/app/modules/search-product/views/search_product_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt currentIndex = RxInt(0);
  var lstRoutesName = [
    Routes.PRODUCT,
    Routes.SEARCH_PRODUCT,
    Routes.CART,
    Routes.PROFILE,
  ];

  void ontTabBottomNav(int index) {
    currentIndex(index);
    Get.offAndToNamed(lstRoutesName[index], id: 1);

    Get.offAndToNamed(
      lstRoutesName[index],
      id: 1,
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const ProductView(),
        binding: ProductBinding(),
      );
    }

    if (settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => SearchProductView(),
        binding: SearchProductBinding(),
      );
    }

    if (settings.name == Routes.CART) {
      return GetPageRoute(
        settings: settings,
        page: () =>  CartView(),
        binding: CartBinding(),
      );
    }

    if (settings.name == Routes.PROFILE) {
      return GetPageRoute(
        settings: settings,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
      );
    }
  }


}
