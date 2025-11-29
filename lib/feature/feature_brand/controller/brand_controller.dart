import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/feature_brand/entity/brand_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_shop/view/widget/custom_button.dart';
import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:amonoroze_panel_admin/feature/widgets/button_global.dart';
import 'package:amonoroze_panel_admin/feature/widgets/circle_avatar_global.dart';
import 'package:amonoroze_panel_admin/feature/widgets/text_field_global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
    fetchBrand();
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  TextEditingController editDescController = TextEditingController();

  UploadController uploadController = Get.put(UploadController());

  String? token = '';

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  bool notFound = false;
  List<BrandEntity> brands = [];

  Future fetchBrand() async {
    brands.clear();
    final response = await dio.get(
      '$baseUrl/brands',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      brands.addAll(list.map((item) => BrandEntity.fromJson(item)));
      notFound = brands.isEmpty;
      update();
    }
  }

  Future<void> editBrand({required id}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? t = pref.getString('token');
    // Validation
  if (editNameController.text.isEmpty || uploadController.selectedImage.isEmpty || t == ''||editDescController.text.isEmpty) {
      showSnackBar(message: 'Please fill all requirements', status: 'Error', isSucceed: false);
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
          "description": editDescController.text,
          "logo": uploadController.selectedImage,
          "name": editNameController.text,
      };

      final response = await dio.put(
        "$baseUrl/admin/brands/$id",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $t',
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        descController.clear();
        nameController.clear();
        fetchBrand();
        Get.back();
        showSnackBar(message: "Brand updated successfully", status: "Success", isSucceed: true);
        return;
      } else {
        // Backend error but not a crash
        showSnackBar(message: "Server error: ${response.data}", status: "Error", isSucceed: false,);
      }
    } catch (e, s) {
      showSnackBar(message: 'Encountered error: $e', status: 'Error', isSucceed: false);
    }
  }


  Future<void> deleteBrand({id, index}) async {
    try {
      final response = await dio.delete(
        '$baseUrl/admin/brands/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        brands.removeAt(index);
        update();
        showSnackBar(
          message: "Brand deleted successfully",
          status: "Success",
          isSucceed: true,
        );
      } else {
        showSnackBar(
          message: "Failed to delete brand. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: "Error deleting brand: $e",
        status: "Error",
        isSucceed: false,
      );
    }
  }

  final Dio dio = Dio();

  Future<void> createBrand() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var t = preferences.getString('token');
    try {
      if (nameController.text.isEmpty || uploadController.selectedImage.isEmpty || t == ''|| descController.text.isEmpty) {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Prevent API call if data is invalid
      }

      // --- API Request ---
      final response = await dio.post(
        "$baseUrl/admin/brands",
        data: {
          "description": descController.text,
          "logo": uploadController.selectedImage,
          "name": nameController.text
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $t",
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );

      // --- Success ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        fetchBrand();
        showSnackBar(
          message: "Brand created successfully",
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
        message: "Failed to create Brand: $e",
        isSucceed: false,
      );
    }
  }
  Future<Widget>? showBottomSheetForCreate({required context}) async {
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
                controller: descController,
                hint: 'Enter Description',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: nameController,
                hint: 'Enter Name',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(onTap: () => createBrand(), title: 'Add Child Brand'),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> editBottomSheet({required id,required context}) async {
    return await showModalBottomSheet(
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              CircleAvatarGlobal(),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: editDescController,
                hint: 'Enter Description',
                icon: null,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              TextFiledGlobal(
                type: TextInputType.text,
                controller: editNameController,
                hint: 'Enter Name',
                icon: null,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              CustomButton(text: 'Edit', onPressed: () => editBrand(id:id)),
            ],
          ),
        );
      },
      context: context,
    );
  }
}