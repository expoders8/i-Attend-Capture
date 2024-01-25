// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantsModel _$ParticipantsModelFromJson(Map<String, dynamic> json) =>
    ParticipantsModel(
      (json['deletedIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
      lastSync: json['lastSync'] as String?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => AttendeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParticipantsModelToJson(ParticipantsModel instance) =>
    <String, dynamic>{
      'lastSync': instance.lastSync,
      'attendees': instance.attendees?.map((e) => e.toJson()).toList(),
      'deletedIds': instance.deletedIds,
    };
