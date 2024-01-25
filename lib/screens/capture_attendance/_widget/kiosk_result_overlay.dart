// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../_state/attendance_service.dart';

class KioskResultOverlay extends StatelessWidget {
  final MarkAttendanceResult lastResult;

  const KioskResultOverlay({
    super.key,
    required this.lastResult,
  });

  @override
  Widget build(BuildContext context) {
    final checkIn =
        lastResult.scan?.outPunchTime == null ? 'Checked-In' : 'Checked-Out';

    final attendeeName =
        '${lastResult.attendee?.firstName} ${lastResult.attendee?.lastName}';

    final scanTime = lastResult.scan?.recentPunchTime ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      color: lastResult.success == true
          ? const Color(0Xd0009900)
          : const Color(0XaaFF0000),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lastResult.success == false)
              Text(
                lastResult.message ?? "",
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            if (lastResult.success == true) ...[
              Text(
                'Hi,',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                attendeeName,
                style: Get.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have\n$checkIn Successfully\nat',
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${DateFormat.jm().format(
                  scanTime,
                )}\n${DateFormat.MMMMEEEEd().format(
                  scanTime,
                )}',
                textAlign: TextAlign.center,
                style: Get.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
