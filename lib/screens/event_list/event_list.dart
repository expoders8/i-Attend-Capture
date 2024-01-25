// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/event_list/event_list.x.dart';
import 'package:i_attend_capture/screens/event_list/widget/date_selection_bar.dart';
import 'package:i_attend_capture/screens/event_list/widget/event_list_item.dart';

import '../../_core/preference_utils.dart';
import '../../_state/attendance_service.dart';
import '../../_state/sync_service.dart';
import '../event_details/widget/pending_attendance_sync_bar.dart';

class EventList extends StatelessWidget {
  EventList({super.key});

  static final page = GetPage(
    name: '/event_list',
    page: () => EventList(),
  );

  final _menu = <int, String>{
    1: "Settings",
    2: "Logout",
  };

  ScheduledTask? scheduledTask;
  final cron = Cron();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventListX>(
      init: EventListX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF673BB7),
            title: const Text(
              "i-Attend CAPTURE",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            actions: [
              if (!DateUtils.isSameDay(
                controller.selectedDay.value,
                DateTime.now(),
              ))
                IconButton(
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  onPressed: () => controller.setSelectedDate(
                    DateTime.now(),
                  ),
                ),
              IconButton(
                icon: const Icon(
                  Icons.sync,
                  color: Colors.white,
                ),
                onPressed: controller.syncEvents,
              ),
              PopupMenuButton<int>(
                iconColor: Colors.white,
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      controller.gotoSettings();
                      break;
                    case 2:
                      controller.logout();
                      break;
                  }
                },
                itemBuilder: (_) => _menu.entries
                    .map(
                      (e) => PopupMenuItem<int>(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
          body: Column(
            children: [
              DateSelectionBar(),
              Obx(
                () => Expanded(
                  child: controller.eventList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "No events found on this date. Please try another date.",
                              style: Get.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.eventList.length,
                          itemBuilder: (context, index) => EventListItem(
                            model: controller.eventList[index],
                          ),
                          padding: const EdgeInsets.all(8),
                        ),
                ),
              ),
              Obx(() {
                if (SyncService.X.isAnyDataForSync.isTrue) {
                  controller.syncEvents;
                  return PendingAttendanceSyncBar(
                    message:
                        "You have attendance data that needs to be uploaded. Tap here to upload your data.",
                    onTap: () {
                      AttendanceService.X.syncAllPendingAttendance();
                    },
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        );
      },
    );
  }
}
