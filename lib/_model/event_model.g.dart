// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      eventId: json['ID'] as num?,
      scheduleId: json['EventScheduleID'] as num?,
      eventName: json['EventName'] as String,
      description: json['Description'] as String?,
      instructor: json['Presenter'] as String?,
      startTime:
          const CustomDateTimeConverter().fromJson(json['StartTime'] as String),
      startTimeEpoch: json['startTimeEpoch'] as int?,
      points: (json['Points'] as num?)?.toDouble(),
      allowCheckouts: json['AllowCheckouts'] as bool?,
      attendanceCount: json['AttendanceCount'] as num?,
      endTime:
          const CustomDateTimeConverter().fromJson(json['EndTime'] as String),
      endTimeEpoch: json['endTimeEpoch'] as int?,
      loginTime: json['LoginTime'] as num?,
      lateAttendance: json['LateAttendance'] as num?,
      roomName: json['RoomName'] as String?,
      allowOnTimeReg: json['AllowOnTimeReg'] as bool?,
      isAllDayEvent: json['IsAllDayEvent'] as bool?,
      isSignReq: json['IsSignReq'] as bool?,
      isRecurringEvent: json['IsRecurringEvent'] as bool?,
      isMultiDayEvent: json['IsMultiDayEvent'] as bool?,
      isDeleted: json['isDeleted'] as bool? ?? false,
    )
      ..errorMessage = json['message'] as String?
      ..isError = json['error'] as bool?
      ..syncDtTm = json['syncDtTmStr'] as String?;

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'ID': instance.eventId,
      'EventScheduleID': instance.scheduleId,
      'EventName': instance.eventName,
      'Description': instance.description,
      'Presenter': instance.instructor,
      'StartTime': const CustomDateTimeConverter().toJson(instance.startTime),
      'startTimeEpoch': instance.startTimeEpoch,
      'EndTime': const CustomDateTimeConverter().toJson(instance.endTime),
      'endTimeEpoch': instance.endTimeEpoch,
      'Points': instance.points,
      'AllowCheckouts': instance.allowCheckouts,
      'AttendanceCount': instance.attendanceCount,
      'LoginTime': instance.loginTime,
      'LateAttendance': instance.lateAttendance,
      'RoomName': instance.roomName,
      'AllowOnTimeReg': instance.allowOnTimeReg,
      'IsAllDayEvent': instance.isAllDayEvent,
      'IsSignReq': instance.isSignReq,
      'IsRecurringEvent': instance.isRecurringEvent,
      'IsMultiDayEvent': instance.isMultiDayEvent,
      'message': instance.errorMessage,
      'error': instance.isError,
      'syncDtTmStr': instance.syncDtTm,
      'isDeleted': instance.isDeleted,
    };
