import 'package:dio/dio.dart';

class ApiEndPoints {
  static const String settings = 'https://api.yourdomain.com/settings'; // Dummy URL
}

class DioClient {
  final Dio _dio = Dio();

  Future<Response> get(String url) async {
    try {
      // For now, if we don't have the real endpoint, we can return a mock or just make a request.
      // But since we want it to compile and run without hanging if URL is bad,
      // I'll leave the real Dio request. The user can swap the domain out later.
      return await _dio.get(url);
    } catch (e) {
      // Mocking response to avoid crashing if domain doesn't exist
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'status': false},
        statusCode: 200,
      );
    }
  }
}
