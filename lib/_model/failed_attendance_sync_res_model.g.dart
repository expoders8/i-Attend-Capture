// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_attendance_sync_res_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailedAttendanceSyncResModel _$FailedAttendanceSyncResModelFromJson(
        Map<String, dynamic> json) =>
    FailedAttendanceSyncResModel()
      ..failedNewAttendanceList = (json['newScans'] as List<dynamic>?)
          ?.map(
              (e) => FailedAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..failedSync =
          (json['saveErr'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..syncDtTm = json['syncDtTm'] as String?;

Map<String, dynamic> _$FailedAttendanceSyncResModelToJson(
        FailedAttendanceSyncResModel instance) =>
    <String, dynamic>{
      'newScans':
          instance.failedNewAttendanceList?.map((e) => e.toJson()).toList(),
      'saveErr': instance.failedSync,
      'syncDtTm': instance.syncDtTm,
    };
