// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'attendee_model.g.dart';

@JsonSerializable(explicitToJson: true)

///
class AttendeeModel {
  @JsonKey(name: 'ID')
  num? attendeeId;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'EmailAddress')
  String? emailId;

  @JsonKey(name: 'BadgeID')
  String? badgeId;

  @JsonKey(name: 'ExternalID')
  String? externalID;

  @JsonKey(name: 'Photo')
  String? photo;

  @JsonKey(name: 'company')
  String? company;

  @JsonKey(name: 'Address1')
  String? address1;

  @JsonKey(name: 'Address2')
  String? address2;

  @JsonKey(name: 'city')
  String? city;

  @JsonKey(name: 'state')
  String? state;

  @JsonKey(name: 'zip')
  String? zip;

  @JsonKey(name: 'phone')
  String? mobile;

  @JsonKey(name: 'isVIP')
  bool? isVIP;

  AttendeeModel({
    this.attendeeId,
    this.firstName,
    this.lastName,
    this.emailId,
    this.badgeId,
    this.externalID,
    this.photo,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.mobile,
    this.isVIP,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) =>
      _$AttendeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendeeModelToJson(this);
}
