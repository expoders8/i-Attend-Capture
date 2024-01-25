// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_core/date_time_extension.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../_core/color_constants.dart';
import '../../_core/notification_utils.dart';
import '../../_core/utils.dart';
import '../../_model/event_model.dart';
import '../../_repository/event_repository.dart';
import '../../_state/app_service.dart';
import '../../_state/event_service.dart';
import '../participant_list/participant_list.dart';
import '../settings/settings_screen.dart';

class EventListX extends GetxController {
  final calendarFormat = CalendarFormat.month.obs;

  final selectedDay = DateTime.now().obs;

  final eventDates = <DateTime>{}.obs;

  final bgColor = colorPastEventCardBackground.obs;

  final eventList = <EventModel>[].obs;

  static EventListX get X => Get.find();

  @override
  void onInit() {
    super.onInit();
    if (AppService.X.loggedInUser.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        syncEvents();
        fetchMonthEventDates(selectedDay.value);
      });
    }
  }

  void gotoParticipantList() {
    if (AppService.X.loggedInUser.value?.isAdmin ?? false) {
      Get.toNamed(ParticipantList.page.name);
    } else {
      NotificationUtils.showErrorSnackBar(
        message: "Only Administrators have access to this function.",
      );
    }
  }

  Future<void> gotoSettings() async {
    await Get.toNamed(SettingsScreen.page.name);
  }

  Future<void> logout() async => AppService.X.signOut();

  Future<void> syncEvents() async {
    try {
      await EventService.X.fetchEvents(selectedDate: selectedDay.value);
    } catch (e) {
      await handleDioError(e, onReAuthenticated: syncEvents);
    }
  }

  Future<void> setSelectedDate(DateTime date) async {
    selectedDay(date);
    await updateEventsToShow(fetchIfEmpty: true);
  }

  Future<void> updateEventsToShow({
    fetchIfEmpty = false,
  }) async {
    eventList.value = await EventRepository.X.getEventList(
      sod: selectedDay.value.startOfDay,
      eod: selectedDay.value.endOfDay,
    );

    // if (eventList.isEmpty && fetchIfEmpty) {
    //   await EventService.X.fetchEvents(
    //     selectedDate: selectedDay.value,
    //     isSilent: true,
    //   );
    //   eventList.value = await EventRepository.X.getEventList(
    //     sod: selectedDay.value.startOfDay,
    //     eod: selectedDay.value.endOfDay,
    //   );
    // }
    update();
  }

  Future<void> fetchMonthEventDates(DateTime selectedDay) async {
    try {
      final eventDatesRes = await EventService.X.getEventDates(
        from: selectedDay.firstDayOfMonth,
        till: selectedDay.lastDayOfMonth,
      );
      eventDates.addAll(eventDatesRes);
      update();
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    }
  }
}
