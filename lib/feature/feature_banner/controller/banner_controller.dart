import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/feature_banner/entity/banner_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_location/controller/location_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_location/widget/city_dropdown_global.dart';
import 'package:amonoroze_panel_admin/feature/feature_location/widget/province_dropdown_global.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_button.dart';
import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:amonoroze_panel_admin/feature/widgets/button_global.dart';
import 'package:amonoroze_panel_admin/feature/widgets/circle_avatar_global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/text_field_global.dart';

class BannerController extends GetxController {
  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    setToken();
  }

  UploadController uploadController = Get.put(UploadController());
  String? token = '';

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  clearController() async {
    levelController.clear();
    titleController.clear();
    editingLevelController.clear();
  }

  bool notFound = false;
  List<BannerEntity> banners = [];
  LocationController locationController = Get.put(LocationController());

  Future fetchBanners(level) async {
    try {
      if (level == '' || token == '') {
        await setToken();
        showSnackBar(
          message: 'Please Enter level',
          status: 'Warning',
          isSucceed: false,
        );
        return;
      }
      banners.clear();
      final response = await dio.get(
        '$baseUrl/banners?level=$level',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = response.data['data'];
        banners.addAll(list.map((item) => BannerEntity.fromJson(item)));
        notFound = banners.isEmpty;
        update();
      } else {
        showSnackBar(
          message: 'Failed to fetch banners. Status: ${response.statusCode}',
          status: 'Error',
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: 'Error fetching banners: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }


  Future<void> editBanner(id) async {
    // Validation
    if (titleController.text.isEmpty || editingLevelController.text.isEmpty) {
      showSnackBar(
        message: 'Please fill all requirements',
        status: 'Error',
        isSucceed: false,
      );
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
        "destination_id": "string",
        "destination_screen": "string",
        "Level": editingLevelController.text,
        "Title": titleController.text,
        "Image": uploadController.selectedImage,
      };

      final response = await dio.put(
        "$baseUrl/admin/banners/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => true, // <--- NO THROW
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        editingLevelController.clear();
        titleController.clear();
        fetchBanners(levelController.text);
        Get.back();

        showSnackBar(message: "Banner updated successfully", status: "Success", isSucceed: true,);
        return;
      }
    } catch (e, s) {
      // Backend error but not a crash
      showSnackBar(
        message: "Server error: $e",
        status: "Error",
        isSucceed: false,
      );

      showSnackBar(
        message: 'Encountered error: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }

  Future<void> deleteBanner({id, context, index}) async {
    try {
      final response = await dio.delete(
        '$baseUrl/admin/banners/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        banners.removeAt(index);
        update();
        showSnackBar(
          message: 'Banner deleted successfully',
          status: 'Success',
          isSucceed: true,
        );
      } else {
        showSnackBar(
          message: 'Failed to delete banner. Error: ${response.statusMessage}',
          status: 'Error',
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: 'Error deleting banner: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }

  TextEditingController levelController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController editingLevelController = TextEditingController();

  Future createBanner() async {
    if (levelController.text.isEmpty ||
        uploadController.selectedImage.isEmpty ||
        token == '' ||
        titleController.text.isEmpty||
        locationController.selectedCity.id =='') {
      showSnackBar(
        status: 'Error',
        message: 'Please Fill all argument',
        isSucceed: false,
      );
      return; // Stop execution
    }

    try {
      final response = await dio.post(
        "$baseUrl/admin/banners",
        data: {
          'image': uploadController.selectedImage,
          'level': levelController.text,
          "title": titleController.text,
          'destination_id': locationController.selectedCity.id,
          'destination_screen': 'banner',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        showSnackBar(message: 'Succeed', status: 'Success', isSucceed: true);
        Get.back();
      } else {
        showSnackBar(
          message: 'Failed to create banner. Status: ${response.data}',
          status: 'Error',
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: 'Error creating banner: $e',
        status: 'Error',
        isSucceed: false,
      );
    }
  }

  Future<Widget>? showBottomSheetForCreate(context) async {
    bool isDesktop = Responsive.isDesktop(context);
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          height: 300.h,
          width: isDesktop ? 120.w : 300.w,
          child: Column(
            children: [
              CircleAvatarGlobal(),
              ProvinceDropdownGlobal(),
              CityDropdownGlobal(),
              TextFiledGlobal(
                type: TextInputType.number,
                controller: levelController,
                hint: 'Enter level',
                icon: Icons.integration_instructions,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.digitsOnly,
              ),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: titleController,
                hint: 'Enter title',
                icon: Icons.title_outlined,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(onTap: () => createBanner(), title: 'Add'),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> editBottomSheet({id, context}) async {
    return await showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 400.h,
      constraints: BoxConstraints(minHeight: 690.h),
      builder: (BuildContext context) {
        return Container(
          height: 690.h,
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              CircleAvatarGlobal(),
              ProvinceDropdownGlobal(),
              CityDropdownGlobal(),
              TextFiledGlobal(
                type: TextInputType.number,
                controller: editingLevelController,
                hint: 'Level',
                icon: null,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.digitsOnly,
              ),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: titleController,
                hint: 'Title',
                icon: null,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              CustomButton(text: 'Edit', onPressed: () => editBanner(id)),
            ],
          ),
        );
      },
      context: context,
    );
  }
}
