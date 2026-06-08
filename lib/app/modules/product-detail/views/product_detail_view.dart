import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constant.dart';
import '../../product/controllers/product_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments; // Products object passed via Get.toNamed
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E),
              size: 18,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Product Image ──────────────────────────────────────────────
          Container(
            height: 340,
            width: double.infinity,
            color: const Color(0xFFF0F0F5),
            child: product.image != null
                ? Image.network(
              '$kImgPreview/${product.image}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Color(0xFFCCCCCC),
                  size: 60,
                ),
              ),
            )
                : const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFFCCCCCC),
                size: 60,
              ),
            ),
          ),

          // ── Info Panel ─────────────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name ?? '',
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE63946),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.isActive == 1
                            ? const Color(0xFFE8F8F0)
                            : const Color(0xFFFFEEEF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.isActive == 1 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: product.isActive == 1
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFFE63946),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Divider(color: Colors.grey.shade100, thickness: 1.5),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description ?? 'No description available.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B6B6B),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Add to Cart Button ───────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: product.isActive == 1
                ? () => controller.addToCart(product.id!)
                : null,
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE63946),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFCCCCCC),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}