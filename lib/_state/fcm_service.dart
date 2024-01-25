// ignore_for_file: public_member_api_docs

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_state/event_service.dart';

import '../_core/firebase_utils.dart';
import '../_core/logger.dart';
import '../_core/preference_utils.dart';
import '../screens/event_list/event_list.x.dart';

class FcmService extends GetxService {
  Future<void> init() async {
    await Firebase.initializeApp();
    await FirebaseUtils.init(
      messageHandler,
      notificationOpenedHandler,
    );

    await PreferenceUtils.setFcmToken(await FirebaseUtils.getFcmToken() ?? "");
  }

  static Future<String?> getFcmToken() => FirebaseUtils.getFcmToken();

  static Future<void> messageHandler(
    RemoteMessage message, {
    bool? isForeground,
  }) async {
    logger.i("Fcm Message: ${message.data} ${message.data['sync']}");

    switch (message.data['sync']) {
      case "1":
        break;

      case "2":
        try {
          // syncing events on fcm call
          await EventService.X.fetchEvents(
            selectedDate: DateTime.now(),
            isSilent: true,
          );
        } catch (e) {}

        //update UI based in dates
        if (Get.isRegistered<EventListX>()) {
          await EventListX.X.updateEventsToShow();
        }

        break;

      case "3":
        break;

      case "4":
        break;
    }
  }

  void notificationOpenedHandler(Map<String, dynamic> data) {}
}
