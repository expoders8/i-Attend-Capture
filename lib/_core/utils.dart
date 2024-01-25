// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:i_attend_capture/_core/dio_errors.dart';
import 'package:i_attend_capture/_core/notification_utils.dart';

import '../screens/settings/_widget/login_dialog.dart';

Future<void> handleDioError(
  dynamic e, {
  Future<dynamic> Function()? onReAuthenticated,
}) async {
  if (e is UnauthorizedDioError) {
    if (await Get.dialog(LoginDialog()) == true) {
      unawaited(onReAuthenticated?.call());
    }
  } else {
    NotificationUtils.showErrorSnackBar(message: e.toString());
  }
}

String generateLocalRef() =>
    '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';
