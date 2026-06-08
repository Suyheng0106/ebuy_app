import 'package:dio/dio.dart';
import 'package:ebuy/app/data/models/cart.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class CartController extends GetxController {
  final _api = Get.find<ApiProvider>();
  var isLoading = true.obs;
  Rx<Carts> cart = Rx(Carts());

  var cartItems = <CartItems>[].obs;
  var total = 0.0.obs;
  var subtotal = 0.0.obs;
  var shipping = 0.0.obs;

  final count = 0.obs;
  final cartCount = 0.obs;

  @override
  void onInit() {
    fetchCarts();
    super.onInit();
  }

  void addToCart(int proId) async {
    try {
      final response = await _api.addToCart(proId: proId, qty: 1);
      if (response.statusCode != 200) {
        throw Exception(response.data["message"]);
      }
      cartCount.value++;
      if (Get.isSnackbarOpen) return;
      Get.snackbar(
        'Success',
        "Product added to cart",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar('Message', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void fetchCarts() async {
    try {
      isLoading(true);
      final response = await _api.getCarts();
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      final data = response.data['data'] as List;

      List<CartItems> lstItem = [];
      for (var cart in data) {
        if (cart['cart_items'] is List) {
          final items = (cart['cart_items'] as List)
              .map((pro) => CartItems.fromJson(pro))
              .toList();
          lstItem.addAll(items);
        }
      }
      cartItems.assignAll(lstItem);
      cartCount.value = cartItems.length;
      _recalculate();
    } catch (e) {
      Get.snackbar("Message", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void _recalculate() {
    total.value = cartItems.fold(0.0, (sum, item) => sum + (item.price ?? 0));
    subtotal.value = total.value - shipping.value;
  }

  // ── Delete ──────────────────────────────────────────────────────────────────

  void removeItem(CartItems item) async {
    try {
      final response = await _api.deleteCartItem(itemId: item.id!);
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      cartItems.remove(item);
      cartCount.value = cartItems.length;
      _recalculate();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ── Increment / Decrement ───────────────────────────────────────────────────

  void incrementItem(CartItems item) async {
    await _updateQuantity(item, (item.quantity ?? 1) + 1);
  }

  void decrementItem(CartItems item) async {
    final currentQty = item.quantity ?? 1;
    if (currentQty <= 1) {
      Get.defaultDialog(
        title: 'Remove item?',
        middleText: 'Do you want to remove this item from your cart?',
        textConfirm: 'Remove',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFFE63946),
        onConfirm: () {
          Get.back();
          removeItem(item);
        },
      );
      return;
    }
    await _updateQuantity(item, currentQty - 1);
  }

  Future<void> _updateQuantity(CartItems item, int newQty) async {
    try {
      final response = await _api.updateCartItem(
        itemId: item.id!,
        quantity: newQty,
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      final index = cartItems.indexOf(item);
      if (index != -1) {
        final unitPrice = (item.product?.price ?? 0);
        cartItems[index] = CartItems(
          id: item.id,
          cartId: item.cartId,
          productId: item.productId,
          quantity: newQty,
          price: unitPrice * newQty,
          product: item.product,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        );
        cartItems.refresh();
        _recalculate();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void checkout() async {
    try {
      final checkoutData = {
        'total': total.value,
        'sub_total': subtotal.value,
        'shipping': shipping.value,
        'cartItems': cartItems
            .map(
              (e) => {
                'product_id': e.productId,
                'quantity': e.quantity,
                'price': e.price,
              },
            )
            .toList(),
      };
      Get.toNamed(Routes.CHECKOUT, arguments: checkoutData);
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
    }
  }
}
