import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = '', this.prefix]);

  @override
  String toString() {
    return '$prefix$message';
  }

  static String handleExceptionMessage(e) {
    switch (e) {
      case SocketException _:
        return "No internet connection!";
      case TimeoutException _:
        return "Request timeout!";
      case HttpException _:
        return "HTTP Exception: ${e.message}";
      case FormatException _:
        return "Data format error: ${e.message}";
      case DioException _:
        return "Dio error: ${e.message}"; // Handles Dio package errors
      case HandshakeException _:
        return "SSL handshake failed!";
      case FileSystemException _:
        return "File system error: ${e.message}";
      case RangeError _:
        return "Range error: ${e.message}";
      case ArgumentError _:
        return "Invalid argument: ${e.message}";
      case UnsupportedError _:
        return "Operation not supported: ${e.message}";
      case StateError _:
        return "State error: ${e.message}";
      default:
        return "Unexpected error: ${e.toString()}";
    }
  }
}
