import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/controller/category_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/entity/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      initState: (state) {
        Get.lazyPut(() => CategoryController());
      },
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  CategoryEntity category = controller.categories[index];
                  return Table(
                    columnWidths: const {
                      0: FixedColumnWidth(150), // Image column
                      1: FlexColumnWidth(), // Text column
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade100,),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "$baseImageUrl/${category.image}",
                                height: 80,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                          ),

                          // Banner Title + Details
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              category.title ?? "No Title",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                                controller.titleController.text = category.title??'';
                                controller.editBottomSheet(id:category.id,context: context);
                              }, icon: Icon(Icons.edit,color: Colors.green,)),),
                              Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                               controller.showBottomSheetForCreateChild(context: context);
                              }, icon: Icon(Icons.add_circle,color: Colors.teal,)),),
                              Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                                showCustomDialog(context: context,onYesPressed: () => controller.deleteCategory(id: category.id,context: context,index: index), text: 'Do you want delete', objectName: category.title??'');
                              }, icon: Icon(Icons.delete,color: Colors.pink.shade200,)),),
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

AppBar categoryAppBar({context}) {
  Get.lazyPut(() => CategoryController(),);
  var c = Get.find<CategoryController>();
  return AppBar(
    centerTitle: true,
    title: Text('Categories',style: styleText,),
    backgroundColor: Colors.white,
    actions: [
      IconButton(onPressed: () {
        c.titleController.clear();
        c.showBottomSheetForCreateParent(context);
      }, icon: Icon(Icons.add_circle,color: Colors.deepPurpleAccent.shade200,))
    ],
  );
}
