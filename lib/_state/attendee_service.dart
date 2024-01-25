// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

import '../_core/preference_utils.dart';
import '../_provider/attendee_provider.dart';
import '../_repository/attendee_repository.dart';
import '../_repository/private_attendee_repository.dart';

class AttendeeService extends GetxService {
  static AttendeeService get X => Get.find();

  Future<void> fetchAttendees({
    Function(String)? updatesCallback,
  }) async {
    updatesCallback?.call("Establishing a secure and encrypted connection...");

    final lastSync = PreferenceUtils.getLastAttendeeFetched();

    final response = await AttendeeProvider.X.fetchAttendeeList(lastSync);

    updatesCallback
        ?.call("Almost there. Your data is being stored and processed...");

    // if (eventListModel?.isError ?? false) {
    //   showSnackBar(eventListModel?.errorMessage ??
    //       "Something went wrong while signing in.".tr);
    //   return;
    // }

    if ((response.attendees ?? []).isNotEmpty) {
      await Get.find<AttendeeRepository>().addOrUpdateList(response.attendees!);

      await PreferenceUtils.setLastAttendeeFetched(response.lastSync ?? "");
    }

    if ((response.deletedIds ?? []).isNotEmpty) {
      await Get.find<AttendeeRepository>().deleteByIds(response.deletedIds!);
    }

    updatesCallback?.call("You are all set! Thank you for your patience.");
  }

  Future<void> fetchPrivateAttendees(num eventId) async {
    final privateAttendees =
        await PrivateAttendeeRepository.X.getByEventId(eventId);

    final savedAttendeeIdList = privateAttendees?.attendeeIdList;

    final lastSync = privateAttendees?.lastPrivateSyncedOn;

    final response = await AttendeeProvider.X.fetchPrivateAttendee(
      eventId: eventId,
      lastSync: lastSync ?? "",
      savedIds: savedAttendeeIdList ?? [],
    );

    final attendeeIdsSet = Set<num>.from(savedAttendeeIdList ?? []);

    attendeeIdsSet.addAll(response.privateAttendees?.attendeeIdList ?? []);

    response.deletedAttendeeList?.forEach((attendeeId) {
      attendeeIdsSet.remove(attendeeId);
    });

    response.privateAttendees?.attendeeIdList = attendeeIdsSet.toList();

    await PrivateAttendeeRepository.X.addOrUpdateByEventId(
      eventId,
      response.privateAttendees!,
    );
  }
}
