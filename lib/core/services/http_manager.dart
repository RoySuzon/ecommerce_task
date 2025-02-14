// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Enum for HTTP methods
enum HttpMethod { GET, POST, PUT, DELETE }

class HttpManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // HTTP request method (GET, POST, PUT, DELETE) using Enum
  Future<http.Response> request(
    HttpMethod method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    final token = await _storage.read(key: "auth_token");

    // Default headers
    final finalHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Add Bearer token
      ...?headers,
    };

    log("Request URL: $url");
    log("Request Method: $method");
    log("Request Headers: $finalHeaders");
    log("Request Body: ${jsonEncode(body)}");

    http.Response response;

    try {
      switch (method) {
        case HttpMethod.POST:
          response = await http.post(
            url,
            body: body != null ? jsonEncode(body) : null,
            headers: finalHeaders,
          );
          break;
        case HttpMethod.GET:
          response = await http.get(url, headers: finalHeaders);
          break;
        case HttpMethod.PUT:
          response = await http.put(
            url,
            body: body != null ? jsonEncode(body) : null,
            headers: finalHeaders,
          );
          break;
        case HttpMethod.DELETE:
          response = await http.delete(url, headers: finalHeaders);
          break;
      }
    } catch (e) {
      log("HTTP Request Failed: $e");
      throw Exception("Network error occurred");
    }

    log("Response Status: ${response.statusCode}");
    log("Response Body: ${response.body}");

    return response;
  }
}
