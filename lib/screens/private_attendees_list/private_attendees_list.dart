// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/private_attendees_list/private_attendees_list.x.dart';

import '../../_state/sync_service.dart';
import '../event_list/event_list.dart';
import '../participant_list/widget/attendee_list_item.dart';

class PrivateAttendeesList extends StatelessWidget {
  const PrivateAttendeesList({super.key});

  static final page = GetPage(
    name: '/private_attendees_list',
    page: () => const PrivateAttendeesList(),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivateAttendeesListX>(
      init: PrivateAttendeesListX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("View Attendance"),
            actions: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: SyncService.X.sync,
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Get.offAllNamed(EventList.page.name);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Obx(() => Text('Count: ${controller.attendees.length}')),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16),
                    child: controller.attendees.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.attendees.length,
                            itemBuilder: (context, index) => AttendeeListItem(
                              attendee: controller.attendees[index],
                            ),
                          )
                        : Center(
                            child: Text(
                              "There are no private attendees for this event.",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.titleMedium,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
