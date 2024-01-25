// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../_core/notification_utils.dart';
import '../../_model/event_model.dart';
import '../../_repository/event_repository.dart';
import '../../_state/attendance_service.dart';

class QrScannerX extends GetxController {
  num scheduleId = 0;

  final eventModel = Rxn<EventModel>();

  final isCheckIn = true.obs;

  MobileScannerController cameraController = MobileScannerController();

  @override
  void onInit() {
    super.onInit();
    scheduleId = Get.arguments['scheduleId'] as num;

    isCheckIn.value = Get.arguments['isCheckIn'] as bool;
    _init();
  }

  Future<void> _init() async {
    eventModel.value = await EventRepository.X.getEventById(scheduleId);
    if (eventModel.value == null) {
      await NotificationUtils.showAlert(
        title: "Error",
        content: "It looks like this event has been deleted or rescheduled",
        btnPositive: "Ok",
      );
      Get.back();
    }
  }

  Future<void> handleBadge(String badgeId) async {
    try {
      debugPrint("Scanned badge: $badgeId");
      // cameraController.dispose();
      cameraController = MobileScannerController();

      final attendee = await AttendanceService.X.getAttendeeByBadgeId(badgeId);

      await AttendanceService.X.markAttendanceByAttendee(
        attendee: attendee,
        event: eventModel.value!,
        isCheckIn: isCheckIn.isTrue,
      );
    } catch (e) {}
  }

  // @override
  // void onClose() {
  //   cameraController.dispose();
  //   super.onClose();
  // }
}
