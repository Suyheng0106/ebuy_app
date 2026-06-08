import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddressView'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                final result = await Get.toNamed(Routes.ADD_ADDRESS);
                if (result) {
                  controller.fectchAddress();
                }
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Obx(() {

          if(controller.address.value.data == null) {
            return Center(child: Text("Data Empty"),);
          }
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
                itemCount: controller.address.value.data!.isNotEmpty
                    ? controller.address.value.data!.length
                    : 0,
                itemBuilder: (context, index) {
                  final address = controller.address.value.data![index];
                  return ListTile(
                    title: Text(address.city ?? ""),
                    subtitle: Text(address.country ?? ""),
                  );
                }),
          );
        }
        )
    );
  }
}
