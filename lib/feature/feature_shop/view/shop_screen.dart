import 'package:amonoroze_panel_admin/app_config/app_style/app_fonts.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/controller/shop_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/edit_status_shop.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_dropdown.dart';
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
              Container(
                width: 200.w,
                height: 20.h,
                child: Row(
                  children: [
                    Spacer(),
                    CustomDropdown(list: controller.statuses,selected: controller.selectedStatus, title: 'وضعیت رو انتخاب کنید',),
                    Spacer(),
                    CustomDropdown(list: controller.numbers,selected: controller.selectedPageCount, title: 'تعداد صفحات را اتنخاب کنید',),
                    Spacer(),
                    CustomDropdown(list: controller.limits,selected: controller.selectedLimit, title: 'تعداد فروشگاه ها در هر صفحه را اتخاب کنید',),
                    SizedBox(width: 20.w,),
                    ElevatedButton(onPressed: () async{
                      controller.showBottom(context);
                    }, child: Text('جست و جو',style: AppFonts.labelMedium.copyWith(color: Colors.black),)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),

    );
  }
}
