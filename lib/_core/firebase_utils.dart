// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseUtils {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotifications;
  static Future<void> Function(RemoteMessage, {bool? isForeground})?
      _messageHandler;
  static Function(Map<String, dynamic> data)? _notificationOpenedHandler;

  static Future<void> init(
    Future<void> Function(RemoteMessage message, {bool? isForeground})
        messageHandler,
    Function(Map<String, dynamic> data) notificationOpenedHandler,
  ) async {
    _messageHandler = messageHandler;
    _notificationOpenedHandler = notificationOpenedHandler;

    const android = AndroidInitializationSettings('mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotifications = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotifications?.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final Map<String, dynamic> data =
              json.decode(details.payload!) as Map<String, dynamic>;
          notificationOpenedHandler(data);
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await firebaseCloudMessagingListeners();
  }

  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse details,
  ) {
    if (details.payload != null && _notificationOpenedHandler != null) {
      final Map<String, dynamic> data =
          json.decode(details.payload!) as Map<String, dynamic>;
      _notificationOpenedHandler?.call(data);
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const android = AndroidNotificationDetails(
      'noti_push_app_1', 'noti_push_app', // 'Channel Desc',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOS = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(android: android, iOS: iOS);
    await _flutterLocalNotifications?.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  static Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) await iOSPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      if (_messageHandler != null) {
        await _messageHandler?.call(
          message,
          isForeground: true,
        );

        if (message.notification != null) {
          await _showLocalNotification(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      _notificationOpenedHandler?.call(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_messageHandler!);
  }

  static Future<void> iOSPermission() async {
    final result = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (result.alert == AppleNotificationSetting.disabled ||
        result.badge == AppleNotificationSetting.disabled ||
        result.sound == AppleNotificationSetting.disabled) {
      await openAppSettings();
    }
  }

  static Future<String?> getFcmToken() async {
    return _firebaseMessaging.getToken();
  }

  static Future<void> subscribeToTopics(List<String> topics) async {
    if (topics.isEmpty) {
      return;
    }

    for (final topic in topics) {
      await _firebaseMessaging.subscribeToTopic(topic);
    }
  }

  static Future<void> unsubscribeFromTopics(List<String> topics) async {
    if (topics.isEmpty) return;

    for (final topic in topics) {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    }
  }

  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }
}
