// ignore_for_file: public_member_api_docs

import 'package:i_attend_capture/_core/date_time_extension.dart';
import 'package:intl/intl.dart';

import '../_model/event_model.dart';

/// to get formatted event time
String getEventFormattedTime(
  DateTime startTime,
  DateTime endTime,
) {
  final formattedStartDate =
      DateFormat("MMM dd, yyyy hh:mm aa").format(startTime.toLocal());

  final formattedEndDate = !startTime.toLocal().isSameDay(endTime.toLocal())
      ? DateFormat("MMM dd, yyyy hh:mm aa").format(endTime.toLocal())
      : DateFormat("hh:mm aa").format(endTime.toLocal());

  return "$formattedStartDate - $formattedEndDate";
}

///
DateTime getActualStartDate(
  EventModel eventModel,
  String selectedDateTime, {
  required bool withLoginTime,
}) {
  final today = DateTime.parse(selectedDateTime);

  if (withLoginTime) {
    return today
        .subtract(Duration(minutes: (eventModel.loginTime ?? 0) as int));
  }

  return today;
}

String getCsvFileNameDateFormat(DateTime date) {
  return DateFormat("MMddyy_HHmm").format(date);
}

String getCurrentTimeForCsvLoading() {
  return DateFormat("HHmm").format(DateTime.now());
}

String getCsvLocalToUtcDate(DateTime date) {
  return DateFormat("MM-dd-yyyy").format(date.toLocal());
}

String getCsvLocalToUtcTime(DateTime date) {
  return DateFormat("hh:mm:ss").format(date.toLocal());
}
