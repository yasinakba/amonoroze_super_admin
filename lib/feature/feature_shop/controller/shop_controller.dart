import 'package:amonoroze_panel_admin/feature/feature_shop/entity/shop_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../view/edit_status_shop.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/entity/category_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/constant/contstant.dart';
import '../../feature_shop/view/widget/custom_button.dart';
import '../../feature_upload/upload_controller.dart';
import '../../widgets/text_field_global.dart';

// class ShopController extends GetxController {
//
//   Future<Widget> showBottom(context) async {
//     return await showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return SizedBox(
//           height: 200.h, // using screenutil
//           child: EditStatusShop(),
//         );
//       },
//     );
//   }
// }

class ShopController extends GetxController {
  final Dio dio = Dio();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  int selectedPageCount = 1;
  int selectedLimit = 10; // default selected number
  TextEditingController reasonController = TextEditingController();

  final List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<int> limits = [10, 15, 20, 30, 40];

  // List of dropdown options
  final List<String> statuses = [
    "--",
    "waiting",
    "accepted",
    "rejected",
    "blocked",
  ];
  String selectedStatus = "--";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
    fetchShop();
  }

  UploadController uploadController = Get.put(UploadController());
  String? token = '';

  List<ShopEntity> shops = [];

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  List<CategoryEntity> categories = [];

  Future fetchShop() async {
    if(selectedStatus == '--'){
      showSnackBar(message: 'Please select status', status: 'Warning', isSucceed: false);
    }
    shops.clear();
    final response = await dio.get(
      '$baseUrl/admin/all-shops?status=$selectedStatus&page=$selectedPageCount&limit=$selectedLimit',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      shops.addAll(list.map((item) => ShopEntity.fromJson(item)));
      update();
    }
  }

  Future<void> editShop(id) async {
    // Validation
    if (reasonController.text.isEmpty) {
      showSnackBar(
        message: 'Please fill all requirements',
        status: 'Error',
        isSucceed: false,
      );
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
        "reasons": {
          "additionalProp1": "string",
          "additionalProp2": "string",
          "additionalProp3": "string",
        },
        "shop_id": "string",
        "status": "waiting",
        "status_reason": "string",
      };

      final response = await dio.patch(
        "$baseUrl/admin/change-shop-status/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => true, // <--- NO THROW
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        reasonController.clear();
        selectedStatus = '--';
        fetchShop();
        Get.back();

        showSnackBar(
          message: "Shop updated successfully",
          status: "Success",
          isSucceed: true,
        );
        return;
      } else {
        // Backend error but not a crash
        showSnackBar(
          message: "Server error: ${response.data}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e, s) {
      showSnackBar(
        message: 'Encountered error: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }


  Future<Widget> editBottomSheet({id, context}) async {
    return await showModalBottomSheet(
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              CustomDropdown(
                list: statuses,
                title: '--',
                selected: selectedStatus,
                onChanged: (value) {
                  selectedStatus = value!;
                  update();
                },
              ),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: reasonController,
                hint: 'Title',
                icon: null,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              CustomButton(
                text: 'Edit',
                onPressed: () => (id),
              ),
            ],
          ),
        );
      },
      context: context,
    );
  }
}
