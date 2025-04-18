import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/api/end_points.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String id, String password) async {
    final response = await _dio.post(
      EndPoints.login,
      data: {
        "id": id,
        "password": password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      )
    );

    if (response.statusCode == 200 &&
        response.data['message'] == 'success') {
      final token = response.data['data']['token'];
      await _secureStorage.write(key: 'accessToken', value: token);
      return true;
    } else {
      print("로그인 실패: ${response.data}");
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'accessToken');
  }
}

/* 인스턴스에 인증 토큰 추가 로직 */
// void setupDioWithInterceptor(Dio dio) {
//   dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final token = await FlutterSecureStorage().read(key: 'accessToken');
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//     ),
//   );
// }
