import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:grese/constants/urls.dart';
import 'package:grese/providers/dio/auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  Dio dio = Dio(BaseOptions(
    baseUrl: apiURL, headers: {'Accept': 'application/json'},
    // responseType: ResponseType.json
    receiveTimeout: const Duration(milliseconds: 10000), // 10 seconds
    connectTimeout: const Duration(milliseconds: 10000),
    sendTimeout: const Duration(milliseconds: 10000),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref)
  ]);

  return dio;
});
