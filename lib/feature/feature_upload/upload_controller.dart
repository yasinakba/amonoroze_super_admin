import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class UploadController extends GetxController {
  String selectedImage = 'usericon.png';
  Uint8List? webImageBytes;
  Uint8List? webVideoBytes;

  String imageName = '';
  String? webImageUrl;
  String? webVideoUrl;
  final String uploadImageUrl = "$baseUrl/admin/upload-image";
  final String uploadVideoUrl = "$baseUrl/admin/upload-video";
  XFile? pickedFile;

  void uploadImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final picker = ImagePicker();

    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    pickedFile = file;

    // --- 1. Handle Web Preview & Bytes ---
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      webImageBytes = bytes;

      // Convert Dart Uint8List to JS Uint8Array for the Blob
      final jsData = bytes.toJS;

      // Create Blob for preview using the JS array
      final blob = html.Blob([jsData].toJS);
      webImageUrl = html.URL.createObjectURL(blob);

      update();
    } else {
      // Mobile preview logic (if you have a variable for File path)
      // imageFile = File(file.path);
      update();
    }

    // --- 2. Create Request ---
    var request = http.MultipartRequest("POST", Uri.parse(uploadImageUrl));

    // --- 3. Add File (Web vs Mobile) ---
    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          webImageBytes!,
          filename: file.name,
          contentType: MediaType("image", file.name.split('.').last),
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
          contentType: MediaType("image", file.name.split('.').last),
        ),
      );
    }

    // --- 4. Add Headers ---
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // --- 5. Send & Handle Response ---
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        selectedImage = data['object_name'];
        update();
      } else {
        showSnackBar(
          message: "Error",
          status: "Upload failed: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      print(e);
      showSnackBar(message: "Error", status: "Exception: $e", isSucceed: false);
    }
  }

  XFile? videoPicked;
  String? selectedVideo;

  // Renamed for clarity

  Future<void> uploadVideo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    ImagePicker picker = ImagePicker();

    // 1. Pick Video
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    videoPicked = file;
    final extension = file.name
        .split('.')
        .last
        .toLowerCase(); // Robust extension check

    // 2. Handle Web Preview
    if (kIsWeb) {
      if (extension == 'mp4' || extension == 'mov' || extension == 'avi') {
        final bytes = await file.readAsBytes();
        webVideoBytes = bytes;

        // Convert Dart Uint8List to JS Uint8Array
        final jsData = bytes.toJS;

        // Create Blob with specific MIME type using BlobPropertyBag
        final blob = html.Blob(
          [jsData].toJS,
          html.BlobPropertyBag(type: 'video/mp4'),
        );

        // Create the URL for the video player widget
        selectedVideo = html.URL.createObjectURL(blob);

        update();
      } else {
        showSnackBar(
          message: 'Please select a valid video file (mp4)',
          status: 'Warning',
          isSucceed: false,
        );
        return; // Stop if invalid extension
      }
    }

    // 3. Prepare Upload Request
    // Note: Ensure your backend endpoint 'uploadVideoUrl' handles video uploads
    var request = http.MultipartRequest("POST", Uri.parse(uploadVideoUrl));
    if (kIsWeb) {
      if (webVideoBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "file",
            webVideoBytes!,
            filename: file.name,
            // FIX: Removed 'http.' prefix and added import above
            contentType: MediaType("video", "mp4"),
          ),
        );
      }
    } else {
      // Mobile/Desktop logic
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          videoPicked!.path,
          // FIX: Removed 'http.' prefix
          contentType: MediaType("video", "mp4"),
        ),
      );
    }

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // 4. Send Request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);

        // Assuming your API returns the filename in the same structure
        // You might want to store this in a different variable like 'selectedVideo'
        selectedVideo = data['object_name'];

        showSnackBar(
          message: "Success",
          status: "Video uploaded successfully",
          isSucceed: true,
        );
        update();
      } else {
        showSnackBar(
          message: "Error",
          status: "Upload failed: ${response.statusCode}",
          isSucceed: false,
        );
      }
    } catch (e) {
      showSnackBar(
        message: "Error",
        status: "Exception during upload: $e",
        isSucceed: false,
      );
    }
  }

  VideoPlayerController? _videoPlayerController;

  void initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.file(File(videoPicked!.path))
      ..initialize().then((_) {
        update();
      });
  }

  // Make sure the controller is nullable at the top of your class

  Widget _videoPlayer() {
    if (_videoPlayerController!.value.isInitialized) {
      return Container(
        width: 60.w,
        height: 60.w,
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
