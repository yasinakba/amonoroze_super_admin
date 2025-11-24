import 'package:get/get.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/entity/category_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/constant/contstant.dart';
import '../../../app_config/constant/responsive.dart';
import '../../feature_shop/view/widget/custom_button.dart';
import '../../feature_upload/upload_controller.dart';
import '../../widgets/button_global.dart';
import '../../widgets/circle_avatar_global.dart';
import '../../widgets/text_field_global.dart';

class SpecificationController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchSpecifications();
    setToken();
  }

  UploadController uploadController = Get.put(UploadController());
  String? token = '';
  final Dio dio = Dio();

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  List<CategoryEntity> specification = [];

  Future fetchSpecifications() async {
    specification.clear();
    final response = await dio.get(
      '$baseUrl/admin/specifications',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      specification.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future fetchSpecificationCategory({cId}) async {
    specification.clear();
    final response = await dio.get(
      '$baseUrl/admin/specifications/category/$cId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      specification.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future fetchSpecificationCategoryInherited({cId}) async {
    specification.clear();
    final response = await dio.get(
      '$baseUrl/admin/specifications/category/$cId/inherited',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      specification.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future fetchSpecificationsId({id}) async {
    specification.clear();
    final response = await dio.get(
      '$baseUrl/admin/specifications/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      specification.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future editSpecifications({id}) async {
    specification.clear();
    final response = await dio.get(
      '$baseUrl/admin/specifications/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      specification.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future<void> createSpecification() async {
    try {
      // --- Validation ---

      if (uploadController.selectedImage.isEmpty || token == '') {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Prevent API call if data is invalid
      }

      // --- API Request ---
      final response = await dio.post(
        "$baseUrl/admin/specifications",
        data: {
          "category_id": "string",
          "description": "string",
          "guide_video": "string",
          "is_required": true,
          "options": [
            {"order": 0, "value": "string"},
          ],
          "order": 0,
          "title": "string",
          "type": "input_single",
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );

      // --- Success ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        fetchSpecifications();
        showSnackBar(
          message: "Category created successfully",
          status: "Success",
          isSucceed: true,
        );
      } else {
        showSnackBar(
          status: "Error",
          message: "Unexpected response: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      // --- Error Handling ---
      showSnackBar(
        status: "Error",
        message: "Failed to create category: $e",
        isSucceed: false,
      );
    }
  }

  Future<void> deleteSpecification(id) async {
    try {
      // --- Validation ---

      if (uploadController.selectedImage.isEmpty || token == '') {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Prevent API call if data is invalid
      }

      // --- API Request ---
      final response = await dio.delete(
        "$baseUrl/admin/specifications/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "application/json",
          },
        ),
      );

      // --- Success ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        fetchSpecifications();
        showSnackBar(
          message: "Category created successfully",
          status: "Success",
          isSucceed: true,
        );
      } else {
        showSnackBar(
          status: "Error",
          message: "Unexpected response: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      // --- Error Handling ---
      showSnackBar(
        status: "Error",
        message: "Failed to create category: $e",
        isSucceed: false,
      );
    }
  }

  Future<Widget>? showBottomSheetForCreateParent(context) async {
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
              TextFiledGlobal(
                type: TextInputType.text,
                controller: tex,
                hint: 'Enter title',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(
                onTap: () => createSpecification(),
                title: 'Add ParentCategory',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> editBottomSheet({id, context}) async {
    return await showModalBottomSheet(
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              CircleAvatarGlobal(),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: titleController,
                hint: 'Enter title',
                icon: null,
                filteringTextInputFormatter:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              CustomButton(
                text: 'Edit',
                onPressed: () => editSpecifications(id: id),
              ),
            ],
          ),
        );
      },
      context: context,
    );
  }
}
