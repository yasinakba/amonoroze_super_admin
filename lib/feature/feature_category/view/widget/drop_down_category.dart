import 'package:amonoroze_panel_admin/feature/feature_category/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      initState: (_) {
        Get.lazyPut(() => CategoryController());
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
                hint: Text(
                  logic.selectedCategory.title ?? "Select Province",
                ),
                items: logic.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(
                      category.title ?? "null",
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),

                onChanged: (String? id) {
                  if (id == null) return;

                  // Get full object by ID
                  final selected = logic.categories.firstWhere(
                        (p) => p.id == id,
                  );
                  logic.selectedCategory = selected;
                  logic.update();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
