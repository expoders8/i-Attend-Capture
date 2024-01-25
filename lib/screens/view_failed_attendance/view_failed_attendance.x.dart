// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

import '../../_core/notification_utils.dart';
import '../../_model/event_model.dart';
import '../../_model/failed_attendance_model.dart';
import '../../_repository/event_repository.dart';
import '../../_repository/failed_attendance_repository.dart';
import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';
import '../view_scans/view_scans.dart';

class ViewFailedAttendanceX extends GetxController {
  num scheduleId = 0;

  RxBool showEventInfo = true.obs;

  final isAttendanceExitsToSync = false.obs;

  final eventModel = Rxn<EventModel>();

  final attendanceList = <FailedAttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    scheduleId = Get.arguments as num;

    _init();
  }

  Future<void> _init() async {
    try {
      eventModel.value = await EventRepository.X.getEventById(scheduleId);

      if (eventModel.value == null) {
        await NotificationUtils.showAlert(
          title: "Error",
          content: "It looks like this event has been deleted or rescheduled",
          btnPositive: "Ok",
        );
        Get.back();
      } else {
        attendanceList.value =
            await FailedAttendanceRepository.X.listByScheduleId(scheduleId);

        update();
      }
    } finally {
      AppService.X.loaderRx(false);
    }
  }

  void toggleEventInfo() => showEventInfo.value = !showEventInfo.value;

  Future<void> viewScans(num attendeeId, num scheduleId) async {
    await Get.toNamed(
      ViewScans.page.name,
      arguments: {
        'attendeeId': attendeeId,
        'scheduleId': scheduleId,
      },
    );

    await _init();
  }

  void revalidate() => _init();

  Future<void> syncFailedAttendance() async {
    await NotificationUtils.showAlert(
      title: "Confirm",
      content: "Sync failed attendance ?",
      btnPositive: "Yes",
      btnNegative: "No",
      btnPositiveCallback: () async {
        Get.back();
        AppService.X.loaderRx(true);
        await AttendanceService.X.syncFailedAttendance(
          scheduleId: eventModel.value!.scheduleId!,
          eventId: eventModel.value!.eventId!,
        );
        AppService.X.loaderRx(false);
      },
    );
  }
}
