// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/attendee_model.dart';
import 'package:i_attend_capture/_model/scan.dart';
import 'package:json_annotation/json_annotation.dart';

import '../_core/custom_datetime_converter.dart';

part 'attendance_model.g.dart';

@JsonSerializable(explicitToJson: true)
@CustomDateTimeConverter()
class AttendanceModel {
  @JsonKey(name: 'localRef')
  String? localRef;

  @JsonKey(name: 'evtId')
  num? eventId;

  @JsonKey(name: 'schId')
  num? scheduleId;

  @JsonKey(name: 'attendeeId')
  num? attendeeId;

  @JsonKey(name: 'scannedOn')
  DateTime? scannedOn;

  @JsonKey(name: 'serverId')
  int? serverId;

  @JsonKey(name: 'fname')
  String? firstName;

  @JsonKey(name: 'lname')
  String? lastName;

  @JsonKey(name: 'isSynced')
  bool isSynced;

  @JsonKey(name: 'isDeleted')
  bool isDeleted;

  @JsonKey(name: 'error')
  String? error;

  @JsonKey(name: 'isCheckIn')
  bool? isCheckIn;

  @JsonKey(name: 'lastCheckTime')
  DateTime? lastCheckTime;

  @JsonKey(name: 'scans')
  List<Scan>? scans;

  @JsonKey(name: 'message')
  String? errorMessage;

  AttendeeModel? attendee;

  Scan? get lastScan {
    if (scans != null && scans!.isNotEmpty) {
      return scans!.last;
    } else {
      return null;
    }
  }

  AttendanceModel({
    this.eventId,
    this.scheduleId,
    this.attendeeId,
    this.scannedOn,
    this.serverId,
    this.firstName,
    this.lastName,
    this.isSynced = false,
    this.isDeleted = false,
    this.error,
    this.isCheckIn,
    this.lastCheckTime,
    this.scans,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return _$AttendanceModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}
