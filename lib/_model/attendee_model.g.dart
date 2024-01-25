// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendeeModel _$AttendeeModelFromJson(Map<String, dynamic> json) =>
    AttendeeModel(
      attendeeId: json['ID'] as num?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      emailId: json['EmailAddress'] as String?,
      badgeId: json['BadgeID'] as String?,
      externalID: json['ExternalID'] as String?,
      photo: json['Photo'] as String?,
      company: json['company'] as String?,
      address1: json['Address1'] as String?,
      address2: json['Address2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      mobile: json['phone'] as String?,
      isVIP: json['isVIP'] as bool?,
    );

Map<String, dynamic> _$AttendeeModelToJson(AttendeeModel instance) =>
    <String, dynamic>{
      'ID': instance.attendeeId,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'EmailAddress': instance.emailId,
      'BadgeID': instance.badgeId,
      'ExternalID': instance.externalID,
      'Photo': instance.photo,
      'company': instance.company,
      'Address1': instance.address1,
      'Address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'phone': instance.mobile,
      'isVIP': instance.isVIP,
    };
