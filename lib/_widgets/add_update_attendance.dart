// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../_core/logger.dart';

void addUpdateAttendance(
  String titleText,
  String attendeeName,
  String attendeeEmail,
  String time,
) =>
    Get.dialog(
      AlertDialog(
        title: Text(
          titleText,
          style: const TextStyle(color: Colors.blue),
        ),
        content: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendeeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.mail_outline,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(attendeeEmail),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Check In Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        final TimeOfDay initialTime = TimeOfDay.now();
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: Get.context!,
                          initialTime: initialTime,
                        );
                        if (pickedTime != null) {
                          logger.i(pickedTime.format(Get.context!));
                        }
                      },
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text("Ok"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
