// ignore_for_file: public_member_api_docs

extension DateTimeExtension on DateTime {
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get lastDayOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  DateTime get startOfDay => DateTime(year, month, day, 0, 0, 0);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  bool isSameDay(DateTime date) => date.difference(this).inDays == 0;
}
