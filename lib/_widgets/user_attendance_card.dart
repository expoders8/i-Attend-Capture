// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:i_attend_capture/_widgets/add_update_attendance.dart';

class UserAttendanceCard extends StatelessWidget {
  const UserAttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            addUpdateAttendance(
              "Add Attendance",
              "Aguilar, Rafael",
              "raguilar@learn4life.org",
              "3:00 AM",
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
                const Text(
                  "Aguilar, Rafael",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
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
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
