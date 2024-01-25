// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_attendee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateAttendeeModel _$PrivateAttendeeModelFromJson(
        Map<String, dynamic> json) =>
    PrivateAttendeeModel(
      eventId: json['eventId'] as num,
      attendeeIdList:
          (json['attendees'] as List<dynamic>).map((e) => e as num).toList(),
      lastPrivateSyncedOn: json['lastPrivateSyncedOn'] as String,
    );

Map<String, dynamic> _$PrivateAttendeeModelToJson(
        PrivateAttendeeModel instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'attendees': instance.attendeeIdList,
      'lastPrivateSyncedOn': instance.lastPrivateSyncedOn,
    };
