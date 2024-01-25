// ignore_for_file: public_member_api_docs, type_annotate_public_apis

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../_core/notification_utils.dart';
import '../../_model/attendee_model.dart';
import '../../_model/event_model.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/event_repository.dart';
import '../../_state/app_service.dart';
import '../../_state/attendance_service.dart';
import '_widget/kiosk_mode_pin_dialog.dart';

class KioskX extends GetxController {
  num scheduleId = 0;

  final eventModel = Rxn<EventModel>();

  final isCheckIn = true.obs;

  final showSearchView = false.obs;

  MobileScannerController cameraController =
      MobileScannerController(facing: CameraFacing.front);

  int backCounter = 0;

  int attendanceCounter = 0;

  final _lastResult = Rxn<MarkAttendanceResult>();

  final showResult = false.obs;

  final PagingController<int, AttendeeModel> pagingController =
      PagingController(
    firstPageKey: 0,
  );

  MarkAttendanceResult? get lastResult => _lastResult.value;

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

      return;
    }

    await _refreshAttendanceCount();
  }

  Future<void> _refreshAttendanceCount() async {
    attendanceCounter = (await AttendanceRepository.X.listAttendance(
      scheduleId: scheduleId,
    ))
        .length;
  }

  void gotoHome() => showPinDialog(isFromGoToHome: true);

  void handleBack() {
    if (showSearchView.isTrue) {
      showSearchView.value = false;
    } else {
      backCounter++;

      Future.delayed(
        3.seconds,
        () => backCounter = 0,
      );

      if (backCounter == 5) {
        showPinDialog(isFromGoToHome: false);
      }
    }
  }

  void showPinDialog({required bool isFromGoToHome}) {
    Get.dialog(
      KioskModePinDialog(
        mode: KioskModePinDialogMode.unlock,
        onProceed: () {
          if (isFromGoToHome) {
            AppService.X.gotoHome();
          } else {
            Get.back();
          }
        },
      ),
    );
  }

  Future<void> onQrCodeDetected(String badgeId) async {
    final attendee = await AttendanceService.X.getAttendeeByBadgeId(badgeId);

    await handleAttendeeSelection(attendee);
  }

  Future<void> handleAttendeeSelection(AttendeeModel? attendee) async {
    final result = await AttendanceService.X.markAttendanceByAttendee(
      attendee: attendee,
      event: eventModel.value!,
      isCheckIn: isCheckIn.isTrue,
      notify: false,
    );
    await handleAttendanceResult(result);
  }

  Future<void> handleAttendanceResult(MarkAttendanceResult result) async {
    showResult.value = true;

    if (!result.success) {
      // final errorMessage = switch (result.code!) {
      //   MarkAttendanceErrorCode.attendeeNotCheckedIn =>
      //     "First Check-In then Check-Out.\nPlease see your Event Organizer.",
      //   MarkAttendanceErrorCode.attendeeAlreadyCheckedIn =>
      //     "You are already Checked-In.\nPlease see your Event Organizer.",
      //   MarkAttendanceErrorCode.attendeeNotAllowed =>
      //     "Attendee ${result.attendee?.badgeId} not allowed\nPlease see your Event Organizer.",
      //   MarkAttendanceErrorCode.invalidBadgeId =>
      //     "Invalid badge id.\nPlease see your Event Organizer.",
      //   MarkAttendanceErrorCode.unknown =>
      //     "Invalid badge id.\nPlease see your Event Organizer.",
      // };
      final errorMessage = "";
      _lastResult(
        MarkAttendanceResult.error(
          code: result.code,
          message: errorMessage,
        ),
      );
    } else {
      _lastResult(result);
    }

    await Future.delayed(
      1500.milliseconds,
      () {
        showResult.value = false;
      },
    );
    // cameraController.dispose();
    cameraController = MobileScannerController(facing: CameraFacing.front);

    await _refreshAttendanceCount();
  }

  // void toggleSearchView() {
  //   showSearchView.toggle();

  //   if (showSearchView.isTrue) {
  //     controller?.pauseCamera();
  //   } else {
  //     controller?.resumeCamera();
  //   }
  // }

  void syncData() {
    AttendanceService.X.syncAttendance(
      eventId: eventModel.value!.eventId!,
      scheduleId: eventModel.value!.scheduleId!,
    );
    update();
  }

  // @override
  // void onClose() {
  //   cameraController.dispose();
  //   super.onClose();
  // }
}
