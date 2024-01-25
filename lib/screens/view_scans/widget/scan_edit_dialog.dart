// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../_core/notification_utils.dart';
import '../../../_model/attendee_model.dart';
import '../../../_model/event_model.dart';
import '../../../_model/scan.dart';

class ScanEditDialog extends StatelessWidget {
  final AttendeeModel attendee;
  final EventModel event;
  final Scan scan;

  const ScanEditDialog({
    super.key,
    required this.attendee,
    required this.event,
    required this.scan,
  });

  @override
  Widget build(BuildContext context) {
    var inTime = scan.inPunchTime ?? event.startTime;
    var outTime = scan.outPunchTime ?? scan.inPunchTime ?? event.endTime;

    final isMultiDay =
        DateUtils.isSameDay(event.startTime, event.endTime) == false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Attendance",
                style: Get.textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Text(
                '${attendee.lastName}, ${attendee.firstName}',
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${attendee.emailId}',
                style: Get.textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Check In Time"),
                        TextButton(
                          onPressed: () async {
                            final dateTime = await pickTime(context, inTime);

                            if (dateTime == null) return;

                            if (dateTime.isBefore(event.startTime) ||
                                dateTime.isAfter(event.endTime)) {
                              NotificationUtils.showErrorSnackBar(
                                message:
                                    "Check in time should be between event start and end time",
                              );
                            } else if (outTime.isBefore(dateTime)) {
                              NotificationUtils.showErrorSnackBar(
                                message:
                                    "Check in time should be before check out time",
                              );
                            } else {
                              setState(() {
                                inTime = dateTime;
                              });
                            }
                          },
                          child: Text(
                            DateFormat.jm().format(inTime.toLocal()),
                            style: Get.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (event.allowCheckouts ?? false) ...[
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Check Out Time"),
                          TextButton(
                            onPressed: () async {
                              final dateTime = await pickTime(context, outTime);

                              if (dateTime == null) return;

                              if (dateTime.isBefore(event.startTime) ||
                                  dateTime.isAfter(event.endTime)) {
                                NotificationUtils.showErrorSnackBar(
                                  message:
                                      "Check out time should be between event start and end time",
                                );
                              } else if (dateTime.isBefore(inTime)) {
                                NotificationUtils.showErrorSnackBar(
                                  message:
                                      "Check out time should be after check in time",
                                );
                              } else {
                                setState(() {
                                  outTime = dateTime;
                                });
                              }
                            },
                            child: Text(
                              DateFormat.jm().format(outTime.toLocal()),
                              style: Get.textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          contentPadding:
              const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 20),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 60),
            TextButton(
              onPressed: () {
                scan.inPunchTime = inTime.toUtc();

                if (event.allowCheckouts ?? false) {
                  scan.outPunchTime = outTime.toUtc();
                }

                Get.back(result: scan);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> pickTime(
    BuildContext context,
    DateTime initialTime,
  ) async {
    DateTime? tempDate = initialTime.copyWith();

    if (DateUtils.isSameDay(event.startTime, event.endTime) == false) {
      tempDate = await showDatePicker(
        context: context,
        initialDate: initialTime.toLocal(),
        firstDate: event.startTime.toLocal(),
        lastDate: event.endTime.toLocal(),
      );

      if (tempDate == null) {
        return null;
      }
    }

    final pickedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime.toLocal()),
    );

    if (pickedTimeOfDay != null) {
      return DateTime(
        tempDate.year,
        tempDate.month,
        tempDate.day,
        pickedTimeOfDay.hour,
        pickedTimeOfDay.minute,
      );
    }

    return null;
  }
}
