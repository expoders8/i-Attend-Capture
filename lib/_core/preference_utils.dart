// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../_model/settings_model.dart';
import '../_model/sign_in_response_model.dart';

class PreferenceUtils {
  static final GetStorage _box = GetStorage();

  static const _isFirstTimeKey = "IS_FIRST_TIME";
  static const _settingsKey = "SETTINGS";
  static const _loggedInUserKey = "LOGGED_IN_USER";
  static const _fcmToken = "FCM_TOKEN";
  static const _token = "SESSION_TOKEN";
  static const _lastAttendeeFetched = "LAST_ATTENDEE_FETCHED";
  static const _lastFailedAttendanceFetched = "LAST_FAILED_ATTENDANCE_FETCHED";
  static const _loggedInUserId = "USER_ID";
  static const _kioskModePin = "KIOSK_MODE_PIN";
  static const _baseUrl = "BASE_URL";

  static Future<void> erase() async => _box.erase();

  static Future<void> setIsFirstTime({required bool isOnboardingShown}) async =>
      _box.write(_isFirstTimeKey, isOnboardingShown);

  static bool getIsFirstTime() => _box.read<bool>(_isFirstTimeKey) ?? false;

  static Future<void> setLoggedInUserId(String? loggedInUserId) async =>
      _box.write(_loggedInUserId, loggedInUserId);

  static String getLoggedInUserId() => _box.read<String>(_loggedInUserId) ?? "";

  static Future<void> setLoggedInUser(SignInResponseModel? user) async {
    if (user == null) {
      await _box.remove(_loggedInUserKey);
    } else {
      await _box.write(_loggedInUserKey, jsonEncode(user.toJson()));
    }
  }

  static SignInResponseModel? getLoggedInUser() {
    final str = _box.read<String>(_loggedInUserKey);

    if (str != null) {
      return SignInResponseModel.fromJson(
        jsonDecode(str) as Map<String, dynamic>,
      );
    }

    return null;
  }

  static Future<void> setSettings(SettingsModel? settings) async {
    if (settings == null) {
      await _box.remove(_settingsKey);
    } else {
      await _box.write(_settingsKey, jsonEncode(settings.toJson()));
    }
  }

  static SettingsModel getSettings() {
    final String? str = _box.read<String>(_settingsKey);
    if (str != null) {
      return SettingsModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
    }

    return SettingsModel();
  }

  static Future<void> setFcmToken(String? token) async =>
      _box.write(_fcmToken, token);

  static String? getFcmToken() {
    final String? str = _box.read<String?>(_fcmToken);
    if (str != null) {
      return str;
    }

    return null;
  }

  static Future<void> setToken(String? token) async =>
      _box.write(_token, token);

  static String? getToken() => _box.read<String?>(_token);

  static Future<void> setLastAttendeeFetched(String? lastSyncedAt) async =>
      _box.write(_lastAttendeeFetched, lastSyncedAt);

  static String? getLastAttendeeFetched() =>
      _box.read<String?>(_lastAttendeeFetched);

  static Future<void> setLastFailedAttendanceFetched(
    num scheduleId,
    String? lastSyncedAt,
  ) async =>
      _box.write('${_lastFailedAttendanceFetched}_$scheduleId', lastSyncedAt);

  static String? getLastFailedAttendanceFetched(num scheduleId) =>
      _box.read<String?>('${_lastFailedAttendanceFetched}_$scheduleId');

  static Future<void> setKioskModePin(String token) async {
    await _box.write(_kioskModePin, token);
  }

  static String? getKioskModePin() {
    return _box.read<String>(_kioskModePin);
  }

  static Future<void> setBaseUrl(String? token) async {
    if (token == null) {
      await _box.remove(_baseUrl);
    } else {
      await _box.write(_baseUrl, token);
    }
  }

  static String? getBaseUrl() {
    return _box.read<String>(_baseUrl);
  }

  // static setLogoSvg(String key, String svgString) async {
  //   await _box.write(key, svgString);
  // }

  // static String? getLogoSvg(
  //   String key,
  // ) {
  //   String? logoSvg = _box.read<String>(key);
  //   return logoSvg;
  // }
}
