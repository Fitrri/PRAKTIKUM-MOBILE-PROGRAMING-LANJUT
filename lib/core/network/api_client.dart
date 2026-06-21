import 'package:dio/dio.dart'; // Pastikan pakai pakai .dart di ujungnya! 
import '../config/env_config.dart'; // Import config [cite: 100]

class ApiClient {
  final Dio _dio; // Membaca tipe data Dio dari package dio.dart [cite: 102]

 ApiClient() : _dio = Dio(
    BaseOptions(
      // Jika di terminal lupa ketik '/' di ujung URL, kode ini akan menambahkannya otomatis
      baseUrl: EnvConfig.baseUrl.endsWith('/') 
          ? EnvConfig.baseUrl 
          : '${EnvConfig.baseUrl}/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      rethrow;
    }
  }
}