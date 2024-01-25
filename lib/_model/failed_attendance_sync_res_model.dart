// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/failed_attendance_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'failed_attendance_sync_res_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FailedAttendanceSyncResModel {
  @JsonKey(name: "newScans")
  List<FailedAttendanceModel>? failedNewAttendanceList;

  @JsonKey(name: 'saveErr')
  List<String>? failedSync;

  @JsonKey(name: 'syncDtTm')
  String? syncDtTm;

  FailedAttendanceSyncResModel();

  factory FailedAttendanceSyncResModel.fromJson(Map<String, dynamic> json) {
    return _$FailedAttendanceSyncResModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FailedAttendanceSyncResModelToJson(this);
}
