import 'package:amonoroze_panel_admin/app_config/app_routes/name_routes.dart';
import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final dio = Dio();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;


  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    try {
      if (userNameController.text.isEmpty && passwordController.text.isEmpty) {
        showSnackBar(
          isSucceed: false,
          status: "Error",
          message: "Email and password cannot be empty",
        );
        return;
      }
      final preferences = await SharedPreferences.getInstance();

      final response = await dio.post('http://amonoroz.com/api/v1/admin/signin',data: {
        "username": userNameController.text,
        "password": passwordController.text,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offNamed(NamedRoute.homeScreen);
        preferences.setString('token', response.data['data']['access_token']);
      }
      // 🔹 Handle API validation / auth error
      else if (response.statusCode == 400 || response.statusCode == 401) {
        showSnackBar(
          isSucceed: false,
          status: "Invalid Credentials",
          message: response.data['message'] ?? "Username or password is wrong",
        );
      }
      // 🔹 Handle server error
      else if (response.statusCode == 500) {
        showSnackBar(isSucceed: false,status: "Server Error", message: "Please try again later");
      }
      // 🔹 Catch-all
      else {
        showSnackBar(
          isSucceed: false,
          status: "Error",
          message: response.data['message'] ?? "Unknown error",
        );
      }

      update();

    } catch (e, stacktrace) {
      debugPrint("🔥 Exception while fetching account: $e");
      debugPrint(stacktrace.toString());
    }
  }
}
