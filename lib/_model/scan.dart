// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

import '../_core/custom_datetime_converter.dart';

part 'scan.g.dart';

@JsonSerializable(explicitToJson: true)
@CustomDateTimeConverter()
class Scan {
  @JsonKey(name: 'localRef')
  String? localRef;

  @JsonKey(name: 'localAttendanceRef')
  String? localAttendanceRef;

  @JsonKey(name: 'i')
  DateTime? inPunchTime;

  @JsonKey(name: 'o')
  DateTime? outPunchTime;

  @JsonKey(name: 'id')
  int? serverId;

  @JsonKey(name: 'isSynced')
  bool isSynced;

  @JsonKey(name: 'isDeleted')
  bool isDeleted;

  @JsonKey(name: 'error')
  String? error;

  Scan({
    this.localRef,
    this.localAttendanceRef,
    this.inPunchTime,
    this.outPunchTime,
    this.serverId,
    this.isSynced = false,
    this.isDeleted = false,
    this.error,
  });

  DateTime? get recentPunchTime {
    if (outPunchTime != null) {
      return outPunchTime;
    }

    if (inPunchTime != null) {
      return inPunchTime;
    }

    return null;
  }

  factory Scan.fromJson(Map<String, dynamic> json) {
    return _$ScanFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScanToJson(this);
}
