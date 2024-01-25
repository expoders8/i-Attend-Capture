// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../_core/notification_utils.dart';
import '../../_core/preference_utils.dart';
import '../../_state/app_service.dart';

class CodeConfigurationX extends GetxController {
  final servicesUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    servicesUrlController.text = PreferenceUtils.getBaseUrl() ?? '';
  }

  void resetConfigCode() => servicesUrlController.text = "";

  Future<void> submit() async {
    try {
      AppService.X.loaderRx(true);

      final servicesUrl = servicesUrlController.text;

      String? baseUrl;

      if (servicesUrl.isNotEmpty) {
        if (!servicesUrl.isURL) {
          NotificationUtils.showErrorSnackBar(
            message: "Invalid URL",
          );

          return;
        }

        baseUrl = servicesUrl;
      }

      await PreferenceUtils.setBaseUrl(baseUrl);

      Get.back(closeOverlays: true);

      NotificationUtils.showSuccessSnackBar(
        message: baseUrl != null
            ? "i-Attend Capture Web Server URL configured!"
            : "i-Attend Capture Web Server URL cleared!",
      );
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {
      AppService.X.loaderRx(false);
    }
  }
}
