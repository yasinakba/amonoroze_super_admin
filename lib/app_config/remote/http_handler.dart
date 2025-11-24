import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHandler {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpHandler({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  /// ✅ GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(uri, headers: {...defaultHeaders, ...?headers});
    return _handleResponse(response);
  }

  /// ✅ POST request
  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {...defaultHeaders, ...?headers},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// ✅ PUT request
  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      uri,
      headers: {...defaultHeaders, ...?headers},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// ✅ DELETE request
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(uri, headers: {...defaultHeaders, ...?headers});
    return _handleResponse(response);
  }

  /// 🧩 Handle API response and errors
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
        throw Exception('Internal Server Error: ${response.body}');
      default:
        throw Exception('Unexpected error: ${response.statusCode}');
    }
  }
}


