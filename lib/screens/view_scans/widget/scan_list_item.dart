// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../_model/attendance_model.dart';
import '../../../_model/attendee_model.dart';
import '../../../_model/event_model.dart';
import '../../../_model/scan.dart';

class ScanListItem extends StatelessWidget {
  final Scan scan;
  final AttendanceModel attendance;
  final EventModel event;
  final AttendeeModel attendee;
  final Function(EventModel event, AttendeeModel attendee, Scan scan)?
      onDeleteTap;
  final Function(EventModel event, AttendeeModel attendee, Scan scan)?
      onEditTap;

  const ScanListItem({
    super.key,
    required this.scan,
    this.onDeleteTap,
    this.onEditTap,
    required this.event,
    required this.attendance,
    required this.attendee,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(
          AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Edit"),
                  onTap: () {
                    Get.back();
                    onEditTap?.call(event, attendee, scan);
                  },
                ),
                if (scan.isSynced == false)
                  ListTile(
                    title: const Text("Delete"),
                    onTap: () {
                      Get.back();
                      onDeleteTap?.call(event, attendee, scan);
                    },
                  )
              ],
            ),
          ),
        );
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
                  attendee.emailId ?? "-",
                  style: Get.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.clock, size: 16.0),
                const SizedBox(width: 10),
                Text(
                  DateFormat.yMMMEd().format(event.startTime.toLocal()),
                  style: Get.textTheme.titleMedium,
                ),
                const Spacer(),
                FaIcon(
                  scan.isSynced ? FontAwesomeIcons.checkDouble : Icons.check,
                  color: scan.isSynced ? Colors.lightGreen : Colors.grey,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Check-In: ${scan.inPunchTime != null ? DateFormat.jm().format(scan.inPunchTime!.toLocal()) : "N/A"}",
                  style: Get.textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  "Check-Out: ${scan.outPunchTime != null ? DateFormat.jm().format(scan.outPunchTime!.toLocal()) : "N/A"}",
                  style: Get.textTheme.titleMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
