import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/color_constants.dart';
import '../../../_core/date_formatter.dart';
import '../../../_core/logger.dart';
import '../../../_model/event_model.dart';
import '../../capture_attendance/capture_attendance.dart';
import '../../event_details/event_details.dart';
import '../../view_attendance/view_attendance.dart';

///
class EventListItem extends StatelessWidget {
  final EventModel _event;

  ///
  const EventListItem({super.key, required EventModel model}) : _event = model;

  @override
  Widget build(BuildContext context) {
    final eventActiveStatus = _event.status;

    return Card(
      color: getEventBackgroundColor(eventActiveStatus),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.toNamed(
              EventDetails.page.name,
              arguments: _event.scheduleId,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _event.eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                getEventFormattedTime(
                                  _event.startTime,
                                  _event.endTime,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_pin, size: 14),
                            Text(_event.roomName ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      logger.i("clicked");
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: isActionCardVisible(eventActiveStatus),
            child: Container(
              color: Colors.black,
              // decoration: const BoxDecoration(
              //   color: Colors.black,
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(15),
              //     bottomRight: Radius.circular(15),
              //   ),
              // ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  TextButton(
                    style:
                        TextButton.styleFrom(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Get.toNamed(
                        ViewAttendance.page.name,
                        arguments: _event.scheduleId,
                      );
                    },
                    child: const Text(
                      "View Attendance",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: isCaptureAttendanceVisible(eventActiveStatus),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        Get.toNamed(
                          CaptureAttendance.page.name,
                          arguments: _event.scheduleId,
                        );
                      },
                      child: const Text(
                        "Capture Attendance",
                        style: TextStyle(
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// following functions are based on event activity status
  /// to set background color to the card
  Color getEventBackgroundColor(EventActiveStatus eventActiveStatus) {
    return eventActiveStatus == EventActiveStatus.pastEvent
        ? colorPastEventCardBackground
        : eventActiveStatus == EventActiveStatus.activeEvent
            ? colorCurrentEventCardBackground
            : colorFutureEventCardBackground;
  }

  /// to set card action visibility
  bool isActionCardVisible(EventActiveStatus eventActiveStatus) =>
      eventActiveStatus == EventActiveStatus.pastEvent ||
      eventActiveStatus == EventActiveStatus.activeEvent;

  /// to set visibility of capture attendance
  bool isCaptureAttendanceVisible(EventActiveStatus eventActiveStatus) =>
      eventActiveStatus == EventActiveStatus.activeEvent;
}
