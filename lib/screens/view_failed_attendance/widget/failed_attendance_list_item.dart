// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../_model/event_model.dart';
import '../../../_model/failed_attendance_model.dart';

class FailedAttendanceListItem extends StatelessWidget {
  final FailedAttendanceModel attendance;
  final EventModel event;

  const FailedAttendanceListItem({
    super.key,
    required this.attendance,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                attendance.failId == FailedAttendanceReasonId.invalidBadgeId
                    ? 'Unknown'
                    : '${attendance.lastName}, ${attendance.firstName}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              Text(
                '${attendance.badgeId}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${attendance.failReason}',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(attendance.scanTime.toString()),
              FaIcon(
                attendance.isSynced ?? false
                    ? FontAwesomeIcons.checkDouble
                    : Icons.check,
                color: attendance.isSynced ?? false
                    ? Colors.lightGreen
                    : Colors.grey,
              ),
            ],
          ),
          // if (lastScan != null) ...[
          //   const SizedBox(height: 10),
          //   Text(
          //     isCheckIn ? 'Checked-In' : 'Checked-Out',
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: isCheckIn ? colorCheckedIn : colorCheckedOut,
          //     ),
          //   ),
          // ],
          // if (isScanSyncError || (attendance.isDeleted)) ...[
          //   const SizedBox(height: 10),
          //   Text(
          //     isScanSyncError
          //         ? 'There are some errors while syncing Attendance'
          //         : 'Deleted but waiting for sync',
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: isScanSyncError
          //           ? colorSyncErrorText
          //           : colorDeletedNotSynced,
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}
