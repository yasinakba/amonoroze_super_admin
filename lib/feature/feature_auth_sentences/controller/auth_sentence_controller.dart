import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/feature_auth_sentences/entity/sentence_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:amonoroze_panel_admin/feature/widgets/circle_avatar_global.dart';
import 'package:amonoroze_panel_admin/feature/widgets/text_field_global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature_shop/view/widget/custom_button.dart';
import '../../widgets/button_global.dart';

class AuthSentenceController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
    fetchAuthSentences();
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController textContoller = TextEditingController();
  UploadController uploadController = Get.put(UploadController());
  List<SentenceEntity> sentences = [];
  final dio = Dio();
  String? token = '';

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  Future fetchAuthSentences() async {
    sentences.clear();
    final response = await dio.get(
      '$baseUrl/admin/sentences',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> list = response.data['data'];
      sentences.addAll(list.map((item) => SentenceEntity.fromJson(item)));
      update();
    }
  }

  Future<void> editSentence({id}) async {
    // Validation
    if (textContoller.text.isEmpty || token == '') {
      showSnackBar(message: 'Please fill all requirements', status: 'Error', isSucceed: false);
      return;
    }
    try {
      // Build form
      Map<String, dynamic> formData = {
        'text':textContoller.text,
      };

      final response = await dio.put(
        "$baseUrl/admin/sentences/$id",
        data: formData,
        options: Options(
          validateStatus: (_) => true, // <--- NO THROW
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200) {
        textContoller.clear();
        nameController.clear();
        fetchAuthSentences();
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


  Future<void> deleteSentence({id,index}) async {

    final response = await dio.delete(
      '$baseUrl/admin/sentences/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      sentences.removeAt(index);
      update();
    }
  }


  Future<void> createSentence() async {
    try {
      // --- Validation ---

      if (nameController.text.isEmpty || uploadController.selectedImage.isEmpty || token == ''||textContoller.text.isEmpty) {
        showSnackBar(
          status: "Error",
          message: "Please fill all required fields",
          isSucceed: false,
        );
        return; // Prevent API call if data is invalid
      }

      // --- API Request ---
      final response = await dio.post(
        "$baseUrl/admin/sentences",
        data: {
          "text": textContoller.text,
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
        fetchAuthSentences();
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
  Future<Widget>? showBottomSheetCreate({context,BrandId}) async {
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
              TextFiledGlobal(
                type: TextInputType.text,
                controller: textContoller,
                hint: 'Enter Description',
                icon: Icons.text_fields,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              ButtonGlobal(onTap: () => createSentence(), title: 'Add Sentence'),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> showBottomSheetEdit({id, context}) async {
    return await showModalBottomSheet(
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              TextFiledGlobal(
                type: TextInputType.text,
                controller: textContoller,
                hint: 'Enter Description',
                icon: null,
                filteringTextInputFormatter:
                FilteringTextInputFormatter.singleLineFormatter,
              ),
              CustomButton(text: 'Edit', onPressed: () => editSentence(id:id)),
            ],
          ),
        );
      },
      context: context,
    );
  }
}
