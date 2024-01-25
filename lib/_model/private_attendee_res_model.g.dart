// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_attendee_res_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateAttendeeResModel _$PrivateAttendeeResModelFromJson(
        Map<String, dynamic> json) =>
    PrivateAttendeeResModel()
      ..deletedAttendeeList =
          (json['DeletedIds'] as List<dynamic>?)?.map((e) => e as num).toList()
      ..privateAttendees = json['privateAttendeeData'] == null
          ? null
          : PrivateAttendeeModel.fromJson(
              json['privateAttendeeData'] as Map<String, dynamic>);

Map<String, dynamic> _$PrivateAttendeeResModelToJson(
        PrivateAttendeeResModel instance) =>
    <String, dynamic>{
      'DeletedIds': instance.deletedAttendeeList,
      'privateAttendeeData': instance.privateAttendees?.toJson(),
    };
