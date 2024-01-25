// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    AttendanceModel(
      eventId: json['evtId'] as num?,
      scheduleId: json['schId'] as num?,
      attendeeId: json['attendeeId'] as num?,
      scannedOn: _$JsonConverterFromJson<String, DateTime>(
          json['scannedOn'], const CustomDateTimeConverter().fromJson),
      serverId: json['serverId'] as int?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      error: json['error'] as String?,
      isCheckIn: json['isCheckIn'] as bool?,
      lastCheckTime: _$JsonConverterFromJson<String, DateTime>(
          json['lastCheckTime'], const CustomDateTimeConverter().fromJson),
      scans: (json['scans'] as List<dynamic>?)
          ?.map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..localRef = json['localRef'] as String?
      ..errorMessage = json['message'] as String?
      ..attendee = json['attendee'] == null
          ? null
          : AttendeeModel.fromJson(json['attendee'] as Map<String, dynamic>);

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'localRef': instance.localRef,
      'evtId': instance.eventId,
      'schId': instance.scheduleId,
      'attendeeId': instance.attendeeId,
      'scannedOn': _$JsonConverterToJson<String, DateTime>(
          instance.scannedOn, const CustomDateTimeConverter().toJson),
      'serverId': instance.serverId,
      'fname': instance.firstName,
      'lname': instance.lastName,
      'isSynced': instance.isSynced,
      'isDeleted': instance.isDeleted,
      'error': instance.error,
      'isCheckIn': instance.isCheckIn,
      'lastCheckTime': _$JsonConverterToJson<String, DateTime>(
          instance.lastCheckTime, const CustomDateTimeConverter().toJson),
      'scans': instance.scans?.map((e) => e.toJson()).toList(),
      'message': instance.errorMessage,
      'attendee': instance.attendee?.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
