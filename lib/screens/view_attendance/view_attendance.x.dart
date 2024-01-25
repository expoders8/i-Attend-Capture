// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

import '../../_core/notification_utils.dart';
import '../../_model/attendance_model.dart';
import '../../_model/event_model.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/event_repository.dart';
import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';
import '../view_scans/view_scans.dart';

class ViewAttendanceX extends GetxController {
  num scheduleId = 0;

  final showEventInfo = true.obs;

  final isAnyDataForSync = false.obs;

  final isAttendanceExitsToSync = false.obs;

  final eventModel = Rxn<EventModel>();

  final attendanceList = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    scheduleId = Get.arguments as num;

    _init(fetchAttendanceIfRequired: true);
  }

  void onAttendanceTap(num attendeeId, num scheduleId) => Get.toNamed(
        ViewScans.page.name,
        arguments: {
          'attendeeId': attendeeId,
          'scheduleId': scheduleId,
        },
      );

  Future<void> _init({
    bool fetchAttendanceIfRequired = false,
  }) async {
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
        isAnyDataForSync.value =
            await AttendanceRepository.X.isAttendanceExistForSync([scheduleId]);

        attendanceList.value = await AttendanceRepository.X.listAttendance(
          scheduleId: scheduleId,
        );

        if (fetchAttendanceIfRequired && attendanceList.isEmpty) {
          AppService.X.loaderRx(true);
          await AttendanceService.X.syncAttendance(
            eventId: eventModel.value!.eventId!,
            scheduleId: eventModel.value!.scheduleId!,
          );
        }

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
}
