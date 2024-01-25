// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/kiosk_mode_pin_dialog.dart';
import 'package:i_attend_capture/screens/capture_attendance/kiosk.dart';
import 'package:i_attend_capture/screens/capture_attendance/qr_scanner.dart';

import '../../_core/notification_utils.dart';
import '../../_model/attendance_model.dart';
import '../../_model/attendee_model.dart';
import '../../_model/event_model.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/attendee_repository.dart';
import '../../_repository/event_repository.dart';
import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';

class CaptureAttendanceX extends GetxController {
  final attendeeSearchTextEditingController = TextEditingController();

  final attendeeSearchTextFocusNode = FocusNode();

  num scheduleId = 0;

  final eventShortDetailCardVisibility = true.obs;

  final eventModel = Rxn<EventModel>();

  final isCheckIn = true.obs;

  final attendanceList = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    scheduleId = Get.arguments as num;

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

  Future<List<AttendeeModel>> getAttendees(String search) async {
    return AttendeeRepository.X.getAttendees(
      query: search,
      pageSize: 100,
    );
  }

  Future<void> handleEnterEvent(String badgeId) async {
    final attendee = await AttendanceService.X.getAttendeeByBadgeId(badgeId);

    if ((await AttendanceService.X.markAttendanceByAttendee(
      attendee: attendee,
      event: eventModel.value!,
      isCheckIn: isCheckIn.isTrue,
    ))
        .success) {
      await updateAttendanceList(eventModel.value!, attendee!);
    }

    attendeeSearchTextEditingController.clear();
    attendeeSearchTextFocusNode.requestFocus();
  }

  Future<void> handleAttendeeSelection(AttendeeModel attendee) async {
    getAttendees("clear");
    attendeeSearchTextEditingController.clear();
    AppService.X.loaderRx(true);

    try {
      if ((await AttendanceService.X.markAttendanceByAttendee(
        attendee: attendee,
        event: eventModel.value!,
        isCheckIn: isCheckIn.isTrue,
      ))
          .success) {
        await updateAttendanceList(eventModel.value!, attendee);
      }

      getAttendees("clear");
      attendeeSearchTextEditingController.clear();
      attendeeSearchTextEditingController.text = "";
      attendeeSearchTextFocusNode.requestFocus();
    } finally {
      AppService.X.loaderRx(false);
    }
  }

  Future<void> updateAttendanceList(
    EventModel event,
    AttendeeModel attendee,
  ) async {
    final attendance = (await AttendanceRepository.X.listAttendance(
      scheduleId: event.scheduleId,
      attendeeId: attendee.attendeeId,
    ))
        .first;

    if (attendance != null) {
      attendance.attendee = attendee;

      attendanceList.removeWhere(
        (element) => element.attendeeId == attendee.attendeeId,
      );

      attendanceList.insert(0, attendance);

      update();
    }
  }

  void toggleEventInfoCardVisibility() {
    eventShortDetailCardVisibility.toggle();
  }

  void gotoKioskMode() {
    Get.dialog(
      KioskModePinDialog(
        mode: KioskModePinDialogMode.lock,
        onProceed: () {
          Get.toNamed(
            Kiosk.page.name,
            arguments: {
              'scheduleId': eventModel.value!.scheduleId,
              'isCheckIn': isCheckIn.isTrue,
            },
          );
        },
      ),
    );
  }

  void gotoQrScanner() {
    Get.toNamed(
      QRScanner.page.name,
      arguments: {
        'scheduleId': eventModel.value!.scheduleId,
        'isCheckIn': isCheckIn.isTrue,
      },
    );
  }
}
