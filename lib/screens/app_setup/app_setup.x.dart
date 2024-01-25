// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../_core/utils.dart';
import '../../_state/attendee_service.dart';
import '../../_state/event_service.dart';
import '../event_list/event_list.dart';

class AppSetupX extends GetxController {
  final message = 'Please wait. Your data is being downloaded....'.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          _init();
        },
      );
    });
  }

  Future<void> _init() async {
    try {
      await AttendeeService.X.fetchAttendees(
        updatesCallback: (update) {
          message.value = update;
        },
      );

      await EventService.X.fetchEvents(
        selectedDate: DateTime.now(),
        isSilent: true,
      );

      unawaited(Get.offAllNamed(EventList.page.name));
    } catch (e) {
      await handleDioError(e);
    }
  }
}
