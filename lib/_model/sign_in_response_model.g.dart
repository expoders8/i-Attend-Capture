// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponseModel _$SignInResponseModelFromJson(Map<String, dynamic> json) =>
    SignInResponseModel(
      id: json['ID'] as int?,
      clientId: json['ClientID'] as int?,
      isAdmin: json['IsAdmin'] as bool?,
      errorMessage: json['message'] as String?,
      isError: json['error'] as bool?,
    )
      ..username = json['username'] as String?
      ..organizationId = json['organizationId'] as String?;

Map<String, dynamic> _$SignInResponseModelToJson(
        SignInResponseModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'ClientID': instance.clientId,
      'IsAdmin': instance.isAdmin,
      'message': instance.errorMessage,
      'error': instance.isError,
      'username': instance.username,
      'organizationId': instance.organizationId,
    };
