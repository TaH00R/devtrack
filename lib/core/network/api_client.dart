import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class ApiClient {
  late final Dio dio;

  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.1.2.146:6967',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
  }
}