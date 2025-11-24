import 'package:amonoroze_panel_admin/feature/feature_shop/controller/shop_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_button.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_dropdown.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditStatusShop extends StatelessWidget {
  // final
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(initState: (state) {
      Get.lazyPut(()=> ShopController());
    },builder: (controller) {
      return Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropdown(list:controller.statuses, title:'وضعیت را اتخاب کنید'),
            SizedBox(height: 5.h,),
            CustomTextField(hintText: 'دلیل خود را برای اتخاب وضعیت بنویسید', icon: null),
            SizedBox(height: 5.h,),
            CustomButton(text: 'ویرایش', onPressed: () {},),
          ],
        ),
      );
    });
  }
}
