import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.virgincodes.com/api', // Kept as base, but intercepted
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Add Mock Interceptor
    // dio.interceptors.add(MockInterceptor());
    
    // Add Log Interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}
