import 'package:amonoroze_panel_admin/feature/feature_authentication/controller/login_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/controller/home_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
    Get.put(HomeController());

  }

}