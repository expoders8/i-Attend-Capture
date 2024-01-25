// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

import '../_core/db_client.dart';
import '../_model/event_model.dart';

class EventRepository extends DBClient {
  final store = intMapStoreFactory.store("event_list");

  static EventRepository get X => Get.find();

  Future<int> insert(EventModel eventModel) async {
    return store.add(await db, eventModel.toJson());
  }

  Future<void> update(EventModel eventModel, int id) async {
    await store.record(id).update(await db, eventModel.toJson());
  }

  Future<List<EventModel>> getEventListForCSV({
    bool isEventDeleted = false,
  }) async {
    final finder = Finder(
      filter: Filter.equals("isDeleted", isEventDeleted),
      sortOrders: [SortOrder("StartTime")],
    );

    final recordSnapshot = await store.find(await db, finder: finder);

    return recordSnapshot
        .map((snapshot) => EventModel.fromJson(snapshot.value))
        .where((element) => !element.isDeleted)
        .toList();
  }

  Future<List<EventModel>> getEventList({
    DateTime? sod,
    DateTime? eod,
  }) async {
    final filters = <Filter>[];
    if (sod != null && eod != null) {
      filters.addAll([
        // startTimeEpoch is between sod and eod
        Filter.and([
          Filter.greaterThanOrEquals(
            'startTimeEpoch',
            sod.millisecondsSinceEpoch,
          ),
          Filter.lessThanOrEquals(
            'startTimeEpoch',
            eod.millisecondsSinceEpoch,
          ),
        ]),
        // endTimeEpoch is between sod and eod
        Filter.and([
          Filter.greaterThanOrEquals(
            'endTimeEpoch',
            sod.millisecondsSinceEpoch,
          ),
          Filter.lessThanOrEquals(
            'endTimeEpoch',
            eod.millisecondsSinceEpoch,
          ),
        ]),
        // startTimeEpoch is less than sod and endTimeEpoch is greater than eod
        Filter.and([
          Filter.lessThanOrEquals(
            'startTimeEpoch',
            sod.millisecondsSinceEpoch,
          ),
          Filter.greaterThanOrEquals(
            'endTimeEpoch',
            eod.millisecondsSinceEpoch,
          ),
        ]),
      ]);
    }

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: filters.isNotEmpty ? Filter.or(filters) : null,
      ),
    );

    return recordSnapshot
        .map((snapshot) => EventModel.fromJson(snapshot.value))
        .where((element) => !element.isDeleted)
        .toList();
  }

  Future<EventModel?> getEventById(num scheduleId) async {
    final finder = Finder(
      filter: Filter.equals("EventScheduleID", scheduleId),
    );

    final eventData = await store.find(await db, finder: finder);

    if (eventData.isEmpty) {
      return null;
    }

    return EventModel.fromJson(eventData.first.value);
  }

  Future<void> addOrUpdate(List<EventModel> eventList) async {
    for (final event in eventList) {
      final rec = await store.findFirst(
        await db,
        finder: Finder(
          filter: Filter.equals("EventScheduleID", event.scheduleId),
        ),
      );
      if (rec != null) {
        await update(event, rec.key);
      } else {
        await insert(event);
      }
    }
  }

  Future<void> deleteByScheduleIds(List<int> scheduleIds) async {
    await store.update(
      await db,
      {"isDeleted": true},
      finder: Finder(
        filter: Filter.inList(
          "EventScheduleID",
          scheduleIds,
        ),
      ),
    );
  }

  Future<void> deleteStore() async {
    await store.delete(await db);
  }

  Future<List<num>> listScheduleIds() async {
    final finder = Finder(
      filter: Filter.equals("isDeleted", false),
    );

    final records = await store.find(await db, finder: finder);

    return records.map((e) => e.value["EventScheduleID"] as num).toList();
  }

  Future<List<num>> getSavedScheduleIds() async {
    final finder = Finder(sortOrders: [SortOrder("EventScheduleID", false)]);

    return (await store.find(await db, finder: finder))
        .map((e) => EventModel.fromJson(e.value))
        .map((e) => e.scheduleId ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  Future<void> updateSyncDtTm(num scheduleId, String lastSyncDtTm) async {
    await store.update(
      await db,
      {"lastSyncDtTm": lastSyncDtTm},
      finder: Finder(
        filter: Filter.equals("EventScheduleID", scheduleId),
      ),
    );
  }
}
