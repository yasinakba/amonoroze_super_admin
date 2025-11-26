import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/controller/specification_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/entity/specification_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecificationController>(
      initState: (state) {
        Get.lazyPut(() => SpecificationController());
      },
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.specification.length,
                itemBuilder: (context, index) {
                  SpecificationEntity specify = controller.specification[index];
                  return Table(
                    columnWidths: const {
                      0: FixedColumnWidth(150), // Image column
                      1: FlexColumnWidth(), // Text column
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        children: [
                          // Banner Title + Details
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              specify.title ?? "No Title",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: IconButton(
                                  onPressed: () {
                                    controller.editBottomSheet(
                                      id: specify.id,
                                      context: context,
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.green),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: IconButton(
                                  onPressed: () {
                                    showCustomDialog(
                                      context: context,
                                      onYesPressed: () => controller
                                          .deleteSpecification(id: specify.id),
                                      text: 'Do you want delete',
                                      objectName: specify.title ?? '',
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.pink.shade200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

AppBar specificationAppBar = AppBar(backgroundColor: Colors.white,);
