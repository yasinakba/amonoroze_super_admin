import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_config/remote/http_handler.dart';
import '../view/edit_status_shop.dart';

class ShopController extends GetxController{
  final ApiService apiService = Get.put(ApiService());
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  int selectedPageCount = 1;
  int selectedLimit = 10;// default selected number
  TextEditingController reasonController = TextEditingController();

  final List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<int> limits = [10,15,20,30,40];
  // List of dropdown options
  final List<String> statuses = [
    "--",
    "waiting",
    "accepted",
    "rejected",
    "blocked",
  ];
  String selectedStatus = "--";
  Future<Widget> showBottom(context)async{
    return           await  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.h, // using screenutil
          child: EditStatusShop(),
        );
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> fetchShop() async {
    isLoading.value = true;

    try {
      final response = await apiService.get(
        "admin/all-shops?page=1&limit=20", // 👈 change to your real endpoint
        query: {
          'status':selectedStatus,
          'page':selectedPageCount,
          'limit':selectedLimit,
        },
      );

      isLoading.value = false;

      // 🔹 Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Login successful",
            snackPosition: SnackPosition.BOTTOM);

        // Example: Navigate to home screen
        // Get.offAll(() => HomeScreen());

      }
      // 🔹 Handle API validation / auth error
      else if (response.statusCode == 400 || response.statusCode == 401) {
        Get.snackbar("Invalid Credentials",
            response.bodyString ?? "Username or password is wrong",
            snackPosition: SnackPosition.BOTTOM);
      }
      // 🔹 Handle server error
      else if (response.statusCode == 500) {
        Get.snackbar("Server Error", "Please try again later",
            snackPosition: SnackPosition.BOTTOM);
      }
      // 🔹 Catch-all
      else {
        Get.snackbar("Error", response.statusText ?? "Unknown error",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      // 🔹 Handle network / timeout error
      Get.snackbar("Network Error", "Check your internet connection",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> editShopStatus(shopId) async {
    isLoading.value = true;
    Map<String,dynamic> body = {
      "reasons": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string"
      },
      "shop_id": shopId,
      "status": selectedStatus,
      "status_reason": reasonController.text,
    };
    try {
      final response = await apiService.get(
        "admin/all-shops?page=1&limit=20",
        query: {
          'status':selectedStatus,
          'page':selectedPageCount,
          'limit':selectedLimit,
        },
      );

      isLoading.value = false;

      // 🔹 Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Login successful",
            snackPosition: SnackPosition.BOTTOM);

        // Example: Navigate to home screen
        // Get.offAll(() => HomeScreen());

      }
      // 🔹 Handle API validation / auth error
      else if (response.statusCode == 400 || response.statusCode == 401) {
        Get.snackbar("Invalid Credentials",
            response.bodyString ?? "Username or password is wrong",
            snackPosition: SnackPosition.BOTTOM);
      }
      // 🔹 Handle server error
      else if (response.statusCode == 500) {
        Get.snackbar("Server Error", "Please try again later",
            snackPosition: SnackPosition.BOTTOM);
      }
      // 🔹 Catch-all
      else {
        Get.snackbar("Error", response.statusText ?? "Unknown error",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      // 🔹 Handle network / timeout error
      Get.snackbar("Network Error", "Check your internet connection",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}