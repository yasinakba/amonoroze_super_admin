import 'package:amonoroze_panel_admin/feature/feature_location/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class CityDropdownGlobal extends StatelessWidget {
  const CityDropdownGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(initState: (state) {
      Get.lazyPut(() => LocationController(),);
    },builder: (logic) {
      return logic.cities.isNotEmpty? Container(
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
              logic.selectedCity.name ?? "Select City",
            ),

            // Selected VALUE must match a dropdown item value
            value: logic.cities.any((p) => p.id == logic.selectedCity.id)
                ? logic.selectedCity.id
                : null,

            items: logic.cities.map((city) {
              return DropdownMenuItem<String>(
                value: city.id,                     // ID is the value
                child: Text(
                  city.name ?? "null",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),

            onChanged: (String? id) {
              if (id == null) return;

              // Get full object by ID
              final selected = logic.cities.firstWhere(
                    (p) => p.id == id,
              );
              logic.selectedCity = selected;
              logic.update();
            },
          ),
        ),
      ):const SizedBox();
    });
  }
}

