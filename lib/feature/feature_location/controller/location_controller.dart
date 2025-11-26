import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_location/entity/city_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_location/entity/province_entity.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class LocationController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProvince();
  }
  final Dio dio = Dio();
  ProvinceEntity selectedProvince = ProvinceEntity();
  CityEntity selectedCity = CityEntity();
  List<ProvinceEntity> provinces = [];
  List<CityEntity> cities = [];
  Future<List<ProvinceEntity>> fetchProvince() async {
    try {
      final response = await dio.get(
        '$baseUrl/provinces',
        options: Options(headers: {
          'accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the API follows the same structure { data: [...] } as your other endpoints
        List<dynamic> list = response.data['data'];
        provinces = list.map((item) => ProvinceEntity.fromJson(item)).toList();
        update();
        return provinces;
      }
    } catch (e) {
      showSnackBar(message: "Error fetching provinces: $e", status: "Error", isSucceed: false);
    }
    return [];
  }
  Future<List<CityEntity>> fetchCity(provinceId) async {
    try {
      final response = await dio.get(
        '$baseUrl/cities/$provinceId',
        options: Options(headers: {
          'accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> list = response.data['data'];
        cities = list.map((item) => CityEntity.fromJson(item)).toList();
        update();
        return cities;
      }
    } catch (e) {
      showSnackBar(message: "Error fetching provinces: $e", status: "Error", isSucceed: false);
    }
    return [];
  }

}