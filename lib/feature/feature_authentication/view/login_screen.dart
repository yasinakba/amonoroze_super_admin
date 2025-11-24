import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/widgets/text_field_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),

            const SizedBox(height: 30),

            // Email Field
            TextFiledGlobal(filteringTextInputFormatter: FilteringTextInputFormatter.singleLineFormatter, type: TextInputType.text, controller: controller.userNameController, hint: "User Name", icon: Icons.person),

            const SizedBox(height: 20),

            // Password Field with toggle
            Obx(() => Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
              margin: EdgeInsetsDirectional.symmetric(vertical: 5.h),
              width:isMobile?300.w:100.w,
              height: 40.h,
              child: TextField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      controller.isPasswordHidden.toggle();
                    },
                  ),
                ),
              ),
            )),

            const SizedBox(height: 30),

            // Login button
            Obx(() => SizedBox(
              width: 60.w - 12.w,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.login(),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Login",
                    style: TextStyle(fontSize: 18)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
