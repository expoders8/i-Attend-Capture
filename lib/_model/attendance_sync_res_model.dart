// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/attendance_model.dart';
import 'package:i_attend_capture/_model/scan.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_sync_res_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceSyncResModel {
  @JsonKey(name: 'newAtn')
  final List<AttendanceModel>? newAtn;

  @JsonKey(name: 'saveRes')
  final List<Scan>? saveRes;

  @JsonKey(name: 'deleteRes')
  final List<AttendanceModel>? deleteRes;

  @JsonKey(name: 'deleteLocal')
  final List<int>? deleteLocal;

  @JsonKey(name: 'syncDtTm')
  String? syncDtTm;

  AttendanceSyncResModel({
    this.newAtn,
    this.saveRes,
    this.deleteRes,
    this.deleteLocal,
  });

  factory AttendanceSyncResModel.fromJson(Map<String, dynamic> json) {
    return _$AttendanceSyncResModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AttendanceSyncResModelToJson(this);
}
