import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),

              const SizedBox(height: 30),

              // Email Field
              TextField(
                controller: controller.userNameController,
                decoration: const InputDecoration(
                  labelText: "UserName",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field with toggle
              Obx(() => TextField(
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
              )),

              const SizedBox(height: 30),

              // Login button
              Obx(() => SizedBox(
                width: double.infinity,
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
      ),
    );
  }
}
