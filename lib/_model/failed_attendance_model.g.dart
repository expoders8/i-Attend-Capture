// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailedAttendanceModel _$FailedAttendanceModelFromJson(
        Map<String, dynamic> json) =>
    FailedAttendanceModel(
      scanTime:
          const CustomDateTimeConverter().fromJson(json['scanTime'] as String),
    )
      ..locRef = json['localRef'] as String?
      ..badgeId = json['BadgeId'] as String?
      ..attendeeId = json['AttendeeId'] as num?
      ..externalId = json['externalId'] as String?
      ..eventId = json['EventId'] as num?
      ..scheduleId = json['EventScheduleId'] as num?
      ..failReason = json['Reason'] as String?
      ..failId = json['failId'] as num?
      ..lastName = json['lname'] as String?
      ..firstName = json['fname'] as String?
      ..serverId = json['successId'] as num?
      ..isSynced = json['isSynced'] as bool?
      ..isSyncingError = json['isSyncingError'] as bool?;

Map<String, dynamic> _$FailedAttendanceModelToJson(
        FailedAttendanceModel instance) =>
    <String, dynamic>{
      'localRef': instance.locRef,
      'BadgeId': instance.badgeId,
      'AttendeeId': instance.attendeeId,
      'externalId': instance.externalId,
      'EventId': instance.eventId,
      'EventScheduleId': instance.scheduleId,
      'scanTime': const CustomDateTimeConverter().toJson(instance.scanTime),
      'Reason': instance.failReason,
      'failId': instance.failId,
      'lname': instance.lastName,
      'fname': instance.firstName,
      'successId': instance.serverId,
      'isSynced': instance.isSynced,
      'isSyncingError': instance.isSyncingError,
    };
