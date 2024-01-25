// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

import '../../_core/notification_utils.dart';
import '../../_model/event_model.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/event_repository.dart';
import '../private_attendees_list/private_attendees_list.dart';
import '../view_attendance/view_attendance.dart';
import '../view_failed_attendance/view_failed_attendance.dart';

class EventDetailsX extends GetxController {
  num scheduleId = 0;

  final isAnyDataForSync = false.obs;

  final eventModel = Rxn<EventModel>();

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

      return;
    }

    isAnyDataForSync.value =
        await AttendanceRepository.X.isAttendanceExistForSync([scheduleId]);
  }

  void gotoFailedAttendance() {
    Get.toNamed(
      ViewFailedAttendance.page.name,
      arguments: eventModel.value!.scheduleId,
    );
  }

  void gotoPrivateAttendees() {
    Get.toNamed(
      PrivateAttendeesList.page.name,
      arguments: eventModel.value,
    );
  }

  void gotoViewAttendancePage() {
    Get.toNamed(
      ViewAttendance.page.name,
      arguments: eventModel.value!.scheduleId,
    );
  }

  void revalidate() => _init();
}
