import 'package:amonoroze_panel_admin/app_config/app_routes/app_binding/bindings.dart';
import 'package:amonoroze_panel_admin/app_config/app_routes/get_pages.dart';
import 'package:amonoroze_panel_admin/app_config/app_routes/name_routes.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/home_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'feature/feature_authentication/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      child: GetMaterialApp( // 🔑// use GetMaterialApp instead of Materia// lApp
        initialBinding: MainBinding(),
        debugShowCheckedModeBanner: false,
        getPages: Pages.pages,
        title: 'Flutter GetX Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: NamedRoute.loginScreen, // start with Login screen
      ),
    );
  }
}
