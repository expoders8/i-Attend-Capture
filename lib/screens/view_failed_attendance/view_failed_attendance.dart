// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/view_failed_attendance/view_failed_attendance.x.dart';
import 'package:i_attend_capture/screens/view_failed_attendance/widget/failed_attendance_list_item.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../_state/app_service.dart';

class ViewFailedAttendance extends StatelessWidget {
  const ViewFailedAttendance({super.key});

  static final page = GetPage(
    name: '/view_failed_attendance',
    page: () => const ViewFailedAttendance(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<ViewFailedAttendanceX>(
      init: ViewFailedAttendanceX(),
      builder: (controller) {
        return VisibilityDetector(
          key: const Key('view_attendance'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction == 1) {
              controller.revalidate();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text("Failed Attendance"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: controller.syncFailedAttendance,
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: AppService.X.gotoHome,
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: controller.attendanceList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            padding: const EdgeInsets.all(8),
                            itemCount: controller.attendanceList.length,
                            itemBuilder: (context, index) =>
                                FailedAttendanceListItem(
                              attendance: controller.attendanceList[index],
                              event: controller.eventModel.value!,
                            ),
                          )
                        : const Center(
                            child: Text("There are no failed attendance"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
