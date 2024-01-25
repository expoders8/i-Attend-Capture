// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/digital_clock_widget.dart';
import 'package:intl/intl.dart';

import '../../../_model/event_model.dart';

class KioskInfoTile extends StatelessWidget {
  final EventModel eventModel;
  final num attendanceCount;
  final bool isCheckIn;

  const KioskInfoTile({
    super.key,
    required this.eventModel,
    required this.attendanceCount,
    required this.isCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.deepPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    eventModel.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.white, height: 1),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.av_timer,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat.MMMd().format(DateTime.now()),
                              style: Get.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                eventModel.roomName ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$attendanceCount',
                              style: Get.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, color: Colors.white),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DigitalClockWidget(),
                        const SizedBox(height: 10),
                        Text(
                          isCheckIn ? 'Check-In' : 'Check-Out',
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
