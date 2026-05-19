import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.post(
      'https://dev-api.airotrack.in/airotrack-api/public/courier/deleteTemporaryStorage',
      data: FormData.fromMap({
        'user_type': '2',
        'user_id': '1',
      }),
    );
    print(response.data);
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Data: ${e.response?.data}');
  }
}
