import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminStoriesController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setToken();
    fetchStories();
  }
  UploadController uploadController = Get.put(UploadController());

  String? token = '';

  setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  Future fetchStories() async {
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
}