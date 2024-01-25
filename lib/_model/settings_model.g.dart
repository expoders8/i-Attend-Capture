// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      attendanceConfirmation: json['attendanceConfirmation'] as bool? ?? false,
      successSound: json['successSound'] as bool? ?? false,
      failureSound: json['failureSound'] as bool? ?? false,
      periodicSync: json['periodicSync'] as num? ?? 5,
      mobileConfiguration: json['mobileConfiguration'] as String? ?? "",
      organizationId: json['organizationId'] as String? ?? "",
      syncEventDays: json['syncEventDays'] as int? ?? kDefaultSyncEventDays,
      token: json['token'] as String? ?? "",
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'attendanceConfirmation': instance.attendanceConfirmation,
      'successSound': instance.successSound,
      'failureSound': instance.failureSound,
      'periodicSync': instance.periodicSync,
      'mobileConfiguration': instance.mobileConfiguration,
      'organizationId': instance.organizationId,
      'syncEventDays': instance.syncEventDays,
      'token': instance.token,
    };
