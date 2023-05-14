import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/providers/token_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.ref);
  late Ref ref;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // create a list of the endpoints where you don't need to pass a token.
    final listOfPaths = <String>[];

    // Check if the requested endpoint match in the
    if (listOfPaths.contains(options.path.toString())) {
      // if the endpoint is matched then skip adding the token.
      return handler.next(options);
    }

    // Load your token here and pass to the header
    // var token = authController.isLoggedIn.value
    //     ? authController.token.value.toString()
    //     : null;
    // ignore: prefer_typing_uninitialized_variables
    var token = ref.read(tokenProvider);

    if (token != null) {
      options.headers.addAll({'Authorization': "Bearer $token"});
    }

    options.headers.addAll({'Test-token': "Test token"});

    return handler.next(options);
  }

  // You can also perform some actions in the response or onError.
  @override
  void onResponse(response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("err=================");
      print(err);
      print(err.response?.statusCode);
    }

    if (err.response?.statusCode == 401) {
      // authController.setLogoutValues();

      // Get.toNamed(homePage);
      return handler.next(err);
    }

    return handler.next(err);
  }
}
