// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_state/app_service.dart';

class PendingAttendanceSyncBar extends StatelessWidget {
  final String message;
  final Function() onTap;

  const PendingAttendanceSyncBar({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (AppService.X.isOnline) {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red,
        child: Text(
          !AppService.X.isOnline
              ? "DEVICE IS OFFLINE. Please connect to the Internet to upload attendance data."
              : message,
          style: Get.textTheme.labelLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
