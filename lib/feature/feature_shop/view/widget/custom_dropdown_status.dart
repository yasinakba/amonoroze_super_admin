import 'package:amonoroze_panel_admin/feature/feature_shop/controller/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownStatus extends StatelessWidget {
  const DropdownStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(
        initState: (state) {
          Get.lazyPut(() => ShopController());
        },
        builder: (logic) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Status"),
                  value: logic.selectedStatus,
                  items: logic.statuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      logic.selectedStatus = value;
                      logic.update(); // Update UI
                      // logic.fetchShop(); // You might want to trigger a fetch here
                    }
                  },
                ),
              ),
            ),
          );
        });
  }
}
