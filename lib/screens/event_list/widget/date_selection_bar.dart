// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_core/date_time_extension.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../_widgets/custom_expansion_tile.dart';
import '../event_list.x.dart';

class DateSelectionBar extends StatelessWidget {
  DateSelectionBar({super.key});

  final expansionTileKey = GlobalKey<CustomExpansionTileState>();

  DateTime _updateDateMonth(DateTime date, bool goNext) {
    return DateTime(
      date.year,
      date.month + (goNext ? 1 : -1),
      date.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    var focusedDate = EventListX.X.selectedDay.value;
    var isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Obx(
            () {
              final eventDates = EventListX.X.eventDates;

              return CustomExpansionTile(
                key: expansionTileKey,
                textColor: Colors.black,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                collapsedTextColor: Colors.black,
                onExpansionChanged: (_isExpanded) {
                  setState(() {
                    isExpanded = _isExpanded;
                    if (isExpanded) {
                      focusedDate = EventListX.X.selectedDay.value;
                    }
                  });
                },
                initiallyExpanded: isExpanded,
                title: Center(
                  child: Text(
                    isExpanded
                        ? DateFormat.yMMM().format(focusedDate)
                        : DateFormat.yMMMEd()
                            .format(EventListX.X.selectedDay.value),
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    if (isExpanded) {
                      // change the month
                      setState(() {
                        focusedDate = _updateDateMonth(focusedDate, false);
                      });
                    } else {
                      // change the date and update also for getting events
                      EventListX.X.setSelectedDate(
                        EventListX.X.selectedDay.value
                            .subtract(const Duration(days: 1)),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (isExpanded) {
                      // change the month
                      setState(() {
                        focusedDate = _updateDateMonth(focusedDate, true);
                      });
                    } else {
                      // change the date and update also for getting events
                      EventListX.X.setSelectedDate(
                        EventListX.X.selectedDay.value
                            .add(const Duration(days: 1)),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                children: [
                  TableCalendar(
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Get.theme.primaryColor,
                          width: 1,
                        ),
                      ),
                      cellMargin: const EdgeInsets.all(2),
                      canMarkersOverflow: false,
                      markersMaxCount: 1,
                      // markersAlignment: Alignment.topCenter,
                      markerSize: 6,
                      markerDecoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      markersAnchor: 2,
                    ),
                    eventLoader: (day) {
                      if (eventDates.any((element) => element.isSameDay(day))) {
                        return [1];
                      }

                      return [];
                    },
                    firstDay: DateTime.utc(1900),
                    lastDay: DateTime.utc(2099, 12, 31),
                    focusedDay: focusedDate,
                    calendarFormat: EventListX.X.calendarFormat.value,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    selectedDayPredicate: (day) =>
                        isSameDay(EventListX.X.selectedDay.value, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        focusedDate = selectedDay;
                      });
                      if (!isSameDay(
                        EventListX.X.selectedDay.value,
                        selectedDay,
                      )) {
                        EventListX.X.setSelectedDate(selectedDay);
                      }
                      expansionTileKey.currentState?.handleTap();
                    },
                    onFormatChanged: (format) {
                      if (EventListX.X.calendarFormat.value != format) {
                        EventListX.X.calendarFormat.value = format;
                      }
                    },
                    onPageChanged: (DateTime _focusedDay) {
                      setState(() {
                        focusedDate = _focusedDay;
                      });
                      EventListX.X.fetchMonthEventDates(_focusedDay);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
