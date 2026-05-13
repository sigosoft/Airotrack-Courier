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
import '../models/allocation_preview_response.dart';
import '../models/speed_governor_response.dart';

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
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          try {
            if (Hive.isBoxOpen('userBox')) {
              final box = Hive.box('userBox');
              final token = box.get('token');
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          } catch (e) {
            debugPrint("Interceptor storage error: $e");
          }
          return handler.next(options);
        },
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

  // Camera & Speed Governor Methods
  Future<bool> postDeviceDetails({
    required int userType,
    required int userId,
    required int deviceType,
    String? serialNo,
    String? cameraName,
    String? speedGovernorId,
    required String amount,
  }) async {
    try {
      Map<String, dynamic> data = {
        "user_type": userType,
        "user_id": userId,
        "device_type": deviceType,
        "amount": amount,
      };

      if (deviceType == 1) {
        data["serial_no"] = serialNo;
        data["camera_name"] = cameraName;
      } else if (deviceType == 2) {
        data["speed_governor_id"] = speedGovernorId;
        data["serial_no"] = serialNo;
      }

      FormData formData = FormData.fromMap(data);

      Response response = await _dio.post(
        ApiConstants.cameraSpeedGovernorTemporaryStorage,
        data: formData,
      );

      bool status = response.data['status'] is bool
          ? response.data['status']
          : response.data['status']?.toString() == "true";

      return response.statusCode == 200 && status;
    } catch (e) {
      debugPrint("Error storing device details: $e");
      return false;
    }
  }

  Future<AllocationPreviewResponse?> getAllocationPreview({
    required int userId,
    required int userType,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_type": userType,
        "user_id": userId,
      });

      Response response = await _dio.post(
        ApiConstants.cameraSpeedGovernorPreview,
        data: formData,
      );

      if (response.statusCode == 200) {
        return AllocationPreviewResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching allocation preview: $e");
      return null;
    }
  }

  Future<SpeedGovernorResponse?> getSpeedGovernors() async {
    try {
      Response response = await _dio.get(ApiConstants.speedGovernors);

      if (response.statusCode == 200) {
        return SpeedGovernorResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching speed governors: $e");
      rethrow;
    }
  }

  // GPS Methods
  Future<Map<String, dynamic>?> setGpsTemporaryStorage({
    required String userType,
    required String userId,
    required String imei,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_type": userType,
        "user_id": userId,
        "imei": imei,
      });
      Response response = await _dio.post(
        ApiConstants.gpsTemporaryStorage,
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getGpsPreview({
    required String userType,
    required String userId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_type": userType,
        "user_id": userId,
      });
      Response response = await _dio.post(
        ApiConstants.gpsPreview,
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> deleteTemporaryStorage() async {
    try {
      FormData formData = FormData.fromMap({});
      Response response = await _dio.post(
        ApiConstants.deleteTemporaryStorage,
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> gpsAllocate({
    required String userType,
    required String userId,
    required String reallocate,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_type": userType,
        "user_id": userId,
        "reallocate": reallocate,
      });
      Response response = await _dio.post(
        ApiConstants.gpsAllocate,
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
