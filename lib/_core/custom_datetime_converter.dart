// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_core/constants.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final date = DateTime.parse(
      json,
    );

    final utcDate = DateTime.utc(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );

    return utcDate;
  }

  @override
  String toJson(DateTime json) => kApiDateTimeFormat.format(json.toUtc());
}
