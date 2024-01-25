// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:i_attend_capture/_state/app_service.dart';

import '../_core/notification_utils.dart';
import '../_core/preference_utils.dart';
import '../_provider/event_provider.dart';
import '../_repository/event_repository.dart';
import '../screens/event_details/event_details.x.dart';
import '../screens/event_list/event_list.x.dart';
import '../screens/view_attendance/view_attendance.x.dart';

class EventService extends GetxService {
  static EventService get X => Get.find();

  Future<void> fetchEvents({
    DateTime? selectedDate,
    bool isSilent = false,
  }) async {
    try {
      if (!isSilent) {
        AppService.X.loaderRx(true);
      }

      final plusDays = PreferenceUtils.getSettings().syncEventDays + 3;

      final date =
          (selectedDate ?? DateTime.now()).subtract(const Duration(days: 3));

      final savedIds = await EventRepository.X.getSavedScheduleIds();

      final eventListModel = await EventProvider.X.fetchEventList(
        date: date,
        plusDays: plusDays,
        savedId: savedIds,
      );

      if (eventListModel.isError ?? false) {
        NotificationUtils.showErrorSnackBar(
          message: eventListModel.errorMessage ??
              "Something went wrong while signing in.".tr,
        );

        return;
      }

      if ((eventListModel.events ?? []).isNotEmpty) {
        await EventRepository.X.addOrUpdate(eventListModel.events!);
      }

      if ((eventListModel.deletedIds ?? []).isNotEmpty) {
        await EventRepository.X.deleteByScheduleIds(eventListModel.deletedIds!);
      }
    } finally {
      if (Get.isRegistered<EventListX>()) {
        await Get.find<EventListX>().updateEventsToShow();
      }

      if (Get.isRegistered<EventDetailsX>()) {
        Get.find<EventDetailsX>().revalidate();
      }

      if (Get.isRegistered<ViewAttendanceX>()) {
        Get.find<ViewAttendanceX>().revalidate();
      }

      if (!isSilent) {
        AppService.X.loaderRx(false);
      }
    }
  }

  Future<List<DateTime>> getEventDates({
    required DateTime from,
    required DateTime till,
  }) async =>
      EventProvider.X.fetchEventDates(
        from: from,
        till: till,
      );
}
