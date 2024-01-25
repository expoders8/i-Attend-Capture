// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationUtils {
  static SnackbarController showSuccessSnackBar({
    String? title,
    required String message,
  }) =>
      Get.rawSnackbar(
        title: title,
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        snackStyle: SnackStyle.GROUNDED,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: Duration.zero,
      );

  static SnackbarController showErrorSnackBar({
    String? title,
    String? message = "Something went wrong",
  }) =>
      Get.rawSnackbar(
        title: title,
        message: message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        snackStyle: SnackStyle.GROUNDED,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: Duration.zero,
        // forwardAnimationCurve: Curves.easeIn,
      );

  static Future<dynamic> showSimpleAlert(
    String title, {
    String? message,
    String confirmText = 'Ok',
    Function()? onConfirm,
  }) =>
      Get.dialog(
        AlertDialog(
          title: Text(title),
          content: message == null ? null : Text(message),
          actions: [
            TextButton(
              onPressed: onConfirm ?? () => Get.back(),
              child: Text(confirmText),
            )
          ],
        ),
      );

  static Future<dynamic> showAlert({
    String? title,
    required String content,
    String btnPositive = 'Ok',
    Function()? btnPositiveCallback,
    String? btnNegative,
    Function()? btnNegativeCallback,
  }) {
    return Get.dialog(
      AlertDialog(
        title: title == null ? null : Text(title),
        contentPadding: const EdgeInsets.all(16.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(content, style: Get.textTheme.bodyMedium),
        ),
        buttonPadding: const EdgeInsets.all(10),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: <Widget>[
          if (btnNegative != null)
            TextButton(
              onPressed: btnNegativeCallback ?? () => Get.back(result: false),
              child: Text(btnNegative),
            ),
          TextButton(
            onPressed: btnPositiveCallback ?? () => Get.back(result: true),
            child: Text(btnPositive),
          )
        ],
      ),
    );
  }
}
