// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/event_details/event_details.x.dart';
import 'package:i_attend_capture/screens/event_details/widget/event_detail_item.dart';
import 'package:i_attend_capture/screens/event_details/widget/pending_attendance_sync_bar.dart';

import '../../_core/date_formatter.dart';
import '../../_model/event_model.dart';
import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';
import '../../_widgets/bottom_button.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  static final page = GetPage(
    name: '/event_details',
    page: () => const EventDetails(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<EventDetailsX>(
      init: EventDetailsX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF673BB7),
            title: const Text(
              "Event Details",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: const Icon(
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
              PopupMenuButton(
                iconColor: Colors.white,
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      controller.gotoFailedAttendance();
                      break;

                    case 1:
                      controller.gotoPrivateAttendees();
                      break;
                  }
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text("Failed Attendance"),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Registered Participants"),
                    ),
                  ];
                },
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  if (controller.isAnyDataForSync.isTrue) {
                    return PendingAttendanceSyncBar(
                      message:
                          "You have attendance data that needs to be uploaded. Tap here to upload your data.",
                      onTap: () {
                        AttendanceService.X.syncAttendance(
                          eventId: controller.eventModel.value!.eventId!,
                          scheduleId: controller.eventModel.value!.scheduleId!,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                }),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.eventModel.value?.eventName ?? '-',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 20),
                      EventDetailItem(
                        itemTitle: 'Room',
                        itemDescription:
                            controller.eventModel.value?.roomName ?? "-",
                      ),
                      EventDetailItem(
                        itemTitle: 'Instructor',
                        itemDescription:
                            controller.eventModel.value?.instructor ?? "-",
                      ),
                      EventDetailItem(
                        itemTitle: 'Description',
                        itemDescription:
                            controller.eventModel.value?.description ?? "-",
                      ),
                      EventDetailItem(
                        itemTitle: 'Date and time',
                        itemDescription: controller.eventModel.value != null
                            ? getEventFormattedTime(
                                controller.eventModel.value!.startTime,
                                controller.eventModel.value!.endTime,
                              )
                            : '-',
                      ),
                      EventDetailItem(
                        itemTitle: 'Allow Check-out',
                        itemDescription:
                            controller.eventModel.value?.allowCheckouts != null
                                ? (controller
                                            .eventModel.value?.allowCheckouts ??
                                        true)
                                    ? "Yes"
                                    : "No"
                                : "-",
                      ),
                      EventDetailItem(
                        itemTitle: 'Credits',
                        itemDescription:
                            controller.eventModel.value?.points?.toString() ??
                                "-",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(height: 1, thickness: 1),
                if (controller.eventModel.value?.status !=
                    EventActiveStatus.futureEvent)
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: BottomButton(
                            title: 'VIEW ATTENDANCE',
                            onTap: controller.gotoViewAttendancePage,
                          ),
                        ),
                        if (controller.eventModel.value?.status ==
                            EventActiveStatus.futureEvent)
                          Expanded(
                            child: BottomButton(
                              title: 'CAPTURE ATTENDANCE',
                              onTap: controller.gotoViewAttendancePage,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
