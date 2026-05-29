import 'dart:convert';
import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic e) {
    String errorMessage = "Something went wrong. Please try again later.";
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return "Connection timed out. Please check your network speed.";
      } else if (e.type == DioExceptionType.connectionError) {
        return "No internet connection or server unreachable.";
      } else if (e.type == DioExceptionType.badCertificate) {
        return "Security certificate error. Please check your system date/time.";
      } else {
        final data = e.response?.data;
        if (data != null) {
          dynamic responseMap;
          if (data is Map) {
            responseMap = data;
          } else if (data is String) {
            try {
              responseMap = jsonDecode(data);
            } catch (_) {}
          }
          
          if (responseMap is Map && responseMap['message'] != null) {
            var msg = responseMap['message'];
            if (msg is String) {
              return msg;
            } else if (msg is Map && msg.isNotEmpty) {
              var firstError = msg.values.first;
              return (firstError is List && firstError.isNotEmpty)
                  ? firstError.first.toString()
                  : firstError.toString();
            } else {
              return msg.toString();
            }
          }
        }
        return "Server error. Please try again later.";
      }
    }
    return errorMessage;
  }
}
