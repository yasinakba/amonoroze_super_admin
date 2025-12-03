import 'package:get/get.dart';

class ProductController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  // Future<List<StoryEntity>> fetchStories(pageKey) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? t = prefs.getString('token');
  //   if(t==''){
  //     Get.toNamed(NamedRoute.loginScreen);
  //   }
  //   try {
  //
  //     final response = await dio.get(
  //       '$baseUrl/admin/stories?page=$pageKey?limit=10',
  //       options: Options(headers: {
  //         'Authorization': 'Bearer $t',
  //         'accept': 'application/json',
  //       }),
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       List<dynamic> list = response.data['data'] ;
  //       stories = list.map((item) => StoryEntity.fromJson(item)).toList();
  //       update();
  //       return stories;
  //     }
  //     return [];
  //   } catch (e) {
  //     showSnackBar(message: 'Failed to fetch stories', status: 'Error $e', isSucceed: false);
  //     return [];
  //   }
  // }
}