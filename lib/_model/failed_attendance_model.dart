// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

import '../_core/custom_datetime_converter.dart';

part 'failed_attendance_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CustomDateTimeConverter()
class FailedAttendanceModel {
  @JsonKey(name: "localRef")
  String? locRef;

  @JsonKey(name: "BadgeId")
  String? badgeId;

  @JsonKey(name: "AttendeeId")
  num? attendeeId;

  @JsonKey()
  String? externalId;

  @JsonKey(name: "EventId")
  num? eventId;

  @JsonKey(name: "EventScheduleId")
  num? scheduleId;

  @JsonKey(name: "scanTime")
  DateTime scanTime;

  @JsonKey(name: "Reason")
  String? failReason;

  @JsonKey()
  num? failId;

  @JsonKey(name: 'lname')
  String? lastName;

  @JsonKey(name: 'fname')
  String? firstName;

  @JsonKey(name: "successId")
  num? serverId;

  @JsonKey()
  bool? isSynced;

  @JsonKey()
  bool? isSyncingError;

  FailedAttendanceModel({
    required this.scanTime,
  });

  factory FailedAttendanceModel.fromJson(Map<String, dynamic> json) {
    return _$FailedAttendanceModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FailedAttendanceModelToJson(this);
}

class FailedAttendanceReasonId {
  static const num invalidBadgeId = 1;
  static const num attendeeNotAllowed = 2;
}
