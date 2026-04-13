import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../config/api_constants.dart';
import '../models/login_response.dart';
import '../models/dealers_response.dart';
import '../models/technicians_response.dart';
import '../models/contact_us_response.dart';
import '../models/privacy_policy_response.dart';
import '../models/terms_and_conditions_response.dart';
import '../models/about_us_response.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final box = Hive.box('userBox');
          final token = box.get('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  Future<LoginResponse?> login(String username, String password) async {
    try {
      FormData formData = FormData.fromMap({
        "username": username,
        "password": password,
      });

      Response response = await _dio.post(ApiConstants.login, data: formData);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DealersResponse?> getDealers({String keyword = ""}) async {
    try {
      Response response = await _dio.get(
        ApiConstants.dealers,
        queryParameters: {"keyword": keyword},
      );

      if (response.statusCode == 200) {
        return DealersResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TechniciansResponse?> getTechnicians({String keyword = ""}) async {
    try {
      Response response = await _dio.get(
        ApiConstants.technicians,
        queryParameters: {"keyword": keyword},
      );

      if (response.statusCode == 200) {
        return TechniciansResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ContactUsResponse?> getContactUs() async {
    try {
      Response response = await _dio.get(ApiConstants.contactUs);

      if (response.statusCode == 200) {
        return ContactUsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivacyPolicyResponse?> getPrivacyPolicy() async {
    try {
      Response response = await _dio.get(ApiConstants.privacyPolicy);

      if (response.statusCode == 200) {
        return PrivacyPolicyResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TermsAndConditionsResponse?> getTermsAndConditions() async {
    try {
      Response response = await _dio.get(ApiConstants.termsAndConditions);

      if (response.statusCode == 200) {
        return TermsAndConditionsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AboutUsResponse?> getAboutUs() async {
    try {
      Response response = await _dio.get(ApiConstants.aboutUs);

      if (response.statusCode == 200) {
        return AboutUsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
