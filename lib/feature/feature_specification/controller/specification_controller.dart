import 'dart:convert';

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
  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();
  final editOrderController = TextEditingController(text: "0");
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
  Map<String, dynamic> collectData() {
    // Map the dynamic options rows to the JSON structure
    List<Map<String, dynamic>> mappedOptions = optionsList.map((row) {
      return {
        "order": int.tryParse(row.orderController.text.trim()) ?? 0,
        "value": row.valueController.text,
      };
    }).toList();

    return {
      "category_id": categoryController.selectedCategory.id,
      "title": titleController.text,
      "description": descriptionController.text,
      "guide_video": uploadController.selectedVideo, // From your UploadController
      "is_required": isRequired.value,
      "order": int.tryParse(orderController.text) ?? 0,
      "type": selectedType.value,
      "options": mappedOptions,
    };
  }
  Map<String, dynamic> editCollectData() {
    // Map the dynamic options rows to the JSON structure
    List<Map<String, dynamic>> mappedOptions = optionsList.map((row) {
      return {
        "order": int.tryParse(row.orderController.text) ?? 0,
        "value": row.valueController.text,
      };
    }).toList();

    return {
      "category_id": categoryController.selectedCategory.id,
      "title": editTitleController.text,
      "description": editDescriptionController.text,
      "guide_video": uploadController.selectedVideo, // From your UploadController
      "is_required": isRequired.value,
      "order": int.tryParse(editOrderController.text) ?? 0,
      "type": selectedType.value,
      "options": mappedOptions,
    };
  }
  Future<void> createSpecification() async {
    final p = await SharedPreferences.getInstance();
    var t = p.getString('token');
    try {
      final response = await dio.post(
        "$baseUrl/admin/specifications",
        data:jsonEncode(collectData()),
        options: Options(
          headers: {
            "Authorization": "Bearer $t",
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );
      print(response.statusCode);
      print(response.data);
      // --- Success ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSpecifications();
        showSnackBar(
          message: "Category created successfully",
          status: "Success",
          isSucceed: true,
        );
        Get.back();
      } else {
        showSnackBar(
          status: "Error",
          message: "Unexpected response: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      print(e);
      showSnackBar(
        status: "Error",
        message: "Failed to create category: $e",
        isSucceed: false,
      );
    }
  }

  String? token = '';
  final Dio dio = Dio();

  setToken() async {

  }

  List<SpecificationEntity> specification = [];
  List<SpecificationEntity> specificationInherited = [];
  List<CategoryEntity> specificationCategory= [];

  Future fetchSpecifications() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? t = preferences.getString('token');

    if (t == '') {
      showSnackBar(message: 'Token is missing', status: 'Error', isSucceed: false);
      return;
    }

    specification.clear();

    try {
      final response = await dio.get(
        '$baseUrl/admin/specifications',
        options: Options(
          headers: {
            'Authorization': 'Bearer $t',
            'accept': 'application/json',
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final list = response.data['data'];
        specification.addAll(list.map((item) => SpecificationEntity.fromJson(item)),);
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

  Future fetchSpecificationCategory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? t = preferences.getString('token');

    if (t == null || t.isEmpty) {
      showSnackBar(message: 'Token is missing', status: 'Error', isSucceed: false);
      return;
    }

    specificationCategory.clear();

    try {
      final response = await dio.get(
        '$baseUrl/admin/specifications/category/${categoryController.selectedCategory.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $t',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final list = response.data['data'] as List;
        specificationCategory.addAll(
          list.map((item) => CategoryEntity.fromJson(item)),
        );
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

  Future fetchSpecificationCategoryInherited() async{
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? t = preferences.getString('token');
      // --- Validate Token ---
      if (t == '') {
        showSnackBar(
          message: 'Token is missing',
          status: 'Error',
          isSucceed: false,
        );
        return;
      }

      // --- Validate Category ID ---
      final cId = categoryController.selectedCategory.id;
      if (cId == null) {
        showSnackBar(
          message: 'No category selected',
          status: 'Error',
          isSucceed: false,
        );
        return;
      }

      specificationInherited.clear();

      // --- API Call ---
      final response = await dio.get(
        '$baseUrl/admin/specifications/category/$cId/inherited',
        options: Options(
          headers: {
            'Authorization': 'Bearer $t',
            'accept': 'application/json',
          },
        ),
      );
      // --- Response Handling ---
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        specificationInherited.addAll(
          list.map((item) => SpecificationEntity.fromJson(item)),
        );
        update();
      } else {
        showSnackBar(
          message: "Failed to fetch inherited specs. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      // --- Global Error Catch ---
      showSnackBar(
        message: "Error fetching inherited specifications: $e",
        status: "Error",
        isSucceed: false,
      );
    }
  }


  Future fetchSpecificationsId({required id}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? t = preferences.getString('token');
    final response = await dio.get(
      '$baseUrl/admin/specifications/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $t',
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

  Future editSpecifications({required id}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? t = preferences.getString('token');
    try {
      final response = await dio.put(
        '$baseUrl/admin/specifications/$id',
        data: jsonEncode(editCollectData()),
        options: Options(
          headers: {
            'Authorization': 'Bearer $t',
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Ideally, you should populate your text controllers here with response.data
        update();
      } else {
        showSnackBar(
          message: "Failed to fetch specification details. Status: ${response.statusCode}",
          status: "Error",
          isSucceed: false,
        );
      }
    } catch (e) {
      print(e);
      showSnackBar(
        message: "Error fetching specification details: $e",
        status: "Error",
        isSucceed: false,
      );
    }
  }



  Future<void> deleteSpecification({required id}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? t = pref.getString('token');

      if (t == '') {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Exit the function if validation fails
      }

      // --- API Request ---
      final response = await dio.delete(
        "$baseUrl/admin/specifications/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $t",
            "accept": "application/json",
          },
        ),
      );

      // --- Success ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSpecifications();
        showSnackBar(
          message: "Category created successfully",
          status: "Success",
          isSucceed: true,
        );
        Get.back();
      } else {
        showSnackBar(
          status: "Error",
          message: "Unexpected response: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        status: "Error",
        message: "Failed to create category: $e",
        isSucceed: false,
      );
    }
  }
}
class OptionRow {
  TextEditingController valueController = TextEditingController();
  TextEditingController orderController = TextEditingController(text: "0");
}