// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:get/get.dart';

import '../_core/dio_client.dart';
import '../_model/participants_model.dart';
import '../_model/private_attendee_res_model.dart';
import '../_state/app_service.dart';

class AttendeeProvider extends DioClient {
  static AttendeeProvider get X => Get.find();

  Future<ParticipantsModel> fetchAttendeeList(String? lastSync) async {
    final result = await post(
      '${AppService.X.baseUrl}/Api/Attendee/List',
      data: json.encode({
        "lastSync": lastSync,
      }),
    );

    return ParticipantsModel.fromJson(result.data as Map<String, dynamic>);
  }

  Future<PrivateAttendeeResModel> fetchPrivateAttendee({
    required num eventId,
    required String lastSync,
    required List<num> savedIds,
  }) async {
    final result = await post(
      '${AppService.X.baseUrl}/Api/Attendee/ListPrivateAttendee',
      query: {
        "eventId": eventId,
        "lastSyncDt": lastSync,
      },
      data: json.encode({
        "SavedIDs": savedIds,
      }),
    );

    return PrivateAttendeeResModel.fromJson(
      result.data as Map<String, dynamic>,
    );
  }
}
