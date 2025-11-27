import 'package:amonoroze_panel_admin/feature/feature_category/controller/category_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_category/view/widget/drop_down_category.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/entity/specification_entity.dart' hide Options;
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

class SpecificationController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final orderController = TextEditingController(text: "0");
  final CategoryController categoryController = Get.put(CategoryController());
  final UploadController uploadController = Get.put(UploadController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
    fetchSpecifications();
  }
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    orderController.dispose();
    for (var row in optionsList) {
      row.valueController.dispose();
      row.orderController.dispose();
    }
    super.onClose();
  }
  var optionsList = <OptionRow>[].obs;
  var isRequired = true.obs;
  var selectedType = "input_single".obs;

  void addOption() {
    optionsList.add(OptionRow());
  }
  void removeOption(int index) {
    optionsList.removeAt(index);
  }
  Map<String, dynamic> collectData(String categoryId,) {
    // Map the dynamic options rows to the JSON structure
    List<Map<String, dynamic>> mappedOptions = optionsList.map((row) {
      return {
        "order": int.tryParse(row.orderController.text) ?? 0,
        "value": row.valueController.text,
      };
    }).toList();

    return {
      "category_id": categoryId,
      "title": titleController.text,
      "description": descriptionController.text,
      "guide_video": uploadController.selectedVideo, // From your UploadController
      "is_required": isRequired.value,
      "order": int.tryParse(orderController.text) ?? 0,
      "type": selectedType.value,
      "options": mappedOptions,
    };
  }


  String? token = '';
  final Dio dio = Dio();

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  List<SpecificationEntity> specification = [];

  Future fetchSpecifications() async {
    if (token == '') {
      await setToken();
    }
    specification.clear();
    try {
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
        specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)));
        update();
      } else {
        showSnackBar(
          message: "Failed to fetch specifications. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: "Error fetching specifications: $e",
        status: "Error",
        isSucceed: false,
      );
    }
  }

  Future fetchSpecificationCategory({cId}) async {
    specification.clear();
    try {
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
        specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)));
        update();
      } else {
        showSnackBar(
          message: "Failed to fetch category specifications. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: "Error fetching category specifications: $e",
        status: "Error",
        isSucceed: false,
      );
    }
  }
  final List<String> inputTypes = [
    "input_single",
    "input_multiple",
    "select_one",
    "select_multiple",
    "checkbox",
    "radio"
  ];

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
      specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)));
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
      specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)));
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
      specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)));
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
        data:collectData(categoryController.selectedCategory.id??''),
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

  Future<void> deleteSpecification({id}) async {
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
              // TextFiledGlobal(
              //   type: TextInputType.text,
              //   controller: ,
              //   hint: 'Enter title',
              //   icon: Icons.text_fields,
              //   filteringTextInputFormatter:
              //       FilteringTextInputFormatter.singleLineFormatter,
              // ),
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
              DropDownCategory(),
              // TextFiledGlobal(
              //   type: TextInputType.text,
              //   controller: titleController,
              //   hint: 'Enter title',
              //   icon: null,
              //   filteringTextInputFormatter:
              //       FilteringTextInputFormatter.singleLineFormatter,
              // ),
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
class OptionRow {
  TextEditingController valueController = TextEditingController();
  TextEditingController orderController = TextEditingController(text: "0");
}