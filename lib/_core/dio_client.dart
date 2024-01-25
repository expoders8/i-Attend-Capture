// ignore_for_file: public_member_api_docs, parameter_assignments

import 'package:dio/dio.dart';
import 'package:i_attend_capture/_core/dio_interceptor.dart';

import '../_state/app_service.dart';

class DioClient {
  final Dio _client = Dio();

  DioClient() {
    _client
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json
      ..interceptors.add(DioInterceptor())
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
  }

  Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
    bool showErrorOnOffline = true,
  }) {
    _handleNetwork(showErrorOnOffline);

    return _client.get(url, queryParameters: query);
  }

  Future<Response<dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    bool showErrorOnOffline = true,
  }) {
    _handleNetwork(showErrorOnOffline);

    return _client.post(
      url,
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  Future<Response<dynamic>> put(
    String url, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? query,
    bool showErrorOnOffline = true,
  }) {
    _handleNetwork(showErrorOnOffline);

    return _client.put(
      url,
      data: data,
      options: options,
      queryParameters: query,
    );
  }

  Future<Response<dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    bool showErrorOnOffline = true,
  }) {
    _handleNetwork(showErrorOnOffline);

    return _client.delete(
      url,
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  void _handleNetwork(bool showErrorOnOffline) {
    if (!AppService.X.isOnline) {
      // if (showErrorOnOffline) {
      //   NotificationUtils.showAlert(
      //     title: "No Internet Connection",
      //     content: "Make sure your device is connected to internet.",
      //   );
      // }
      if (showErrorOnOffline) {
        throw "You are offline. Please check your internet connection.";
      }
    }
  }
}
