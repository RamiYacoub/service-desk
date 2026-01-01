import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<String> login(String email, String password) async {
    final res = await dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );

    return res.data['accessToken'] as String;
  }
}
