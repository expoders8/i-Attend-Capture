// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/color_constants.dart';
import '../../../_core/constants.dart';
import '../../../_model/attendance_model.dart';
import '../../../_model/scan.dart';

class RecentAttendanceListItem extends StatelessWidget {
  final AttendanceModel attendance;
  final Function(num eventId, num schedule)? onTap;

  const RecentAttendanceListItem({
    super.key,
    required this.attendance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Scan? lastScan = attendance.lastScan;
    final bool isCheckIn = attendance.isCheckIn ?? false;
    final DateTime? lastCheckTime =
        lastScan?.outPunchTime ?? lastScan?.inPunchTime;

    final isScanSyncError =
        attendance.scans?.any((scan) => scan.error?.isNotEmpty ?? false) ??
            false;

    return InkWell(
      onTap: () {
        if ((attendance.scans ?? []).isNotEmpty) {
          onTap?.call(attendance.eventId ?? 0, attendance.scheduleId ?? 0);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${attendance.lastName}, ${attendance.firstName}',
                  style: Get.textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  attendance.attendee?.emailId ?? '-',
                  style: Get.textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 4),
                Text(
                  kDateTimeFormat.format(lastCheckTime!.toLocal()),
                  style: Get.textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  isCheckIn ? 'Checked-In' : 'Checked-Out',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: isCheckIn ? colorCheckedIn : colorCheckedOut,
                  ),
                ),
              ],
            ),
            if (lastScan != null) ...[
              const SizedBox(height: 10),
            ],
            if (isScanSyncError || attendance.isDeleted) ...[
              const SizedBox(height: 10),
              Text(
                isScanSyncError
                    ? 'There are some errors while syncing Attendance'
                    : 'Deleted but waiting for sync',
                style: TextStyle(
                  fontSize: 16,
                  color: isScanSyncError
                      ? colorSyncErrorText
                      : colorDeletedNotSynced,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
