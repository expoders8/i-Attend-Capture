// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_sync_res_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSyncResModel _$AttendanceSyncResModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceSyncResModel(
      newAtn: (json['newAtn'] as List<dynamic>?)
          ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      saveRes: (json['saveRes'] as List<dynamic>?)
          ?.map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList(),
      deleteRes: (json['deleteRes'] as List<dynamic>?)
          ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deleteLocal: (json['deleteLocal'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    )..syncDtTm = json['syncDtTm'] as String?;

Map<String, dynamic> _$AttendanceSyncResModelToJson(
        AttendanceSyncResModel instance) =>
    <String, dynamic>{
      'newAtn': instance.newAtn?.map((e) => e.toJson()).toList(),
      'saveRes': instance.saveRes?.map((e) => e.toJson()).toList(),
      'deleteRes': instance.deleteRes?.map((e) => e.toJson()).toList(),
      'deleteLocal': instance.deleteLocal,
      'syncDtTm': instance.syncDtTm,
    };
