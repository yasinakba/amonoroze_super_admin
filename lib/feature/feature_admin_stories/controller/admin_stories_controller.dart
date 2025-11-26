import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_admin_stories/entity/story_enitity.dart';
import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminStoriesController extends GetxController {
  final dio = Dio();
  final UploadController uploadController = Get.put(UploadController());
  String? token;
  List<StoryEntity> stories = [];
  late final pagingStory = PagingController<int, StoryEntity>(
    getNextPageKey: (state) =>
    state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => fetchStories(pageKey),
  );
  @override
  void onInit() {
    super.onInit();
     _setToken();
  }


  /// -----------------------------
  /// TOKEN
  /// -----------------------------
  Future<void> _setToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    update();
    fetchStories(1);
  }

  Map<String, String> get authHeaders => {
    'Authorization': 'Bearer $token',
    'accept': 'application/json',
  };

  bool get hasToken => token != null && token!.isNotEmpty;

  /// -----------------------------
  /// FETCH STORIES
  /// -----------------------------
  Future<List<StoryEntity>> fetchStories(pageKey) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    try {
      if(token ==''){
        await _setToken();
      }
      if (!hasToken) {
        showSnackBar(
          message: 'Token not found.',
          status: "Error",
          isSucceed: false,
        );
        return[];
      }

      final response = await dio.get(
        '$baseUrl/admin/stories?page=$pageKey?limit=10',
        options: Options(headers: authHeaders),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final list = response.data['data'] as List;
        stories = list.map((item) => StoryEntity.fromJson(item)).toList();
        update();
       return stories;
      }
      return [];
    } catch (e) {
      showSnackBar(message: 'Failed to fetch stories', status: 'Error $e', isSucceed: false);
      return [];
    }
  }

  /// -----------------------------
  /// FETCH STORIES BY ID
  /// -----------------------------
  Future<void> fetchStoriesId({required String id}) async {
    try {
      stories.clear();

      // Your original code uses POST - probably incorrect.
      // If the backend expects GET, change POST → GET.
      final response = await dio.post(
        '$baseUrl/admin/stories',
        options: Options(headers: authHeaders),
      );

      if (response.statusCode == 200) {
        final list = response.data['data'] as List;
        stories = list.map((item) => StoryEntity.fromJson(item)).toList();
        update();
      }
    } catch (e) {
      showSnackBar(message: 'Failed to fetch story by ID', status: 'Error', isSucceed: false);
      print(e);
    }
  }

  /// -----------------------------
  /// CREATE STORY
  /// -----------------------------
  Future<void> createStories({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        '$baseUrl/admin/stories',
        data: data,
        options: Options(
          headers: {
            ...authHeaders,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final list = response.data['data'] as List;
        stories = list.map((item) => StoryEntity.fromJson(item)).toList();
        update();
      }
    } catch (e) {
      showSnackBar(message: 'Failed to create story', status: 'Error', isSucceed: false);
      print(e);
    }
  }

  /// -----------------------------
  /// DELETE STORY
  /// -----------------------------
  Future<void> deleteStories({required String id, required int index}) async {
    try {
      final response = await dio.delete(
        '$baseUrl/admin/stories/$id',
        options: Options(headers: authHeaders),
      );

      if (response.statusCode == 200) {
        if (index < stories.length) {
          stories.removeAt(index);
        }
        update();
      }
    } catch (e) {
      showSnackBar(message: 'Failed to delete story', status: 'Error', isSucceed: false);
    }
  }
}
