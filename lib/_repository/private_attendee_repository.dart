// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

import '../_core/db_client.dart';
import '../_model/private_attendee_model.dart';

class PrivateAttendeeRepository extends DBClient {
  final store = intMapStoreFactory.store("private_attendee");

  static PrivateAttendeeRepository get X => Get.find();

  Future<void> addOrUpdate(PrivateAttendeeModel privateAttendee) async {
    final rec = await store.findFirst(
      await db,
      finder: Finder(filter: Filter.equals("eventId", privateAttendee.eventId)),
    );
    if (rec != null) {
      await update(privateAttendee, rec.key);
    } else {
      await insert(privateAttendee);
    }
  }

  Future<int> insert(PrivateAttendeeModel failedAttendanceModel) async =>
      store.add(await db, failedAttendanceModel.toJson());

  Future<void> update(PrivateAttendeeModel attendee, int id) async =>
      store.record(id).update(await db, attendee.toJson());

  Future<PrivateAttendeeModel?> getByEventId(num eventId) async {
    final finder = Finder(
      filter: Filter.equals("eventId", eventId),
    );

    final record = await store.findFirst(await db, finder: finder);

    if (record == null) {
      return null;
    }

    return PrivateAttendeeModel.fromJson(record.value);
  }

  Future<void> addOrUpdateByEventId(
    num eventId,
    PrivateAttendeeModel privateAttendee,
  ) async {
    final rec = await store.findFirst(
      await db,
      finder: Finder(filter: Filter.equals("eventId", eventId)),
    );
    if (rec != null) {
      await update(privateAttendee, rec.key);
    } else {
      await insert(privateAttendee);
    }
  }

  Future<void> deleteStore() async {
    await store.delete(await db);
  }

  Future<bool> isPrivateAttendeeExist(num eventId) async =>
      (await getByEventId(eventId)) != null;

  Future<List<num>> getPrivateAttendeeIds(num eventId) async =>
      (await getByEventId(eventId))?.attendeeIdList ?? [];
}
