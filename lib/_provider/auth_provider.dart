// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../_core/dio_client.dart';
import '../_core/logger.dart';
import '../_core/preference_utils.dart';
import '../_model/sign_in_response_model.dart';
import '../_state/app_service.dart';

class AuthProvider extends DioClient {
  static AuthProvider get X => Get.find();

  Future<SignInResponseModel> signIn(
    String organizationId,
    String username,
    String password,
    String fcmToken,
  ) async {
    final Codec<String, String> stringToBase64 = utf8.fuse(base64);

    final String encoded =
        stringToBase64.encode("$organizationId:$username:$password");

    try {
      final result = await post(
        '${AppService.X.baseUrl}/Api/User/Login?fcmRegId=$fcmToken',
        options: Options(
          headers: {
            "Authorization": "Basic $encoded",
          },
        ),
      );

      await PreferenceUtils.setToken(result.headers['token']?.first.toString());

      return SignInResponseModel.fromJson(result.data as Map<String, dynamic>);
    } on DioError catch (e) {
      if (e.response != null) {
        logger.i(
          "signInResponseError: ${json.decode(e.response.toString())['message']}",
        );

        return SignInResponseModel(
          isError: true,
          errorMessage: "${json.decode(e.response.toString())['message']}",
        );
      } else {
        return SignInResponseModel(isError: true, errorMessage: e.message);
      }
    }
  }
}
