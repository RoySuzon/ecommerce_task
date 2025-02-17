// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ecommerce/core/error/app_exception.dart';
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

    switch (method) {
      case HttpMethod.POST:
        response = await http
            .post(
              url,
              body: body != null ? jsonEncode(body) : null,
              headers: finalHeaders,
            )
            .timeout(Duration(seconds: 30));
        break;
      case HttpMethod.GET:
        response = await http
            .get(url, headers: finalHeaders)
            .timeout(Duration(seconds: 30));
        break;
      case HttpMethod.PUT:
        response = await http
            .put(
              url,
              body: body != null ? jsonEncode(body) : null,
              headers: finalHeaders,
            )
            .timeout(Duration(seconds: 30));
        break;
      case HttpMethod.DELETE:
        response = await http
            .delete(url, headers: finalHeaders)
            .timeout(Duration(seconds: 30));
        break;
    }

    // on SocketException {
    //   throw NoInternetException();
    // } on TimeoutException {
    //   throw RequestTimeoutException();
    // }

    log("Response Status: ${response.statusCode}");
    if (response.statusCode == 200) {
      log("Response Body: ${response.body}");
    } else {
      log("Something went wrong!");
    }

    return response;
  }
}
