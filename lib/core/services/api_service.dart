import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({this.data, this.error, required this.success});
}

class ApiService {
  final String baseUrl;
  final http.Client _client = http.Client();

  ApiService({required this.baseUrl});

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return ApiResponse(data: fromJson(jsonData), success: true);
      } else {
        return ApiResponse(
          error: 'Request failed with status: ${response.statusCode}',
          success: false,
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error: $e', success: false);
    }
  }

  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<T> items =
            jsonList
                .map((item) => fromJson(item as Map<String, dynamic>))
                .toList();
        return ApiResponse(data: items, success: true);
      } else {
        return ApiResponse(
          error: 'Request failed with status: ${response.statusCode}',
          success: false,
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error: $e', success: false);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return ApiResponse(data: fromJson(jsonData), success: true);
      } else {
        return ApiResponse(
          error: 'Request failed with status: ${response.statusCode}',
          success: false,
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error: $e', success: false);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return ApiResponse(data: fromJson(jsonData), success: true);
      } else {
        return ApiResponse(
          error: 'Request failed with status: ${response.statusCode}',
          success: false,
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error: $e', success: false);
    }
  }

  Future<ApiResponse<bool>> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(data: true, success: true);
      } else {
        return ApiResponse(
          error: 'Request failed with status: ${response.statusCode}',
          success: false,
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error: $e', success: false);
    }
  }
}
