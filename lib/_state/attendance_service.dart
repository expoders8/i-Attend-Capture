// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:get/get.dart';
import 'package:i_attend_capture/_state/app_service.dart';
import 'package:i_attend_capture/_state/event_service.dart';
import 'package:i_attend_capture/_state/sync_service.dart';
import 'package:i_attend_capture/screens/event_list/event_list.dart';

import '../_core/notification_utils.dart';
import '../_core/preference_utils.dart';
import '../_core/utils.dart';
import '../_model/attendance_model.dart';
import '../_model/attendee_model.dart';
import '../_model/event_model.dart';
import '../_model/failed_attendance_model.dart';
import '../_model/scan.dart';
import '../_provider/attendance_provider.dart';
import '../_repository/attendance_repository.dart';
import '../_repository/attendee_repository.dart';
import '../_repository/event_repository.dart';
import '../_repository/failed_attendance_repository.dart';
import '../_repository/private_attendee_repository.dart';
import '../screens/view_attendance/view_attendance.x.dart';
import '../screens/view_scans/view_scans.x.dart';

class AttendanceService extends GetxService {
  static AttendanceService get X => Get.find();

  @override
  void onInit() {
    super.onInit();
    SyncService.X.refreshData();
  }

  Future<void> syncAllPendingAttendance() async {
    AppService.X.loaderRx(true);
    try {
      final allEvents = await EventRepository.X.getEventList();

      for (final event in allEvents) {
        await syncAttendance(
          eventId: event.eventId!,
          scheduleId: event.scheduleId!,
        );
      }
      AppService.X.loaderRx(false);
      NotificationUtils.showSuccessSnackBar(
        message: "All App data is Synced Successfully!",
      );
    } catch (e) {
      AppService.X.loaderRx(false);
      await handleDioError(e);
    }
  }

  Future<void> syncAttendance({
    required num eventId,
    required num scheduleId,
  }) async {
    final savedAttendanceIds =
        await Get.find<AttendanceRepository>().listAttendance(
      scheduleId: scheduleId,
    );

    final deletedIds = <num>[];
    final savedIds = <num>[];
    final attendanceToSync = <AttendanceModel>[];
    for (final atn in savedAttendanceIds) {
      final AttendanceModel tempAtn = AttendanceModel.fromJson(atn.toJson());
      tempAtn.scans = [];

      if (atn.isDeleted == true &&
          atn.isSynced == false &&
          atn.serverId != null) {
        deletedIds.add(atn.serverId!);
      }

      atn.scans?.forEach((scan) {
        if ((scan.isDeleted) && !scan.isSynced && scan.serverId != null) {
          deletedIds.add(scan.serverId!);
        } else if (scan.serverId != null) {
          savedIds.add(scan.serverId!);
          if (!scan.isSynced) {
            tempAtn.scans?.add(scan);
          }
        } else {
          tempAtn.scans?.add(scan);
        }
      });

      if (tempAtn.scans?.isNotEmpty ?? false) {
        attendanceToSync.add(tempAtn);
      }
    }

    final event = await EventRepository.X.getEventById(scheduleId);

    final response = await AttendanceProvider.X.syncAttendance(
      eventId: eventId,
      scheduleId: scheduleId,
      deletedIds: deletedIds,
      localIds: savedIds,
      newAttendance: attendanceToSync,
      syncDtTm: event?.syncDtTm,
    );

    await AttendanceRepository.X
        .updateScansForSyncStatus(scheduleId, response.saveRes ?? []);

    final erroredDeletedIds = <num>[];
    response.deleteRes?.forEach((atn) {
      erroredDeletedIds.add(atn.serverId!);
      deletedIds.remove(atn.serverId);
    });

    if (erroredDeletedIds.isNotEmpty) {
      await AttendanceRepository.X
          .setError(erroredDeletedIds, 'Error while deleting at server');
    }

    // Delete local Scan which were synced but now deleted at server
    deletedIds.addAll(response.deleteLocal ?? []);

    if (deletedIds.isNotEmpty) {
      await AttendanceRepository.X.deleteByServerIds(scheduleId, deletedIds);
    }

    if ((response.newAtn ?? []).isNotEmpty) {
      await AttendanceRepository.X.addOrUpdateAfterSync(
        attendanceList: response.newAtn ?? [],
        eventId: eventId,
        scheduleId: scheduleId,
      );
    }

    await AttendanceRepository.X.deleteAttendanceWithNoScans();

    await EventRepository.X.updateSyncDtTm(
      scheduleId,
      response.syncDtTm!,
    );

    if (Get.isRegistered<ViewAttendanceX>()) {
      Get.find<ViewAttendanceX>().revalidate();
    }

    if (Get.isRegistered<ViewScansX>()) {
      Get.find<ViewScansX>().revalidate();
    }

    await SyncService.X.refreshData();
  }

  Future<void> syncFailedAttendance({
    required num scheduleId,
    required num eventId,
  }) async {
    final failedAttendanceList =
        await FailedAttendanceRepository.X.listByScheduleId(
      scheduleId,
      isSynced: false,
    );

    final syncDtTm = PreferenceUtils.getLastFailedAttendanceFetched(scheduleId);

    final response = await AttendanceProvider.X.syncFailedAttendance(
      scheduleId: scheduleId,
      eventId: eventId,
      failedAttendance: failedAttendanceList,
      syncDtTm: syncDtTm,
    );

    await PreferenceUtils.setLastFailedAttendanceFetched(
      scheduleId,
      response.syncDtTm,
    );

    if ((response.failedSync ?? []).isEmpty) {
      await FailedAttendanceRepository.X.setSyncTrueByScheduleId(scheduleId);
    } else {
      await FailedAttendanceRepository.X.updateSyncStatus(
        response.failedSync ?? [],
        scheduleId,
      );
    }

    final attendeeIds = (response.failedNewAttendanceList ?? [])
        .map((e) => e.attendeeId!)
        .toSet();

    if (attendeeIds.isNotEmpty) {
      final mapOfAttendees =
          await AttendanceRepository.X.getByAttendeesMapAttendeeIds(
        attendeeIds.toList(),
      );

      response.failedNewAttendanceList?.forEach(
        (element) async {
          element.firstName = mapOfAttendees?[element.attendeeId]?.firstName;
          element.lastName = mapOfAttendees?[element.attendeeId]?.lastName;
          element.eventId = eventId;
          element.scheduleId = scheduleId;
          element.isSynced = true;

          await FailedAttendanceRepository.X.insert(element);
        },
      );
    }
  }

  Future<void> onSyncMessageTapHandler(num? scheduleId) async {
    try {
      AppService.X.loaderRx(true);

      EventModel? eventModel;
      if (scheduleId != null) {
        eventModel = await EventRepository.X.getEventById(scheduleId);

        if (eventModel != null) {
          await AttendanceService.X.syncAttendance(
            eventId: eventModel.eventId!,
            scheduleId: eventModel.scheduleId!,
          );
        }
      }
    } catch (e) {
      await handleDioError(
        e,
        onReAuthenticated: () => onSyncMessageTapHandler(scheduleId),
      );
    } finally {
      AppService.X.loaderRx(false);
    }
  }

  Future<AttendeeModel?> getAttendeeByBadgeId(String badgeId) async {
    var attendee = await AttendeeRepository.X.getByBadgeId(badgeId);

    attendee ??= await AttendeeRepository.X.getByBadgeId('0$badgeId');

    if (attendee == null && badgeId[0] == "0") {
      attendee ??= await AttendeeRepository.X.getByBadgeId(
        badgeId.substring(1),
      );
    }

    return attendee ??= await AttendeeRepository.X.getByExternalId(badgeId);
  }

  Future<MarkAttendanceResult> markAttendanceByAttendee({
    required AttendeeModel? attendee,
    required EventModel event,
    required bool isCheckIn,
    bool suggestAlternativeAction = false,
    bool notify = true,
  }) async {
    bool success = false;
    if (attendee == null) {
      await _handleError(
        "Error: Invalid badge id. Please try again.",
        notify: notify,
      );
      await _recordFailedScan(
        event: event,
        reasonId: FailedAttendanceReasonId.invalidBadgeId,
      );

      return MarkAttendanceResult.error(
        code: MarkAttendanceErrorCode.invalidBadgeId,
        message: "Error: Invalid badge id. Please try again.",
      );
    }

    final privateAttendees = (await PrivateAttendeeRepository.X.getByEventId(
          event.eventId!,
        ))
            ?.attendeeIdList ??
        [];

    if (event.allowOnTimeReg == false ||
        (privateAttendees.isNotEmpty &&
            !privateAttendees.contains(attendee.attendeeId))) {
      await _handleError(
        "Attendee not allowed",
        notify: notify,
      );
      await _recordFailedScan(
        event: event,
        attendee: attendee,
        reasonId: FailedAttendanceReasonId.attendeeNotAllowed,
      );

      return MarkAttendanceResult.error(
        code: MarkAttendanceErrorCode.attendeeNotAllowed,
        message: "Attendee not allowed",
      );
    }

    var attendance = (await AttendanceRepository.X.listAttendance(
      scheduleId: event.scheduleId,
      attendeeId: attendee.attendeeId,
    ))
        .firstWhereOrNull((element) => true);

    if (isCheckIn) {
      if (attendance != null &&
          ((attendance.lastScan?.outPunchTime == null) ||
              (event.isMultiDayEvent ?? false))) {
        if ((event.allowCheckouts == false) && !suggestAlternativeAction) {
          await _handleError(
            "Attendee already Checked-In",
            notify: notify,
          );
        } else {
          final doCheckOut = await NotificationUtils.showAlert(
            content:
                "Participant has already been Checked-In. Do you want to Check-Out?",
            btnPositive: "Check-Out",
          );

          if (doCheckOut == true) {
            return markAttendanceByAttendee(
              attendee: attendee,
              event: event,
              isCheckIn: false,
              notify: notify,
            );
          }
        }

        return MarkAttendanceResult.error(
          code: MarkAttendanceErrorCode.attendeeAlreadyCheckedIn,
          message: "Attendee already Checked-In",
        );
      }

      attendance ??= AttendanceModel(
        scheduleId: event.scheduleId,
        eventId: event.eventId,
        attendeeId: attendee.attendeeId,
        firstName: attendee.firstName,
        lastName: attendee.lastName,
        scans: [],
      );

      final newScan = Scan()
        ..localRef = generateLocalRef()
        ..inPunchTime = DateTime.now();

      attendance.scans?.add(newScan);
      attendance.isSynced = false;
      attendance.isCheckIn = true;

      success = true;
    } else {
      if (attendance == null || attendance.lastScan?.outPunchTime != null) {
        if (suggestAlternativeAction &&
            attendance?.lastScan?.outPunchTime != null) {
          final doCheckIn = await NotificationUtils.showAlert(
            content:
                "Participant has already been Checked-Out. Do you want to Check-In",
            btnPositive: "Check-In",
          );

          if (doCheckIn == true) {
            return markAttendanceByAttendee(
              attendee: attendee,
              event: event,
              isCheckIn: false,
              notify: notify,
            );
          }
        } else {
          await _handleError(
            "First Check-In then Check-Out",
            notify: notify,
          );
        }

        return MarkAttendanceResult.error(
          code: MarkAttendanceErrorCode.attendeeNotCheckedIn,
          message: "First Check-In then Check-Out",
        );
      }

      attendance.lastScan?.outPunchTime = DateTime.now();
      attendance.lastScan?.isSynced = false;
      attendance.isCheckIn = false;
      attendance.isSynced = false;

      success = true;
    }

    if (success) {
      await AttendanceRepository.X.addOrUpdate(attendance);

      await _handleAttendanceCaptured(
        attendance,
        isCheckIn: isCheckIn,
        notify: notify,
      );

      await SyncService.X.refreshData();

      return MarkAttendanceResult.success(
        attendance.lastScan,
        attendee,
      );
    }

    return MarkAttendanceResult.error(code: MarkAttendanceErrorCode.unknown);
  }

  Future<void> _handleAttendanceCaptured(
    AttendanceModel attendance, {
    required bool isCheckIn,
    bool notify = true,
  }) async {
    if (notify) {
      final message =
          "${attendance.lastName}, ${attendance.firstName} : ${isCheckIn ? "Attendance" : "Check-Out"} captured successfully!";
      if (PreferenceUtils.getSettings().attendanceConfirmation ?? false) {
        await NotificationUtils.showAlert(
          content: message,
          btnPositive: "Ok",
        );
      } else {
        NotificationUtils.showSuccessSnackBar(
          message: message,
        );
      }
    }

    _playSuccessSound();
  }

  Future<void> _handleError(String message, {bool notify = true}) async {
    if (notify) {
      if (PreferenceUtils.getSettings().attendanceConfirmation ?? false) {
        await NotificationUtils.showAlert(
          content: message,
          btnPositive: "Ok",
        );
      } else {
        NotificationUtils.showErrorSnackBar(
          message: message,
        );
      }
    }

    _playFailedSound();
  }

  void _playSuccessSound() {}

  void _playFailedSound() {}

  Future<void> _recordFailedScan({
    required num reasonId,
    required EventModel event,
    AttendeeModel? attendee,
    String? badgeId,
  }) async {
    await FailedAttendanceRepository.X.insert(
      FailedAttendanceModel(
        scanTime: DateTime.now(),
      )
        ..attendeeId = attendee?.attendeeId
        ..eventId = event.eventId
        ..scheduleId = event.scheduleId
        ..failReason = reasonId == FailedAttendanceReasonId.attendeeNotAllowed
            ? "Attendee not allowed"
            : "Invalid badge id"
        ..badgeId = badgeId ?? attendee?.badgeId
        ..externalId = attendee?.externalID
        ..firstName = attendee?.firstName
        ..lastName = attendee?.lastName
        ..failId = reasonId,
    );
  }
}

class MarkAttendanceResult {
  final bool success;
  final String? message;
  final Scan? scan;
  final AttendeeModel? attendee;
  final MarkAttendanceErrorCode? code;

  MarkAttendanceResult.error({
    required this.code,
    this.message,
  })  : success = false,
        scan = null,
        attendee = null;

  MarkAttendanceResult.success(this.scan, this.attendee)
      : success = true,
        message = null,
        code = null;
}

enum MarkAttendanceErrorCode {
  unknown,
  invalidBadgeId,
  attendeeNotAllowed,
  attendeeAlreadyCheckedIn,
  attendeeNotCheckedIn,
}
