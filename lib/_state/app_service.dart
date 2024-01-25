// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cron/cron.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_state/attendance_service.dart';
import 'package:i_attend_capture/_state/event_service.dart';

import '../_core/constants.dart';
import '../_core/firebase_utils.dart';
import '../_core/preference_utils.dart';
import '../_model/sign_in_response_model.dart';
import '../screens/app_setup/app_setup.dart';
import '../screens/event_list/event_list.dart';
import '../screens/sign_in_screen/sign_in_screen.dart';

class AppService extends GetxService {
  final loaderRx = false.obs;

  final loggedInUser = Rxn<SignInResponseModel?>();

  final cron = Cron();

  ScheduledTask? scheduledTask;

  StreamSubscription<ConnectivityResult>? connectivityStreamSubscription;

  ConnectivityResult? _connectivityResult = ConnectivityResult.none;

  bool get isOnline => _connectivityResult != ConnectivityResult.none;

  String get baseUrl => kApiBaseUrl;

  static AppService get X => Get.find();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void scheduleCronJob() {
    if (scheduledTask != null) {
      scheduledTask!.cancel();
    }
    final jobInterval = PreferenceUtils.getSettings().periodicSync ?? 5;
    if (jobInterval > 0) {
      scheduledTask = cron.schedule(
          Schedule.parse(
            '${jobInterval < 60 ? '*/$jobInterval' : '0'} * * * *',
          ), () async {
        try {
          await AttendanceService.X.syncAllPendingAttendance();
          await EventService.X.fetchEvents(isSilent: true);
        } catch (_) {}
      });
    }
  }

  Future<void> init() async {
    loggedInUser.value = PreferenceUtils.getLoggedInUser();
    if (loggedInUser.value != null) {
      scheduleCronJob();
    }

    connectivityStreamSubscription = Connectivity()
        .checkConnectivity()
        .asStream()
        .listen((connectivityResult) {
      _connectivityResult = connectivityResult;
    });
  }

  Future<void> signIn(SignInResponseModel response) async {
    await PreferenceUtils.setLoggedInUserId(response.username);

    final settings = PreferenceUtils.getSettings();
    settings.organizationId = response.organizationId;
    await PreferenceUtils.setSettings(settings);

    await PreferenceUtils.setLoggedInUser(response);

    final userId = "user-${response.id}";
    final clientId = "client-${response.clientId}";
    await FirebaseUtils.subscribeToTopics([userId, clientId]);

    scheduleCronJob();

    await Get.offAllNamed(AppSetup.page.name);
  }

  Future<void> signOut() async {
    final clientData = PreferenceUtils.getLoggedInUser();

    if (clientData != null) {
      final userId = "user-${clientData.id}";
      final clientId = "client-${clientData.clientId}";
      await FirebaseUtils.unsubscribeFromTopics([userId, clientId]);
    }

    await PreferenceUtils.setFcmToken(null);
    await PreferenceUtils.setToken(null);
    // await PreferenceUtils.setLastAttendeeFetched(null);
    await PreferenceUtils.setLoggedInUser(null);
    AppService.X.loaderRx(false);
    await Get.offAllNamed(SignInScreen.page.name);
  }

  Future<dynamic>? gotoHome() => Get.offAllNamed(EventList.page.name);

  @override
  void onClose() {
    connectivityStreamSubscription?.cancel();
    super.onClose();
  }
}
