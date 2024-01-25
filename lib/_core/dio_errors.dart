// ignore_for_file: public_member_api_docs

import 'package:dio/dio.dart';

class UnauthorizedDioError extends DioError {
  @override
  String get message => 'Unauthorized';

  UnauthorizedDioError() : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() => message;
}

class TimeoutDioError extends DioError {
  @override
  String get message => 'TimedOut';

  TimeoutDioError() : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() => message;
}
