// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/event_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EventListModel {
  @JsonKey(name: 'events')
  final List<EventModel>? events;

  @JsonKey(name: 'deletedIds')
  final List<int>? deletedIds;

  @JsonKey(name: 'message')
  String? errorMessage;

  @JsonKey(name: 'error')
  bool? isError;

  EventListModel({
    this.events,
    this.deletedIds,
    this.errorMessage,
    this.isError,
  });

  factory EventListModel.fromJson(Map<String, dynamic> json) =>
      _$EventListModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventListModelToJson(this);
}
