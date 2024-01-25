// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

import '../_core/custom_datetime_converter.dart';

part 'event_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CustomDateTimeConverter()
class EventModel {
  @JsonKey(name: 'ID')
  num? eventId;

  @JsonKey(name: 'EventScheduleID')
  num? scheduleId;

  @JsonKey(name: 'EventName')
  String eventName;

  @JsonKey(name: 'Description')
  String? description;

  @JsonKey(name: 'Presenter')
  String? instructor;

  @JsonKey(name: 'StartTime')
  DateTime startTime;

  @JsonKey()
  int? startTimeEpoch;

  @JsonKey(name: 'EndTime')
  DateTime endTime;

  @JsonKey()
  int? endTimeEpoch;

  @JsonKey(name: 'Points')
  double? points;

  @JsonKey(name: 'AllowCheckouts')
  bool? allowCheckouts;

  @JsonKey(name: 'AttendanceCount')
  num? attendanceCount;

  @JsonKey(name: 'LoginTime')
  num? loginTime;

  @JsonKey(name: 'LateAttendance')
  num? lateAttendance;

  @JsonKey(name: 'RoomName')
  String? roomName;

  @JsonKey(name: 'AllowOnTimeReg')
  bool? allowOnTimeReg;

  @JsonKey(name: 'IsAllDayEvent')
  bool? isAllDayEvent;

  @JsonKey(name: 'IsSignReq')
  bool? isSignReq;

  @JsonKey(name: 'IsRecurringEvent')
  bool? isRecurringEvent;

  @JsonKey(name: 'IsMultiDayEvent')
  bool? isMultiDayEvent;

  @JsonKey(name: 'message')
  String? errorMessage;

  @JsonKey(name: 'error')
  bool? isError;

  @JsonKey(name: 'syncDtTmStr')
  String? syncDtTm;

  @JsonKey()
  bool isDeleted;

  EventActiveStatus get status {
    final currentTime = DateTime.now().toUtc();
    if (currentTime.isAfter(
            startTime.subtract(Duration(minutes: (loginTime ?? 0).toInt()))) &&
        currentTime.isBefore(
            endTime.add(Duration(minutes: (lateAttendance ?? 0).toInt())))) {
      return EventActiveStatus.activeEvent;
    } else if (currentTime.isBefore(startTime) &&
        currentTime.isBefore(endTime)) {
      return EventActiveStatus.futureEvent;
    } else {
      return EventActiveStatus.pastEvent;
    }
  }

  EventModel({
    this.eventId,
    this.scheduleId,
    required this.eventName,
    this.description,
    this.instructor,
    required this.startTime,
    this.startTimeEpoch,
    this.points,
    this.allowCheckouts,
    this.attendanceCount,
    required this.endTime,
    this.endTimeEpoch,
    this.loginTime,
    this.lateAttendance,
    this.roomName,
    this.allowOnTimeReg,
    this.isAllDayEvent,
    this.isSignReq,
    this.isRecurringEvent,
    this.isMultiDayEvent,
    this.isDeleted = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final data = _$EventModelFromJson(json);

    data.startTimeEpoch = data.startTime.millisecondsSinceEpoch;
    data.endTimeEpoch = data.endTime.millisecondsSinceEpoch;

    return data;
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}

enum EventActiveStatus { pastEvent, activeEvent, futureEvent }
