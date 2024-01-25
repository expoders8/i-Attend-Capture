// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventListModel _$EventListModelFromJson(Map<String, dynamic> json) =>
    EventListModel(
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deletedIds:
          (json['deletedIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
      errorMessage: json['message'] as String?,
      isError: json['error'] as bool?,
    );

Map<String, dynamic> _$EventListModelToJson(EventListModel instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'deletedIds': instance.deletedIds,
      'message': instance.errorMessage,
      'error': instance.isError,
    };
