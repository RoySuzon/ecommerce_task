import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
enum HttpMethod { GET, POST, PUT, DELETE }

class HttpManager {
  // HTTP request method (GET, POST, PUT, DELETE) using Enum
  Future<http.Response> request(
    HttpMethod method, // Use enum for HTTP method
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);

    log("Request URL: $url");
    log("Request Method: $method");
    log("Request Body: ${jsonEncode(body)}");

    http.Response response;

    // Switch case to handle different HTTP methods based on Enum value
    switch (method) {
      case HttpMethod.POST:
        response = await http.post(
          url,
          body: body != null ? jsonEncode(body) : null,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;

      case HttpMethod.GET:
        response = await http.get(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;

      case HttpMethod.PUT:
        response = await http.put(
          url,
          body: body != null ? jsonEncode(body) : null,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;

      case HttpMethod.DELETE:
        response = await http.delete(
          url,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;
    }

    log("Response Status: ${response.statusCode}");
    log("Response Body: ${response.body}");

    return response;
  }
}