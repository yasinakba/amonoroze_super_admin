import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_banner/controller/banner_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_banner/entity/banner_entity.dart';

import 'package:amonoroze_panel_admin/feature/widgets/button_global.dart';
import 'package:amonoroze_panel_admin/feature/widgets/text_field_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(
      initState: (state) {
        Get.lazyPut(() => BannerController());
      },
      builder: (controller) {
     return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.banners.length,
                  itemBuilder: (context, index) {
                    BannerEntity banner = controller.banners[index];
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
                                  "$baseImageUrl/${banner.image}",
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner.title ?? "No Title",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "level ${banner.level}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                                  controller.titleController.text = banner.title??'';
                                  controller.editingLevelController.text = banner.level.toString();
                                  controller.uploadController.imageName = banner.image??'';
                                  controller.editBottomSheet(id:banner.id,context: context);
                                }, icon: Icon(Icons.edit,color: Colors.green,)),),
                                Padding(padding: EdgeInsets.all(12),child: IconButton(onPressed: () {
                                  showCustomDialog(context: context,onYesPressed: () => controller.deleteBanner(id: banner.id,context: context,index: index), text: 'Do you want delete', objectName: banner.title??'');
                                }, icon: Icon(Icons.delete,color: Colors.pink,)),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              ),
            ],
          );
      },
    );
  }
}

AppBar bannerAppBar(context) {
  return AppBar(backgroundColor: Colors.white,
    title: GetBuilder<BannerController>(
      builder: (controller) {
        return Row(
          children: [
            SizedBox(
              height: 40.h,
              width: 100.w,
              child: TextFiledGlobal(
                type: TextInputType.number,
                controller: controller.levelController,
                hint: 'Enter the Level',
                icon: null,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.digitsOnly,
              ),
            ),
            ButtonGlobal(
              onTap: () =>
                  controller.fetchBanners(level:controller.levelController.text),
              title: 'Get banners',
            ),
            Spacer(),
            IconButton(
              onPressed: () {
               controller.clearController();
                controller.showBottomSheetForCreate(context);
              },
              icon: Icon(Icons.add_circle, color: Colors.green.shade700),
            ),
          ],
        );
      },
    ),
  );
}
