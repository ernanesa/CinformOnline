import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://cinformonline.com.br/wp-json/wp/v2',
      connectTimeout: 5000, // 5 seconds in milliseconds
      receiveTimeout: 5000, // 5 seconds in milliseconds
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    if (!await _isOnline()) {
      throw Exception('Sem conexão com a internet');
    }
  }

  Future<bool> _isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await _isOnline()) {
      throw Exception('Sem conexão com a internet');
    }
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
