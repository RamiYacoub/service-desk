import 'package:dio/dio.dart';

class ApiClient {
  static const baseUrl = 'http://10.0.2.2:8080';

  static Dio build() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
