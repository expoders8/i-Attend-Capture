// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scan _$ScanFromJson(Map<String, dynamic> json) => Scan(
      localRef: json['localRef'] as String?,
      localAttendanceRef: json['localAttendanceRef'] as String?,
      inPunchTime: _$JsonConverterFromJson<String, DateTime>(
          json['i'], const CustomDateTimeConverter().fromJson),
      outPunchTime: _$JsonConverterFromJson<String, DateTime>(
          json['o'], const CustomDateTimeConverter().fromJson),
      serverId: json['id'] as int?,
      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ScanToJson(Scan instance) => <String, dynamic>{
      'localRef': instance.localRef,
      'localAttendanceRef': instance.localAttendanceRef,
      'i': _$JsonConverterToJson<String, DateTime>(
          instance.inPunchTime, const CustomDateTimeConverter().toJson),
      'o': _$JsonConverterToJson<String, DateTime>(
          instance.outPunchTime, const CustomDateTimeConverter().toJson),
      'id': instance.serverId,
      'isSynced': instance.isSynced,
      'isDeleted': instance.isDeleted,
      'error': instance.error,
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
