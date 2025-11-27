import 'package:amonoroze_panel_admin/app_config/app_style/app_fonts.dart';
import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/controller/shop_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/entity/shop_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/edit_status_shop.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_dropdown_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShopScreen extends StatelessWidget {
  final ShopController shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 360.w,
        height: 690.h,
        child: GetBuilder<ShopController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownStatus(),
                  ElevatedButton(onPressed: () async{
                    controller.fetchShop();
                  }, child: Text('Get shops',style: AppFonts.labelMedium.copyWith(color: Colors.black),)),
                ],
              ),
                    SizedBox(width: 20.w,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.shops.length,
                        itemBuilder: (context, index) {
                          ShopEntity shop = controller.shops[index];
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
                                        "$baseImageUrl/${shop.frontNationalCardImage}",
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
                                      shop.name ?? "No Title",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                        "CreatedAt ${shop.createdAt}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ),
                                  Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                                    controller.reasonController.text = shop.name;
                                    controller.editBottomSheet(id:shop.id,context: context);
                                  }, icon: Icon(Icons.edit,color: Colors.green,)),),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                      ],
                );
        })

    ));
  }
}
