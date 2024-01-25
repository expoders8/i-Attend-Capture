// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'private_attendee_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivateAttendeeModel {
  @JsonKey(name: "eventId")
  num eventId;

  @JsonKey(name: "attendees")
  List<num> attendeeIdList;

  @JsonKey(name: "lastPrivateSyncedOn")
  String lastPrivateSyncedOn;

  PrivateAttendeeModel({
    required this.eventId,
    required this.attendeeIdList,
    required this.lastPrivateSyncedOn,
  });

  factory PrivateAttendeeModel.fromJson(Map<String, dynamic> json) {
    return _$PrivateAttendeeModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PrivateAttendeeModelToJson(this);
}
