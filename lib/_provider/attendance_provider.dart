// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:get/get.dart';

import '../_core/dio_client.dart';
import '../_model/attendance_model.dart';
import '../_model/attendance_sync_res_model.dart';
import '../_model/failed_attendance_model.dart';
import '../_model/failed_attendance_sync_res_model.dart';
import '../_state/app_service.dart';

class AttendanceProvider extends DioClient {
  static AttendanceProvider get X => Get.find();

  Future<AttendanceSyncResModel> syncAttendance({
    required num scheduleId,
    required num eventId,
    required List<num> localIds,
    required List<num> deletedIds,
    required List<AttendanceModel> newAttendance,
    required String? syncDtTm,
  }) async {
    final result = await post(
      '${AppService.X.baseUrl}/Api/Attendance/Sync',
      query: {
        'eventId': eventId,
        'scheduleId': scheduleId,
      },
      data: json.encode({
        "save": newAttendance,
        "delete": deletedIds,
        "savedIds": localIds,
        "syncDtTm": syncDtTm,
      }),
    );

    return AttendanceSyncResModel.fromJson(result.data as Map<String, dynamic>);
  }

  Future<FailedAttendanceSyncResModel> syncFailedAttendance({
    required num scheduleId,
    required num eventId,
    required List<FailedAttendanceModel> failedAttendance,
    required String? syncDtTm,
  }) async {
    final result = await post(
      '${AppService.X.baseUrl}/Api/FailedScan/Sync',
      query: {
        'eventId': eventId,
        'scheduleId': scheduleId,
      },
      data: json.encode({
        "save": failedAttendance,
        "syncDtTm": syncDtTm,
      }),
    );

    return FailedAttendanceSyncResModel.fromJson(
      result.data as Map<String, dynamic>,
    );
  }
}
