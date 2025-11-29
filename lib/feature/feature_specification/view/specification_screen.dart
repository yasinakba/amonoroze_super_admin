import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/entity/category_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/view/widget/drop_down_category.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/controller/specification_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/entity/specification_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/view/widget/create_specification.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/view/widget/edit_specification.dart';
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
                      0: FixedColumnWidth(150),
                      1: FlexColumnWidth(),
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
                                    Get.to(EditSpecification(specificationId: specify.id??''));
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
            Row(
              children: [
                DropDownCategory(),
                ElevatedButton(onPressed: () => controller.fetchSpecificationCategory(), child: Text('Get Category',style: TextStyle(color: Colors.indigo),))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.specificationCategory.length,
                itemBuilder: (context, index) {
                  CategoryEntity specify = controller.specificationCategory[index];
                  return Table(
                    columnWidths: const {
                      0: FixedColumnWidth(150),
                      1: FlexColumnWidth(),
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
                                    controller.editSpecifications(
                                      id: specify.id,
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
            Row(
              children: [
                DropDownCategory(),
                ElevatedButton(onPressed: () => controller.fetchSpecificationCategoryInherited(), child: Text('Get Specification Inherited',style: TextStyle(color: Colors.indigo),))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.specificationInherited.length,
                itemBuilder: (context, index) {
                  SpecificationEntity specify = controller.specificationInherited[index];
                  return Table(
                    columnWidths: const {
                      0: FixedColumnWidth(150),
                      1: FlexColumnWidth(),
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
                                    Get.to(EditSpecification(specificationId: specify.id??''));
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

AppBar specificationAppBar(context){
  return AppBar(backgroundColor: Colors.white,centerTitle: true,title: Text('Specifications',style: styleText,),actions: [
    IconButton(onPressed: () {
    Get.to(()=>CreateSpecificationScreen());
  }, icon: Icon(Icons.add_circle,color: Colors.green,),),],);
}

