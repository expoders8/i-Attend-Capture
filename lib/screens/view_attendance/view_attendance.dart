// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/event_details/widget/pending_attendance_sync_bar.dart';
import 'package:i_attend_capture/screens/view_attendance/view_attendance.x.dart';
import 'package:i_attend_capture/screens/view_attendance/widget/attendance_list_item.dart';
import 'package:i_attend_capture/screens/view_attendance/widget/event_info_tile.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';
import '../../_state/sync_service.dart';

class ViewAttendance extends StatelessWidget {
  const ViewAttendance({super.key});

  static final page = GetPage(
    name: '/view_attendance',
    page: () => const ViewAttendance(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<ViewAttendanceX>(
      init: ViewAttendanceX(),
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
              backgroundColor: Color(0xFF673BB7),
              elevation: 0,
              title: const Text(
                "View Attendance",
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  }),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: AppService.X.gotoHome,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  onPressed: SyncService.X.sync,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: controller.toggleEventInfo,
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.showEventInfo.isTrue &&
                      controller.eventModel.value != null)
                    EventInfoTile(
                      eventModel: controller.eventModel.value!,
                      subTitle:
                          'Attendance Count : ${controller.attendanceList.length}',
                    ),
                  Obx(() {
                    if (controller.isAnyDataForSync.isTrue) {
                      return PendingAttendanceSyncBar(
                        message:
                            "You have attendance data that needs to be uploaded. Tap here to upload your data.",
                        onTap: () {
                          AttendanceService.X.syncAttendance(
                            eventId: controller.eventModel.value!.eventId!,
                            scheduleId:
                                controller.eventModel.value!.scheduleId!,
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  }),
                  Expanded(
                    child: controller.attendanceList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            padding: const EdgeInsets.all(8),
                            itemCount: controller.attendanceList.length,
                            itemBuilder: (context, index) => AttendanceListItem(
                              onTap: controller.onAttendanceTap,
                              attendance: controller.attendanceList[index],
                              event: controller.eventModel.value!,
                            ),
                          )
                        : const Center(
                            child: Text("No attendance found"),
                          ),
                  ),
                  // if (false) ...[
                  //   const Divider(height: 1),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: TextButton(
                  //           onPressed: () => Get.toNamed(
                  //             ManualAttendance.page.name,
                  //             arguments: controller.eventModel.value,
                  //           ),
                  //           child: const Text("MANUAL ATTENDANCE"),
                  //         ),
                  //       )
                  //     ],
                  //   )
                  // ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
