// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_model/private_attendee_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'private_attendee_res_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivateAttendeeResModel {
  @JsonKey(name: 'DeletedIds')
  List<num>? deletedAttendeeList;

  @JsonKey(name: 'privateAttendeeData')
  PrivateAttendeeModel? privateAttendees;

  PrivateAttendeeResModel();

  factory PrivateAttendeeResModel.fromJson(Map<String, dynamic> json) {
    return _$PrivateAttendeeResModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PrivateAttendeeResModelToJson(this);
}
