// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_widgets/add_update_attendance.dart';

class UserCheckInCard extends StatelessWidget {
  const UserCheckInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Get.dialog(
              AlertDialog(
                content: const Text("Action"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Edit"),
                    onPressed: () {
                      Get.back();
                      addUpdateAttendance(
                        "Edit Attendance",
                        "Aguilar, Rafael",
                        "raguilar@learn4life.org",
                        "3:00 AM",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      Get.back();
                      Get.dialog(
                        AlertDialog(
                          content: const Text(
                            "Do you really want to delete this Check-In time?",
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1.0, style: BorderStyle.solid),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Aguilar, Rafael",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.mail_outline,
                          size: 20.0,
                        ),
                        SizedBox(width: 10),
                        Text("raguilar@learn4life.org"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.schedule,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("April 20, 2023"),
                      ],
                    ),
                    const Icon(
                      Icons.check,
                      size: 24.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text("Check In:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text("2:30 AM"),
                      ],
                    ),
                    Row(
                      children: const [
                        Text("Check Out:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text("N/A"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
