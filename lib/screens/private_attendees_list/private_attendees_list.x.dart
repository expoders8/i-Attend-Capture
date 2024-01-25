// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

import '../../_model/attendee_model.dart';
import '../../_model/event_model.dart';
import '../../_repository/attendee_repository.dart';
import '../../_repository/private_attendee_repository.dart';
import '../../_state/attendee_service.dart';

class PrivateAttendeesListX extends GetxController {
  final attendees = <AttendeeModel>[].obs;

  EventModel? eventModel;

  static PrivateAttendeesListX get X => Get.find();

  @override
  void onInit() {
    super.onInit();
    eventModel = Get.arguments as EventModel;

    fetchPrivateAttendees();
  }

  Future<void> fetchPrivateAttendees() async {
    await AttendeeService.X.fetchPrivateAttendees(eventModel!.eventId!);

    final privateAttendee = await PrivateAttendeeRepository.X.getByEventId(
      eventModel!.eventId!,
    );

    attendees.value = await AttendeeRepository.X
        .listByIds(privateAttendee?.attendeeIdList ?? []);
  }
}
