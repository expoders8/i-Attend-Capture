// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'sign_in_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SignInResponseModel {
  @JsonKey(name: "ID")
  int? id;

  @JsonKey(name: "ClientID")
  int? clientId;

  @JsonKey(name: "IsAdmin")
  bool? isAdmin;

  @JsonKey(name: 'message')
  String? errorMessage;

  @JsonKey(name: 'error')
  bool? isError;

  @JsonKey()
  String? username;

  @JsonKey()
  String? organizationId;

  SignInResponseModel({
    this.id,
    this.clientId,
    this.isAdmin,
    this.errorMessage,
    this.isError,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseModelToJson(this);
}
