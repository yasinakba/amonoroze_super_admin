import 'package:amonoroze_panel_admin/feature/feature_shop/entity/shop_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_dropdown_status.dart';
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
class ReasonRow {
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();
}
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
    "waiting",
    "accepted",
    "rejected",
    "blocked",
  ];
  String selectedStatus = "waiting";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
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
    try {
      final response = await dio.get(
        '$baseUrl/admin/all-shops?status=$selectedStatus&page=1&limit=10',
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

  var reasonRows = <ReasonRow>[].obs;
  void addReasonRow() {
    reasonRows.add(ReasonRow());
    update(); // update UI
  }

  void removeReasonRow(int index) {
    reasonRows.removeAt(index);
    update();
  }


  Future<void> editShop(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? t = preferences.getString('token');
    Map<String, String> dynamicReasons = {};
    for (var row in reasonRows) {
      if (row.keyController.text.isNotEmpty) {
        dynamicReasons[row.keyController.text] = row.valueController.text;
      }
    }

    if (reasonController.text.isEmpty || selectedStatus == '--'|| t == '') {
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
        "reasons": dynamicReasons,
        "shop_id": id,
        "status": selectedStatus,
        "status_reason": reasonController.text,
      };

      final response = await dio.patch(
        "$baseUrl/admin/change-shop-status/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => false, // <--- NO THROW
          headers: {
            'Authorization': 'Bearer $t',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        reasonController.clear();
        selectedStatus = '--';
        fetchShop();
        showSnackBar(message: "Shop updated successfully", status: "Success", isSucceed: true,);
        Get.back();
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
      print(e);
      showSnackBar(
        message: 'Encountered error: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }


  Future<Widget> editBottomSheet({id, context}) async {
    // Clear previous rows when opening
    reasonRows.clear();

    return await showModalBottomSheet(
      isScrollControlled: true, // Important so keyboard doesn't hide content
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Padding(
            // Adjust padding for keyboard
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10.w,
                right: 10.w,
                top: 10.h
            ),
            child: Container(
              // Constrain height so it doesn't take full screen but is scrollable
              constraints: BoxConstraints(maxHeight: 500.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Edit Shop Status", style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.h),

                    // Status Dropdown
                    SizedBox(
                        height: 40.h,
                        width: double.infinity,
                        child: DropdownStatus()
                    ),
                    SizedBox(height: 10.h),

                    // Main Reason
                    TextFiledGlobal(
                      type: TextInputType.text,
                      controller: reasonController,
                      hint: 'Main Reason',
                      icon: null,
                      filteringTextInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                    ),

                    Divider(height: 30.h),

                    // --- DYNAMIC REASONS SECTION ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Additional Details (Map)", style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: () => addReasonRow(),
                        )
                      ],
                    ),

                    // List of Key-Value Pairs
                    GetBuilder<ShopController>(
                        builder: (logic) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: logic.reasonRows.length,
                            separatorBuilder: (c, i) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              var row = logic.reasonRows[index];
                              return Row(
                                children: [
                                  // Key Input
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: row.keyController,
                                      decoration: InputDecoration(
                                        labelText: "Key (e.g. Prop1)",
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  // Value Input
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller: row.valueController,
                                      decoration: InputDecoration(
                                        labelText: "Value",
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                      ),
                                    ),
                                  ),
                                  // Delete Button
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => logic.removeReasonRow(index),
                                  )
                                ],
                              );
                            },
                          );
                        }
                    ),
                    // --------------------------------

                    SizedBox(height: 20.h),
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: () => editShop(id),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
// Helper class for the UI list

