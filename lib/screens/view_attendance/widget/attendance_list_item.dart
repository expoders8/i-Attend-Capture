// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../_core/color_constants.dart';
import '../../../_core/constants.dart';
import '../../../_model/attendance_model.dart';
import '../../../_model/event_model.dart';
import '../../../_model/scan.dart';

class AttendanceListItem extends StatelessWidget {
  final AttendanceModel attendance;
  final EventModel event;
  final Function(num attendeeId, num schedule)? onTap;

  const AttendanceListItem({
    super.key,
    required this.attendance,
    this.onTap,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final Scan? lastScan = attendance.lastScan;
    final bool isCheckIn = attendance.isCheckIn ?? false;
    final DateTime lastCheckTime =
        lastScan?.outPunchTime ?? lastScan?.inPunchTime ?? event.startTime;

    final isScanSyncError =
        attendance.scans?.any((scan) => scan.error?.isNotEmpty ?? false) ??
            false;

    return InkWell(
      onTap: () {
        if ((attendance.scans ?? []).isNotEmpty) {
          onTap?.call(attendance.attendeeId ?? 0, attendance.scheduleId ?? 0);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${attendance.lastName}, ${attendance.firstName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 20.0),
                    const SizedBox(width: 10),
                    Text(kDateTimeFormat.format(lastCheckTime.toLocal()))
                  ],
                ),
                FaIcon(
                  attendance.isSynced
                      ? FontAwesomeIcons.checkDouble
                      : Icons.check,
                  color: attendance.isSynced ? Colors.lightGreen : Colors.grey,
                ),
              ],
            ),
            if (lastScan != null) ...[
              const SizedBox(height: 10),
              Text(
                lastScan.outPunchTime == null ? 'Checked-In' : 'Checked-Out',
                style: TextStyle(
                  fontSize: 16,
                  color: lastScan.outPunchTime == null
                      ? colorCheckedIn
                      : colorCheckedOut,
                ),
              ),
            ],
            if (isScanSyncError || (attendance.isDeleted)) ...[
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
