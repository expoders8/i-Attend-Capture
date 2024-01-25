// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../_core/dio_client.dart';
import '../_model/event_list_model.dart';
import '../_state/app_service.dart';

class EventProvider extends DioClient {
  static EventProvider get X => Get.find();

  Future<EventListModel> fetchEventList({
    required DateTime date,
    required int plusDays,
    List<num>? savedId,
  }) async {
    final result = await post(
      '${AppService.X.baseUrl}/Api/Events/List',
      data: json.encode({
        "eventDate": DateFormat('yyyy-MM-dd').format(date),
        "plusDays": plusDays,
        "savedIds": savedId,
      }),
    );

    return EventListModel.fromJson(result.data as Map<String, dynamic>);
  }

  Future<List<DateTime>> fetchEventDates({
    required DateTime from,
    required DateTime till,
  }) async {
    final result = await get(
      '${AppService.X.baseUrl}/Api/Events/ListDates',
      query: {
        "startDate": from.toString(),
        "endDate": till.toString(),
      },
    );

    return (result.data as List<dynamic>)
        .map((e) => DateTime.parse(e as String))
        .toList();
  }
}
