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
    fetchShop();
  }

  List<CategoryEntity> categories = [];

  Future fetchShop() async {
    if (token == '') {
      await setToken();
    }
    shops.clear();

    // FIX: Convert UI display value "--" to an empty string or null for the API
    // If the API expects "waiting", "accepted", etc., but treats empty string as "all", use this:
    String apiStatus = selectedStatus == "--" ? "" : selectedStatus;

    try {
      final response = await dio.get(
        // FIX: Use apiStatus instead of selectedStatus directly
        '$baseUrl/admin/all-shops?status=$apiStatus&page=$selectedPageCount&limit=$selectedLimit',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> list = response.data['data'];
        shops.addAll(list.map((item) => ShopEntity.fromJson(item)));
        update();
      } else {
        showSnackBar(
          message: "Failed to fetch shops. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: "Error fetching shops: $e",
        status: "Error",
        isSucceed: false,
      );
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
