// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/capture_attendance/capture_attendance.x.dart';

import '../../_model/attendee_model.dart';
import '../../_state/app_service.dart';
import '../../_state/sync_service.dart';
import '../../_widgets/bottom_button.dart';
import '../view_attendance/widget/event_info_tile.dart';
import '_widget/attendance_search_auto_complete.dart';
import '_widget/recent_attendance_list_item.dart';

class CaptureAttendance extends StatelessWidget {
  const CaptureAttendance({super.key});

  static final page = GetPage(
    name: '/capture_attendance',
    page: () => const CaptureAttendance(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<CaptureAttendanceX>(
      init: CaptureAttendanceX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF673BB7),
            title: const Text(
              "Capture Attendance",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
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
                  Icons.info_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.toggleEventInfoCardVisibility();
                },
              ),
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.white),
                onPressed: SyncService.X.sync,
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: AppService.X.gotoHome,
              ),
              PopupMenuButton<num>(
                iconColor: Colors.white,
                onSelected: (value) {
                  debugPrint("Selected: $value");
                  controller.gotoKioskMode();
                },
                itemBuilder: (BuildContext bc) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text("Kiosk Mode"),
                  ),
                ],
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.eventModel.value != null &&
                  controller.eventShortDetailCardVisibility.isTrue)
                EventInfoTile(
                  eventModel: controller.eventModel.value!,
                  subTitle:
                      "Capturing ${controller.isCheckIn.isTrue ? 'Check In' : 'Check Out'}",
                ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: AttendanceSearchAutocomplete(
                        focusNode: controller.attendeeSearchTextFocusNode,
                        textEditingController:
                            controller.attendeeSearchTextEditingController,
                        hintText: "Enter Badge ID or Last Name",
                        displayStringForOption: (AttendeeModel option) =>
                            '${option.lastName}, ${option.firstName}',
                        onFieldSubmitted: controller.handleEnterEvent,
                        optionsBuilder: (TextEditingValue value) {
                          // When the field is empty
                          if (value.text.isEmpty) {
                            return [];
                          }

                          // The logic to find out which ones should appear
                          return controller.getAttendees(value.text);
                        },
                        onSelected: (attendee) =>
                            controller.handleAttendeeSelection(attendee),
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      indent: 4,
                      endIndent: 4,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: controller.gotoQrScanner,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              Expanded(
                child: controller.attendanceList.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.attendanceList.length,
                        itemBuilder: (context, index) =>
                            RecentAttendanceListItem(
                          attendance:
                              controller.attendanceList.elementAt(index),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "Scan Badge ID or type Last Name to capture attendance.",
                            style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: BottomButton(
                        title: 'CHECK-IN',
                        onTap: controller.isCheckIn.toggle,
                        textColor: controller.isCheckIn.isTrue
                            ? Colors.black
                            : Colors.grey,
                        backgroundColor: controller.isCheckIn.isTrue
                            ? Colors.lightGreen
                            : Colors.white,
                      ),
                    ),
                    if (controller.eventModel.value?.allowCheckouts ??
                        false) ...[
                      Expanded(
                        child: BottomButton(
                          title: 'CHECK-OUT',
                          onTap: controller.isCheckIn.toggle,
                          textColor: controller.isCheckIn.isFalse
                              ? Colors.black
                              : Colors.grey,
                          backgroundColor: controller.isCheckIn.isFalse
                              ? Colors.lightGreen
                              : Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text(
            'A dialog is a type of modal window that\n'
            'appears in front of app content to\n'
            'provide critical information, or prompt\n'
            'for a decision to be made.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
