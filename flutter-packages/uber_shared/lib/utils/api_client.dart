import 'dart:convert';
import 'package:http/http.dart' as http;

/// ApiClient handles HTTP requests for the Uber Clone applications.
/// This utility is shared across all three applications (Rider, Driver, Admin).
class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (headers != null) ...headers,
        };

  /// Performs a GET request
  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return response;
  }

  /// Performs a POST request
  Future<http.Response> post(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: body is String ? body : jsonEncode(body),
    );
    return response;
  }

  /// Performs a PUT request
  Future<http.Response> put(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      uri,
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: body is String ? body : jsonEncode(body),
    );
    return response;
  }

  /// Performs a DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(
      uri,
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return response;
  }

  /// Checks if the response status code indicates success
  bool isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Parses the JSON response body
  dynamic parseJson(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  }
}