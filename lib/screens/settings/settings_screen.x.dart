// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../_core/date_formatter.dart';
import '../../_core/logger.dart';
import '../../_core/notification_utils.dart';
import '../../_core/preference_utils.dart';
import '../../_core/show_permission_dialog.dart';
import '../../_model/settings_model.dart';
import '../../_provider/auth_provider.dart';
import '../../_repository/attendance_repository.dart';
import '../../_repository/attendee_repository.dart';
import '../../_repository/event_repository.dart';
import '../../_repository/failed_attendance_repository.dart';
import '../../_repository/private_attendee_repository.dart';
import '../../_state/app_service.dart';
import '../about_us/about_us.dart';

class SettingsScreenX extends GetxController {
  final settings = Rxn<SettingsModel>();

  // Initial Selected Value
  RxInt syncFrequencyValue = 5.obs;

  // List of items in our dropdown menu
  List<int> syncEventDays = [5, 10, 15, 20, 25, 30, 35, 40, 45];

  List<int> syncFrequency = [5, 10, 30, 60, -1];

  RxString userName = "".obs;
  RxString password = "".obs;

  static SettingsScreenX get X => Get.find();

  String get syncFrequencyString => syncFrequencyValue.value == -1
      ? "Manual"
      : syncFrequencyValue.value == 60
          ? '1 hour'
          : "${syncFrequencyValue.value} Minutes";

  String get syncEventDaysString =>
      "${settings.value?.syncEventDays.toInt()} Days";

  @override
  void onInit() {
    super.onInit();
    settings.value = PreferenceUtils.getSettings();

    logger.i("settings?.periodicSync ${settings.value?.periodicSync}");

    syncFrequencyValue.value =
        settings.value?.periodicSync?.toInt() ?? syncFrequency.first;
    // organizationId.value = settings?.organizationId ?? "";

    userName.value = PreferenceUtils.getLoggedInUserId();
  }

  Future<void> updateSyncFrequency() async {
    settings.value?.periodicSync = syncFrequencyValue.value;
    await _updateSettings();
  }

  Future<void> updateSyncPeriod(int syncPeriod) async {
    settings.value?.syncEventDays = syncPeriod;
    await _updateSettings();
  }

  Future<void> updateAttendanceConfirmation(bool value) async {
    settings.value?.attendanceConfirmation = value;
    await _updateSettings();
  }

  Future<void> updateSuccessSound(bool value) async {
    settings.value?.successSound = value;
    await _updateSettings();
  }

  Future<void> updateFailureSound(bool value) async {
    settings.value?.failureSound = value;
    await _updateSettings();
  }

  Future<void> updateOrganizationID(String updatedOrganizationId) async {
    settings.value?.organizationId = updatedOrganizationId;
    await _updateSettings();
  }

  Future<void> _updateSettings() async {
    await PreferenceUtils.setSettings(settings.value);

    if (AppService.X.scheduledTask != null) {
      logger.i("schedule task is not empty ");
      await AppService.X.scheduledTask!.cancel();
    }

    AppService.X.scheduleCronJob();

    update();
  }

  Future<bool> signIn() async {
    try {
      AppService.X.loaderRx(true);

      final res = await AuthProvider.X.signIn(
        settings.value?.organizationId ?? "",
        userName.value,
        password.value,
        "fcmToken",
      );

      if (res.isError ?? false) {
        throw res.errorMessage ?? "Something went wrong while signing in.";
      }

      return true;
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {
      AppService.X.loaderRx(false);
    }

    return false;
  }

  Future<void> resetApplication() async {
    try {
      AppService.X.loaderRx(true);

      await PreferenceUtils.setLastAttendeeFetched(null);
      await PreferenceUtils.setBaseUrl(null);

      await AttendeeRepository.X.deleteStore();
      await AttendanceRepository.X.deleteStore();
      await EventRepository.X.deleteStore();
      await FailedAttendanceRepository.X.deleteStore();
      await PrivateAttendeeRepository.X.deleteStore();

      await AppService.X.signOut();
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {
      AppService.X.loaderRx(false);
    }
  }

  Future<dynamic>? gotoAboutUs() => Get.toNamed(AboutUs.page.name);

  Future<void> exportAttendanceToCsv({bool isForDeletedEvents = false}) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        if (await Permission.storage.request() != PermissionStatus.granted) {
          showPermissionDialog("Storage to store CSV Files");
          return;
        }
      }
    }

    var createdFiles = <String>[];

    try {
      AppService.X.loaderRx(true);

      try {
        final allEvents = await EventRepository.X.getEventListForCSV();
        final List<String> header = [
          "FirstName",
          "LastName",
          "BadgeID",
          "Date",
          "Time",
          "DataSynced"
        ];

        for (final event in allEvents) {
          logger.i("eventData: ${event.eventName}");
          final List<List<dynamic>> rows = [];
          rows.add(header);

          final DateTime now = DateTime.now();
          final DateTime currentDate = DateTime(now.year, now.month, now.day);

          final eventDate = DateTime(
            event.startTime.year,
            event.startTime.month,
            event.startTime.day,
          );

          if (eventDate.isAfter(currentDate)) {
            logger.i(
              "${"Setting: writeCsvFile = Loop Event ${event.eventName} with SchId = ${event.scheduleId}"} is in Future",
            );
          } else {
            String fileName =
                "${event.eventName}_${getCsvFileNameDateFormat(event.startTime)}_${getCurrentTimeForCsvLoading()}.csv";

            fileName = isForDeletedEvents ? ("Orphan_$fileName") : fileName;

            String path = "";
            if (Platform.isIOS) {
              final directory = await getApplicationDocumentsDirectory();
              path = directory.path;
            }
            if (Platform.isAndroid) {
              path = await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS,
              );
            }
            final directoryPath = Directory("$path/com.tnetic.capture_new");
            if (!directoryPath.existsSync()) {
              Directory("$path/com.tnetic.capture_new/").createSync();
            }

            //get attendance data from event data

            final attendanceList = await AttendanceRepository.X.listAttendance(
              scheduleId: event.scheduleId,
            );

            logger.i("attendanceData: ${json.encode(attendanceList)}");
            for (final attendance in attendanceList) {
              logger.i("attendance.scans!.length:${attendance.scans!.length}");

              for (final scan in attendance.scans!) {
                logger.i("scan: ${json.encode(scan)}");

                if (attendance.attendeeId != null) {
                  final attendee =
                      await AttendeeRepository.X.get(attendance.attendeeId!);

                  if (scan.inPunchTime != null) {
                    final item = [
                      attendance.firstName ?? "",
                      attendance.lastName ?? "",
                      attendee?.badgeId ?? "",
                      getCsvLocalToUtcDate(scan.inPunchTime!),
                      getCsvLocalToUtcTime(scan.inPunchTime!),
                      if (scan.isSynced) "Yes" else "No"
                    ];
                    rows.add(item);
                  }

                  if (scan.outPunchTime != null) {
                    final item = [
                      attendance.firstName ?? "",
                      attendance.lastName ?? "",
                      attendee?.badgeId ?? "",
                      getCsvLocalToUtcDate(scan.outPunchTime!),
                      getCsvLocalToUtcTime(scan.outPunchTime!),
                      if (scan.isSynced) "Yes" else "No"
                    ];
                    rows.add(item);
                  }
                }
              }
            }

            final filePath = "${directoryPath.path}/$fileName";

            final String csvData = const ListToCsvConverter().convert(rows);

            final File file = File(filePath);
            await file.writeAsString(csvData);
            logger.i("file : $file");

            createdFiles.add(file.path);
          }
        }

        logger.i("CreatedFiles : ${json.encode(createdFiles)}");
      } on Exception catch (e) {
        logger.e(e);
      }

      return;
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {
      AppService.X.loaderRx(false);
      await NotificationUtils.showAlert(
        content:
            "CSV file is available in the download folder of the app. Do you want to send generated files on by email,",
        btnNegative: "No",
        btnPositive: "Yes",
        btnNegativeCallback: () {
          createdFiles = [];
          Get.back();
        },
        btnPositiveCallback: () async {
          Get.back();
          final Email email = Email(
            body: 'Please find attached CSV files for event attendance',
            subject: 'Event Attendance CSV files ',
            attachmentPaths: createdFiles,
            isHTML: false,
          );

          await FlutterEmailSender.send(email);
          createdFiles = [];
        },
      );
    }
  }
}
