import 'package:get/get.dart';

class ApiService extends GetConnect {
  final String baseUrl = "amonoroz.com/api/v1"; // replace with your real API

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 10);

    // Optional: add headers globally (e.g. JWT token)
    // httpClient.addRequestModifier<dynamic>((request) {
    //   request.headers['Authorization'] = "Bearer your_token_here";
    //   return request;
    // });

    super.onInit();
  }

  // 🔹 GET request
  Future<Response> getRequest(String endpoint) async {
    return await get(endpoint);
  }

  // 🔹 POST request
  Future<Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    return await post(endpoint, body);
  }

  // 🔹 PUT request
  Future<Response> putRequest(String endpoint, Map<String, dynamic> body) async {
    return await put(endpoint, body);
  }

  // 🔹 PATCH request
  Future<Response> patchRequest(String endpoint, Map<String, dynamic> body) async {
    return await patch(endpoint, body);
  }

  // 🔹 DELETE request
  Future<Response> deleteRequest(String endpoint) async {
    return await delete(endpoint);
  }
}
