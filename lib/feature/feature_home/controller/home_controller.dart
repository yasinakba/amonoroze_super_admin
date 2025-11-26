import 'package:amonoroze_panel_admin/feature/feature_banner/view/banner_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/widget/first_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  Widget body = FirstView();
  AppBar appBar = AppBar(backgroundColor: Colors.white);

  Widget listTile({
    required Widget widget,
    required String title,
    required IconData icon,
    required AppBar appBar,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      onTap: () {
        body = widget;
        this.appBar = appBar;
        update();
      },
      onFocusChange: (value) => true,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
