import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/feature_admin_stories/view/admin_stories_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_auth_sentences/view/auth_sentence_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_banner/view/banner_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_brand/view/brand_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/view/category_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/controller/home_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_home/widget/first_view.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/shop_screen.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/view/specification_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (state) {
      Get.put(HomeController());
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
          appBar: controller.appBar,
          drawer: Responsive.isDesktop(context)
              ? Drawer(
            backgroundColor: Colors.black45,
            width: 60.w,
            surfaceTintColor: Colors.red,
            child: Column(children: [
              controller.listTile(widget: FirstView(),
                  title: 'Home',
                  icon: Icons.home_filled, appBar: AppBar(backgroundColor: Colors.white,)),
              controller.listTile(widget: BannerScreen(),
                  title: 'Banners',
                  icon: Icons.image_sharp, appBar: bannerAppBar(context)),
              controller.listTile(widget: CategoryScreen(),
                  title: 'Categories',
                  icon: Icons.category, appBar: categoryAppBar(context: context)),
              controller.listTile(widget: ShopScreen(),
                  title: 'Shops',
                  icon: Icons.store, appBar: AppBar(backgroundColor: Colors.white,)),
              controller.listTile(widget: SpecificationScreen(),
                  title: 'Specification',
                  icon: Icons.more_horiz_outlined, appBar: specificationAppBar(context)),
              controller.listTile(widget: AdminStoriesScreeen(),
                  title: 'AdminStories',
                  icon: Icons.storefront_outlined, appBar: adminStoreAppBar()),
              controller.listTile(widget: AuthSentenceScreen(),
                  title: 'Sentences',
                  icon: Icons.text_decrease, appBar: authSentenceAppBar(context)),
              controller.listTile(widget: BrandScreen(),
                  title: 'Brand',
                  icon: Icons.branding_watermark, appBar: brandAppBar(context: context)),
            ]),

          )
              : null,
          body: controller.body,
          bottomNavigationBar: Responsive.isMobile(context) || Responsive.isTablet(context)? Obx(() {
            return AnimatedBottomNavigationBar(
              inactiveColor: Colors.black54,
              activeColor: Colors.black,
              icons: [
                Icons.image_aspect_ratio,
                Icons.filter_alt_outlined,
                Icons.shopping_basket_outlined,
              ],
              activeIndex: controller.index.value,
              gapLocation: GapLocation.none,
              notchSmoothness: NotchSmoothness.smoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              onTap: (index) {
                controller.index.value = index;
                switch (index) {
                  case 0:
                    controller.body = FirstView();
                    controller.update();
                    break;
                  case 1:
                    controller.body = BannerScreen();
                    controller.appBar = bannerAppBar(context);
                    controller.update();
                    break;
                  case 2:
                    controller.body = CategoryScreen();
                    controller.update();
                    break;
                  case 3:
                    controller.body = ShopScreen();
                    controller.update();
                    break;
                }
              },
            );
          }):null);
    });
  }
}