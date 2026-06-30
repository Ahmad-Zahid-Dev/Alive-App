import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';
import 'api_response.dart';

/// Reusable HTTP client. Swap base URL per environment.
class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET request.
  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// POST request.
  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: {..._defaultHeaders, ...?headers},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(data);
    }
    throw ApiException(
      message: data['message']?.toString() ?? 'Unknown error',
      statusCode: response.statusCode,
    );
  }

  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _defaultHeaders.remove('Authorization');
  }
}
