// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

import '../_core/constants.dart';

part 'settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SettingsModel {
  @JsonKey(name: 'attendanceConfirmation')
  bool? attendanceConfirmation;

  @JsonKey(name: 'successSound')
  bool? successSound;

  @JsonKey(name: 'failureSound')
  bool? failureSound;

  @JsonKey(name: 'periodicSync')
  num? periodicSync;

  @JsonKey(name: 'mobileConfiguration')
  String? mobileConfiguration;

  @JsonKey(name: 'organizationId')
  String? organizationId;

  @JsonKey(name: 'syncEventDays')
  int syncEventDays;

  @JsonKey(name: 'token')
  String? token;

  SettingsModel({
    this.attendanceConfirmation = false,
    this.successSound = false,
    this.failureSound = false,
    this.periodicSync = 5,
    this.mobileConfiguration = "",
    this.organizationId = "",
    this.syncEventDays = kDefaultSyncEventDays,
    this.token = "",
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
