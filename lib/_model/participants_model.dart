// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/attendee_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participants_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ParticipantsModel {
  @JsonKey(name: 'lastSync')
  String? lastSync;

  @JsonKey(name: 'attendees')
  final List<AttendeeModel>? attendees;

  @JsonKey()
  final List<int>? deletedIds;

  ParticipantsModel(this.deletedIds, {this.lastSync, this.attendees});

  factory ParticipantsModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantsModelToJson(this);
}
