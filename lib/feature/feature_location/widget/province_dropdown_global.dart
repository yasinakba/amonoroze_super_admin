import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/location_controller.dart';

class ProvinceDropdownGlobal extends StatelessWidget {
  const ProvinceDropdownGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      initState: (_) {
        Get.lazyPut(() => LocationController());
      },
      builder: (logic) {
        return Container(
          alignment: Alignment.center,
          height: 30.h,
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                logic.selectedProvince.name ?? "Select Province",
              ),

              // Selected VALUE must match a dropdown item value
              value: logic.provinces.any((p) => p.id == logic.selectedProvince.id)
                  ? logic.selectedProvince.id
                  : null,

              items: logic.provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province.id,                     // ID is the value
                  child: Text(
                    province.name ?? "null",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),

              onChanged: (String? id) {
                if (id == null) return;

                // Get full object by ID
                final selected = logic.provinces.firstWhere(
                      (p) => p.id == id,
                );
                logic.selectedProvince = selected;
                logic.fetchCity(selected.id);
                logic.update();
              },
            ),
          ),
        );
      },
    );
  }
}
