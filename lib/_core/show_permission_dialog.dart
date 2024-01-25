// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void showPermissionDialog(String title) => Get.dialog(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          content: Text(
            'i-Attend Capture requires the access to $title',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Get.back();
                openAppSettings();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
