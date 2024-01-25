// ignore_for_file: public_member_api_docs

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_attend_capture/_state/event_service.dart';
import 'package:i_attend_capture/_state/sync_service.dart';
import 'package:i_attend_capture/default_firebase_options.dart';
import 'package:i_attend_capture/screens/about_us/about_us.dart';
import 'package:i_attend_capture/screens/add_participant/add_participant.dart';
import 'package:i_attend_capture/screens/check_in_out/check_in_out.dart';
import 'package:i_attend_capture/screens/event_details/event_details.dart';
import 'package:i_attend_capture/screens/manual_attendance/manual_attendance.dart';
import 'package:i_attend_capture/screens/participant_list/participant_list.dart';
import 'package:i_attend_capture/screens/settings/settings_screen.dart';
import 'package:i_attend_capture/screens/splash_screen/splash_screen.dart';
import 'package:i_attend_capture/screens/view_attendance/view_attendance.dart';

import '_provider/attendance_provider.dart';
import '_provider/attendee_provider.dart';
import '_provider/auth_provider.dart';
import '_provider/event_provider.dart';
import '_repository/attendance_repository.dart';
import '_repository/attendee_repository.dart';
import '_repository/event_repository.dart';
import '_repository/failed_attendance_repository.dart';
import '_repository/private_attendee_repository.dart';
import '_state/app_service.dart';
import '_state/attendance_service.dart';
import '_state/attendee_service.dart';
import '_state/fcm_service.dart';
import '_widgets/loading_widget.dart';
import 'screens/app_setup/app_setup.dart';
import 'screens/capture_attendance/capture_attendance.dart';
import 'screens/capture_attendance/kiosk.dart';
import 'screens/capture_attendance/qr_scanner.dart';
import 'screens/event_list/event_list.dart';
import 'screens/event_list/event_list.x.dart';
import 'screens/onboarding_screen/onboarding_screen.dart';
import 'screens/private_attendees_list/private_attendees_list.dart';
import 'screens/sign_in_screen/sign_in_screen.dart';
import 'screens/view_failed_attendance/view_failed_attendance.dart';
import 'screens/view_scans/view_scans.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final box = GetStorage();
  if (box.read('firstTimeLaunch') == null) {
    box.write('LOGGED_IN_USER', "");
    box.erase();
    box.write('firstTimeLaunch', true);
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'i-Attend Capture',
      navigatorKey: Get.key,
      builder: LoadingScreen.init(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialBinding: BindingsBuilder(() async {
        Get.put(AppService(), permanent: true);
        Get.put(AuthProvider(), permanent: true);

        Get.put(EventProvider(), permanent: true);
        Get.put(AttendeeProvider(), permanent: true);
        Get.put(AttendanceProvider(), permanent: true);

        Get.put(EventRepository(), permanent: true);
        Get.put(PrivateAttendeeRepository(), permanent: true);
        Get.put(AttendeeRepository(), permanent: true);
        Get.put(AttendanceRepository(), permanent: true);
        Get.put(FailedAttendanceRepository(), permanent: true);

        Get.put(AttendeeService(), permanent: true);
        Get.put(EventService(), permanent: true);
        Get.put(SyncService(), permanent: true);
        Get.put(AttendanceService(), permanent: true);
        Get.put(EventListX(), permanent: true);

        await Get.putAsync(
          () async {
            final fcmService = FcmService();
            await fcmService.init();

            return fcmService;
          },
        );
      }),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.page.name,
      getPages: [
        SplashScreen.page,
        AppSetup.page,
        SignInScreen.page,
        OnboardingScreen.page,
        EventList.page,
        EventDetails.page,
        ViewAttendance.page,
        ManualAttendance.page,
        CheckInOut.page,
        ParticipantList.page,
        AddParticipant.page,
        SettingsScreen.page,
        AboutUs.page,
        CaptureAttendance.page,
        PrivateAttendeesList.page,
        QRScanner.page,
        ViewScans.page,
        Kiosk.page,
        ViewFailedAttendance.page,
      ],
    );
  }
}
