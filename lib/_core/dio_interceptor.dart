// ignore_for_file: public_member_api_docs

import 'package:dio/dio.dart';
import 'package:i_attend_capture/_core/dio_errors.dart';
import 'package:i_attend_capture/_core/logger.dart';
import 'package:i_attend_capture/_core/preference_utils.dart';

class DioInterceptor extends QueuedInterceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger.i("Request[${options.method}] => PATH: ${options.path}");

    options.headers.putIfAbsent('token', () => PreferenceUtils.getToken());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger.i("Response Status Code: [${response.statusCode}]");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.connectionTimeout) {
      throw TimeoutDioError();
    } else if (err.type == DioErrorType.badResponse) {
      switch (err.response?.statusCode) {
        case 401:
          super.onError(UnauthorizedDioError(), handler);
          break;
        // case 403:
        //   throw ForbiddenException();
        // case 404:
        //   throw NotFoundException();
        // case 500:
        //   throw InternalServerError(message: err.message);
        default:
          super.onError(err, handler);
          break;
      }
    } else {
      super.onError(err, handler);
    }
  }
}
