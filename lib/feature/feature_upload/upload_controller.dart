import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui';
import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UploadController extends GetxController{
  String selectedImage = 'usericon.png';
  Uint8List? webImageBytes ;
  String imageName = '';
  String? webImageUrl;
  final String uploadUrl = "$baseUrl/admin/upload-image";
  XFile? pickedFile;
  Future<void> uploadImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    pickedFile = file;
    final extension = file.name.split('.');
    print(extension);
    if (kIsWeb) {
      if(extension[1] == 'png'|| extension[1] == 'jpg'){
        final bytes = await file.readAsBytes();
        webImageBytes = bytes;

        // Create a Blob from bytes
        final blob = html.Blob([bytes]);
        webImageUrl = html.Url.createObjectUrlFromBlob(blob);

        update();
      }else{
        showSnackBar(message: 'Please enter jpg or png file', status: 'Warning',isSucceed: false);
      }
    }

// Upload
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        "file",
        webImageBytes!,
        filename: file.name,
        contentType: DioMediaType("image", "avif"), // Important for AVIF
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        "file",
        pickedFile!.path,
        contentType: DioMediaType("image", "avif"),
      ));
    }

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization':'Bearer $token',
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      selectedImage = data['data']['object_name'];
      update();
    } else {
      showSnackBar(message: "Error", status: "Upload failed: ${response.statusCode}", isSucceed: false);
    }

  }

}


