import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_brand/controller/brand_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_brand/entity/brand_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BrandController>(initState: (state) {
      Get.lazyPut(() => BrandController(),);
    },builder: (controller) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.brands.length,
              itemBuilder: (context, index) {
                BrandEntity brand = controller.brands[index];
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
                              "$baseImageUrl/${brand.logo}",
                              height: 80,
                              width: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            brand.name ?? "No Title",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            brand.description ?? "No Title",
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
                              controller.editBottomSheet(id:brand.id,context: context);
                            }, icon: Icon(Icons.edit,color: Colors.green,)),),
                            Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                              showCustomDialog(context: context,onYesPressed: () => controller.deleteBrand(id: brand.id,index: index), text: 'Do you want delete', objectName: brand.name??'');
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
    },);
  }
}
AppBar brandAppBar({context}) {
  Get.lazyPut(() => BrandController(),);
  var c = Get.find<BrandController>();
  return AppBar(
    backgroundColor: Colors.white,
    actions: [
      IconButton(onPressed: () => c.showBottomSheetForCreateParent(context), icon: Icon(Icons.add_circle,color: Colors.deepPurpleAccent.shade200,))
    ],
  );
}