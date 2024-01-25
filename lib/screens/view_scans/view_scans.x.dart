// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:i_attend_capture/screens/view_scans/widget/scan_edit_dialog.dart';

import '../../_core/notification_utils.dart';
import '../../_model/attendance_model.dart';
import '../../_model/attendee_model.dart';
import '../../_model/event_model.dart';
import '../../_model/scan.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/attendee_repository.dart';
import '../../_repository/event_repository.dart';
import '../../_state/sync_service.dart';

class ViewScansX extends GetxController {
  num scheduleId = 0;
  num attendeeId = 0;

  final eventModel = Rxn<EventModel>();

  final attendee = Rxn<AttendeeModel>();
  final attendance = Rxn<AttendanceModel>();

  @override
  void onInit() {
    super.onInit();
    scheduleId = Get.arguments['scheduleId'] as num;
    attendeeId = Get.arguments['attendeeId'] as num;

    assert(scheduleId > 0 && attendeeId > 0);

    _init();
  }

  Future<void> _init() async {
    eventModel.value = await EventRepository.X.getEventById(scheduleId);

    attendance.value = (await AttendanceRepository.X.listAttendance(
      scheduleId: scheduleId,
      attendeeId: attendeeId,
    ))
        .firstWhereOrNull((element) => true);

    attendee.value = await AttendeeRepository.X.get(attendeeId);
  }

  void revalidate() => _init();

  Future<void> onDeleteTap(
    EventModel event,
    AttendeeModel attendee,
    Scan scan,
  ) async {
    await NotificationUtils.showAlert(
      content: event.allowCheckouts ?? false
          ? "Do you really want to delete this Check In/Out Time pair?"
          : "Do you really want to delete this Check-In Time?",
      btnNegative: "No",
      btnPositive: "Yes",
      btnPositiveCallback: () async {
        Get.back(closeOverlays: true);
        await AttendanceRepository.X.deleteScan(
          event.scheduleId,
          attendee.attendeeId!,
          scan.localRef!,
        );
      },
    );
  }

  Future<void> onEditTap(
    EventModel event,
    AttendeeModel attendee,
    Scan scan,
  ) async {
    // show dialog to update the in and out time for the scan
    final updatedScan = await Get.dialog<Scan?>(
      ScanEditDialog(
        attendee: attendee,
        event: event,
        scan: scan,
      ),
    );

    // save updated scan
    if (updatedScan != null) {
      updatedScan.isSynced = false;
      await AttendanceRepository.X.updateScans([updatedScan]);
      await _init();
      await SyncService.X.refreshData();
    }
  }
}
