import 'package:amonoroze_panel_admin/app_config/app_routes/app_binding/bindings.dart';
import 'package:amonoroze_panel_admin/app_config/app_routes/name_routes.dart';
import 'package:amonoroze_panel_admin/feature/feature_authentication/view/login_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/home_screen.dart';
import 'package:get/get.dart';

class Pages {
  Pages._();
  static List<GetPage<dynamic>> pages = [
   GetPage(name: NamedRoute.loginScreen, page: ()=>LoginScreen(),binding: MainBinding()),
   GetPage(name: NamedRoute.homeScreen, page: ()=>HomeScreen(),binding: MainBinding()),
  ];
}
