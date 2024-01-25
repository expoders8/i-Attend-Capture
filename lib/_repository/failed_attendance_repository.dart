// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

import '../_core/db_client.dart';
import '../_model/failed_attendance_model.dart';

class FailedAttendanceRepository extends DBClient {
  final store = stringMapStoreFactory.store("failed_attendance");

  static FailedAttendanceRepository get X => Get.find();

  Future<String> insert(FailedAttendanceModel failedAttendanceModel) async {
    return store.add(await db, failedAttendanceModel.toJson());
  }

  Future<List<FailedAttendanceModel>> listByScheduleId(
    num scheduleId, {
    bool? isSynced,
  }) async {
    var finder = Finder(filter: Filter.equals("EventScheduleID", scheduleId));

    if (isSynced != null) {
      finder = Finder(
        filter: Filter.and(
          [
            Filter.equals("EventScheduleID", scheduleId),
            Filter.equals("isSynced", isSynced),
          ],
        ),
      );
    }

    final recordSnapshot = await store.find(
      await db,
      finder: finder,
    );

    if (recordSnapshot.isEmpty) return [];

    return recordSnapshot.map(
      (snapshot) {
        return FailedAttendanceModel.fromJson(snapshot.value)
          ..locRef = snapshot.key;
      },
    ).toList()
      ..sort((a, b) => a.scanTime.compareTo(b.scanTime));
  }

  Future<void> updateSyncStatus(
    List<String> failedSyncIds,
    num scheduleId,
  ) async {
    await (await db).transaction(
      (t) async {
        await store.update(
          t,
          {'isSynced': false, 'isSyncingError': true},
          finder: Finder(
            filter: Filter.and(
              [
                Filter.equals("EventScheduleId", scheduleId),
                Filter.inList('id', failedSyncIds),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> setSyncTrueByScheduleId(num scheduleId) async {
    await store.update(
      await db,
      {'isSynced': true},
      finder: Finder(
        filter: Filter.equals("EventScheduleId", scheduleId),
      ),
    );
  }

  Future<void> deleteStore() async {
    await store.delete(await db);
  }

  // Future<void> bulkInsert(
  //   List<FailedAttendanceModel> attendanceList,
  //   num eventId,
  //   num scheduleId,
  // ) async {
  //   final tempList = await Future.wait(
  //     attendanceList.map((e) async {
  //       e.evtId = eventId;
  //       e.schId = scheduleId;

  //       if (e.attendeeId != null) {
  //         final attendee = await AttendeeRepository.X.get(e.attendeeId!);

  //         e.fname = attendee?.firstName;
  //         e.lname = attendee?.lastName;
  //       }

  //       return e.toJson();
  //     }).toList(),
  //   );

  //   await store.addAll(await db, tempList);
  // }

  Future<List<FailedAttendanceModel>> list({num? schId}) async {
    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: Filter.equals("EventScheduleID", schId),
      ),
    );

    return recordSnapshot.map((snapshot) {
      final attendanceList = FailedAttendanceModel.fromJson(snapshot.value);

      return attendanceList;
    }).toList();
  }
}
