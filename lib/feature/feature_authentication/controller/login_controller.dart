import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_config/remote/http_handler.dart';


class LoginController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final ApiService apiService = Get.put(ApiService());

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      final response = await apiService.postRequest(
        "admin/signin", // 👈 change to your real endpoint
        {
          "username": userNameController.text,
          "password": passwordController.text,
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
