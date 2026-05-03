import 'dart:io';

import 'package:vexana/vexana.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.onUnauthorized});

  final void Function() onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
