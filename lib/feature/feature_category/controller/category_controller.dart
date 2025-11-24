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

class CategoryController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategory();
    setToken();
  }

  UploadController uploadController = Get.put(UploadController());
  String? token = '';

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  List<CategoryEntity> categories = [];

  Future fetchCategory() async {
    categories.clear();
    final response = await dio.get(
      '$baseUrl/categories',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      categories.addAll(list.map((item) => CategoryEntity.fromJson(item)));
      update();
    }
  }

  Future<void> editParentCategory({id}) async {
    // Validation
    if (titleController.text.isEmpty) {
      showSnackBar(message: 'Please fill all requirements', status: 'Error', isSucceed: false);
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
          "image": uploadController.selectedImage,
          "title": titleController.text,
      };

      final response = await dio.put(
        "$baseUrl/admin/categories/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => true, // <--- NO THROW
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        titleController.clear();
        fetchCategory();
        Get.back();
        showSnackBar(message: "Category updated successfully", status: "Success", isSucceed: true);
        return;
      } else {
        // Backend error but not a crash
        showSnackBar(message: "Server error: ${response.data}", status: "Error", isSucceed: false,);
      }
    } catch (e, s) {
      showSnackBar(message: 'Encountered error: $e', status: 'Error', isSucceed: false);
    }
  }
  Future<void> editChildCategory({id}) async {
    // Validation
    if (titleController.text.isEmpty) {
      showSnackBar(message: 'Please fill all requirements', status: 'Error', isSucceed: false);
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
          "image": uploadController.selectedImage,
          "title": titleController.text,
      };

      final response = await dio.put(
        "$baseUrl/admin/categories/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => true, // <--- NO THROW
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        titleController.clear();
        fetchCategory();
        Get.back();
        showSnackBar(message: "Category updated successfully", status: "Success", isSucceed: true);
        return;
      } else {
        // Backend error but not a crash
        showSnackBar(message: "Server error: ${response.data}", status: "Error", isSucceed: false,);
      }
    } catch (e, s) {
      showSnackBar(message: 'Encountered error: $e', status: 'Error', isSucceed: false);
    }
  }


  Future<void> deleteCategory({id, context,index}) async {

    final response = await dio.delete(
      '$baseUrl/admin/categories/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      categories.removeAt(index);
      update();
    }
  }
  final Dio dio = Dio();
  TextEditingController titleController = TextEditingController();

  Future<void> createParentCategory() async {
    try {
      // --- Validation ---

      if (titleController.text.isEmpty || uploadController.selectedImage.isEmpty || token == '') {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Prevent API call if data is invalid
      }

      // --- API Request ---
      final response = await dio.post(
        "$baseUrl/admin/categories",
        data: {
          "image": uploadController.selectedImage.toString(),
          "title": titleController.text,
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
        fetchCategory();
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

  Future createChildCategory(categoryId) async {
    if (titleController.text.isEmpty ||
        uploadController.selectedImage.isEmpty) {
      showSnackBar(status: 'Error', message: 'Please Fill all argument', isSucceed: false);
    }
    final response = await dio.post(
      "$baseUrl/admin/categories",
      data: {
          "image": uploadController.selectedImage,
          "parent_id": categoryId,
          "title": titleController.text,
        },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      ),
    );
    if(response.statusCode == 200){
      showSnackBar(message: 'Succeed', status: 'Success', isSucceed: true);
      Get.back();
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
                controller: titleController,
                hint: 'Enter title',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(onTap: () => createParentCategory(), title: 'Add ParentCategory'),
            ],
          ),
        );
      },
    );
  }
  Future<Widget>? showBottomSheetForCreateChild({context,categoryId}) async {
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
                controller: titleController,
                hint: 'Enter title',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(onTap: () => createChildCategory(categoryId), title: 'Add Child Category'),
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
              CustomButton(text: 'Edit', onPressed: () => editParentCategory(id:id)),
            ],
          ),
        );
      },
      context: context,
    );
  }
}