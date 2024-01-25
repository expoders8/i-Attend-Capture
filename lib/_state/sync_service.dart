// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:i_attend_capture/_core/notification_utils.dart';
import 'package:i_attend_capture/_state/attendance_service.dart';
import 'package:i_attend_capture/_state/attendee_service.dart';
import 'package:i_attend_capture/_state/event_service.dart';

import '../_core/utils.dart';
import '../_repository/attendance_repository.dart';
import '../_repository/event_repository.dart';

class SyncService extends GetxService {
  final isAnyDataForSync = false.obs;

  static SyncService get X => Get.find();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    final scheduleIds = await EventRepository.X.listScheduleIds();

    isAnyDataForSync.value =
        await AttendanceRepository.X.isAttendanceExistForSync(scheduleIds);
  }

  Future<void> sync() async {
    try {
      await AttendeeService.X.fetchAttendees();

      await EventService.X.fetchEvents(isSilent: true);

      final allEvents = await EventRepository.X.getEventList();

      for (final event in allEvents) {
        // await AttendeeService.X.fetchPrivateAttendees(event.eventId!);

        await AttendanceService.X.syncAttendance(
          eventId: event.eventId!,
          scheduleId: event.scheduleId!,
        );

        await refreshData();
      }

      NotificationUtils.showSuccessSnackBar(
        message: "All App data is Synced Successfully!",
      );
    } catch (e) {
      await handleDioError(e);
    }
  }
}
