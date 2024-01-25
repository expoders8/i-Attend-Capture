// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

import '../_core/db_client.dart';
import '../_core/utils.dart';
import '../_model/attendance_model.dart';
import '../_model/scan.dart';

class AttendanceRepository extends DBClient {
  final store = stringMapStoreFactory.store("attendance");

  static AttendanceRepository get X => Get.find();

  Future<void> setError(List<num> serverIds, String error) async {
    await store.update(
      await db,
      {"error": error},
      finder: Finder(
        filter: Filter.inList("serverId", serverIds),
      ),
    );
  }

  Future<bool> isAttendanceExistForSync(List<num> scheduleIds) async {
    final finder = Finder(
      filter: Filter.and(
        [
          Filter.inList("schId", scheduleIds),
          Filter.equals("scans.@.isSynced", false),
        ],
      ),
    );

    final attendanceData =
        (await store.find(await db, finder: finder)).where((element) {
      return element.value['error'] == null;
    });

    return attendanceData.isNotEmpty;
  }

  Future<String> insert(AttendanceModel attendanceModel) async {
    final _id = generateLocalRef();
    attendanceModel.localRef = _id;

    await store.record(_id).add(await db, attendanceModel.toJson());

    return _id;
  }

  Future<void> update(AttendanceModel attendanceModel, String id) async {
    await store.record(id).update(
          await db,
          attendanceModel.toJson(),
        );
  }

  Future<AttendanceModel?> get(String id) async {
    final recordSnapshot = await store.record(id).get(await db);

    if (recordSnapshot == null) {
      return null;
    }

    return AttendanceModel.fromJson(recordSnapshot);
  }

  Future<Map<num, AttendanceModel>?> getByAttendeesMapAttendeeIds(
    List<num> attendeeIds,
  ) async {
    final finder = Finder(
      filter: Filter.inList("attendeeId", attendeeIds),
    );

    final recordSnapshot = await store.find(await db, finder: finder);

    if (recordSnapshot.isEmpty) {
      return null;
    }

    final attendees = recordSnapshot.map(
      (e) => AttendanceModel.fromJson(e.value),
    );

    return {for (var attendee in attendees) attendee.attendeeId!: attendee};
  }

  Future<List<AttendanceModel>> listAttendance({
    num? scheduleId,
    num? attendeeId,
  }) async {
    final filters = <Filter>[];

    if (scheduleId != null) {
      filters.add(Filter.equals("schId", scheduleId));
    }

    if (attendeeId != null) {
      filters.add(Filter.equals("attendeeId", attendeeId));
    }

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: Filter.and(filters),
        sortOrders: [
          SortOrder('scannedOn', false),
          SortOrder('lname'),
          SortOrder('fname'),
        ],
      ),
    );

    return recordSnapshot
        .map((snapshot) => AttendanceModel.fromJson(snapshot.value))
        .toList();
  }

  Future<Map<num, AttendanceModel>> listAttendanceAsMap(int? scheduleId) async {
    final attendance = await listAttendance(scheduleId: scheduleId);

    final attendanceMap = <num, AttendanceModel>{};
    for (final element in attendance) {
      attendanceMap.putIfAbsent(element.attendeeId!, () => element);
    }

    return attendanceMap;
  }

  Future<void> deleteStore() async {
    await store.delete(await db);
  }

  Future<void> addOrUpdateAfterSync({
    required List<AttendanceModel> attendanceList,
    required num eventId,
    required num scheduleId,
  }) async {
    for (final attendance in attendanceList) {
      final rec = await store.findFirst(
        await db,
        finder: Finder(
          filter: Filter.and(
            [
              Filter.equals("attendeeId", attendance.attendeeId),
              Filter.equals("schId", scheduleId),
              Filter.equals("evtId", eventId),
            ],
          ),
        ),
      );

      if (rec != null) {
        final oldRec = AttendanceModel.fromJson(rec.value);
        oldRec.attendeeId = attendance.attendeeId;
        oldRec.firstName = attendance.firstName;
        oldRec.lastName = attendance.lastName;

        oldRec.scans ??= [];

        final newScanMapByServerId = {
          for (final s in attendance.scans!) s.serverId: s
        };

        // check if scan is already exist
        final updatedScanIds = <num>[];
        oldRec.scans?.forEach((scan) {
          if (scan.serverId != null &&
              newScanMapByServerId.containsKey(scan.serverId)) {
            final newScan = newScanMapByServerId[scan.serverId]!;
            scan.inPunchTime = newScan.inPunchTime;
            scan.outPunchTime = newScan.outPunchTime;
            scan.isSynced = true;
            updatedScanIds.add(scan.serverId!);
          }
        });

        attendance.scans?.removeWhere(
          (scan) => updatedScanIds.contains(scan.serverId),
        );

        attendance.scans?.forEach((scan) {
          scan.isSynced = true;
          scan.localRef = generateLocalRef();
        });

        oldRec.scans?.addAll(attendance.scans ?? []);

        attendance.isSynced =
            oldRec.scans?.any((scan) => scan.error != null) ?? false;

        await update(oldRec, rec.key);
      } else {
        attendance.eventId = eventId;
        attendance.scheduleId = scheduleId;
        attendance.scans?.forEach((scan) {
          scan.isSynced = true;
          scan.localRef = generateLocalRef();
        });
        attendance.isSynced = true;

        await insert(attendance);
      }
    }
  }

  Future<Set<int>> listScheduleIds({bool? isSynced}) async {
    final filters = <Filter>[
      Filter.equals("isDeleted", false),
    ];

    if (isSynced != null) {
      filters.add(Filter.equals("scans.@.isSynced", isSynced));
    }

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(filter: Filter.and(filters)),
    );

    final listOfScheduleIds = recordSnapshot
        .map((snapshot) => AttendanceModel.fromJson(snapshot.value))
        .where((e) => e.scheduleId != null)
        .map((e) => e.scheduleId!)
        .toList();

    return Set.of(listOfScheduleIds as Iterable<int>);
  }

  Future<List<num>> listEventIds({bool? isSynced}) async {
    final filters = <Filter>[
      Filter.equals("isDeleted", false),
    ];

    if (isSynced != null) {
      filters.add(Filter.equals("scans.@.isSynced", isSynced));
    }

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(filter: Filter.and(filters)),
    );

    final listOfEventIds = recordSnapshot
        .map((snapshot) => AttendanceModel.fromJson(snapshot.value))
        .where((e) => e.eventId != null)
        .map((e) => e.eventId!)
        .toList();

    return Set.of(listOfEventIds).toList();
  }

  Future<List<num>> listOfSyncedScanServerIds(num scheduleId) async {
    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: Filter.equals("schId", scheduleId),
      ),
    );

    final listOfScanServerIds = recordSnapshot
        .map((snapshot) => AttendanceModel.fromJson(snapshot.value))
        .where(
          (e) =>
              e.serverId != null &&
              e.scans != null &&
              (e.scans?.isNotEmpty ?? false) &&
              (e.scans ?? []).any((element) => element.serverId != null),
        )
        .map((e) => (e.scans ?? [])
            .where((element) => element.serverId != null)
            .map((e) => e.serverId!)
            .toList())
        .reduce((value, element) {
      value.addAll(element);
      return value;
    });

    return listOfScanServerIds;
  }

  Future<num> isAttendanceExistForScheduleId(List<num> scheduleIds) async {
    final recordSnapshot = await store.find(
      await db,
      finder: Finder(filter: Filter.inList("schId", scheduleIds)),
    );

    return recordSnapshot.length;
  }

  Future<void> deleteAttendanceWithNoScans() async {
    final recordSnapshot = await store.find(await db);

    for (final record in recordSnapshot) {
      final attendance = AttendanceModel.fromJson(record.value);
      if ((attendance.scans ?? []).isEmpty) {
        await store.record(record.key).delete(await db);
      }
    }
  }

  Future<void> deleteByServerIds(num scheduleId, List<num> serverIds) async {
    final recordSnapshot = await store.find(
      await db,
      finder: Finder(filter: Filter.equals("schId", scheduleId)),
    );

    for (final record in recordSnapshot) {
      final attendance = AttendanceModel.fromJson(record.value);

      if (attendance.scans?.any((scan) => serverIds.contains(scan.serverId)) ==
          false) {
        continue;
      }

      attendance.scans?.removeWhere(
        (element) => serverIds.contains(element.serverId),
      );
      await store.record(record.key).update(
            await db,
            attendance.toJson(),
          );
    }
  }

  Future<void> updateScansForSyncStatus(
    num scheduleId,
    List<Scan> scans,
  ) async {
    if (scans.isEmpty) {
      return;
    }

    final scansMapByLocalRef = {for (var item in scans) item.localRef: item};

    final localRefs =
        scansMapByLocalRef.keys.where((key) => key != null).toList();

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: Filter.equals("schId", scheduleId),
      ),
    );

    for (final record in recordSnapshot) {
      final attendance = AttendanceModel.fromJson(record.value);

      if (attendance.scans?.any((scan) => localRefs.contains(scan.localRef)) ==
          false) {
        continue;
      }

      attendance.scans ??= [];

      var atnSynced = true;
      attendance.scans?.forEach((scan) {
        final scanToUpdate = scansMapByLocalRef[scan.localRef];
        if (scanToUpdate != null) {
          if (scanToUpdate.error?.isNotEmpty ?? false) {
            scan.error = scanToUpdate.error;
            scan.isSynced = false;
            atnSynced = false;
          } else {
            scan.serverId = scanToUpdate.serverId;
            scan.error = null;
            scan.isSynced = true;
          }
        }
      });

      attendance.isSynced = atnSynced;

      await store.record(record.key).update(
            await db,
            attendance.toJson(),
          );
    }
  }

  Future<void> updateScans(List<Scan> scans) async {
    final scansMapByLocalRef = {for (var item in scans) item.localRef: item};

    final localRefs =
        scansMapByLocalRef.keys.where((key) => key != null).toList();

    final recordSnapshot = await store.find(await db);

    for (final record in recordSnapshot) {
      final attendance = AttendanceModel.fromJson(record.value);

      if (attendance.scans?.any((scan) => localRefs.contains(scan.localRef)) ==
          false) {
        continue;
      }

      attendance.scans ??= [];

      var atnSynced = true;
      attendance.scans?.forEach((scan) {
        final scanToUpdate = scansMapByLocalRef[scan.localRef];
        if (scanToUpdate != null) {
          scan.inPunchTime = scanToUpdate.inPunchTime;
          scan.outPunchTime = scanToUpdate.outPunchTime;
          scan.isSynced = scanToUpdate.isSynced;
          atnSynced = scan.isSynced;
          scansMapByLocalRef.remove(scan.localRef);
        }
      });

      attendance.isSynced = atnSynced;

      await store.record(record.key).update(
            await db,
            attendance.toJson(),
          );
    }
  }

  Future<void> deleteScan(
    num? scheduleId,
    num attendeeId,
    String localRef,
  ) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals("schId", scheduleId),
        Filter.equals("attendeeId", attendeeId),
        Filter.equals("scans.@.localRef", localRef),
      ]),
    );

    final recordSnapshot = await store.find(await db, finder: finder);

    if (recordSnapshot.isNotEmpty) {
      final attendance = AttendanceModel.fromJson(recordSnapshot.first.value);

      final scanIndex = attendance.scans
          ?.indexWhere((element) => element.localRef == localRef);

      if (scanIndex == null || scanIndex == -1) {
        return;
      }

      final scan = attendance.scans![scanIndex];

      if (scan.isSynced) {
        attendance.scans!.removeAt(scanIndex);
      } else {
        scan.isDeleted = true;
        scan.isSynced = false;

        attendance.scans![scanIndex] = scan;
      }

      await store.record(recordSnapshot.first.key).update(
            await db,
            attendance.toJson(),
          );
    }
  }

  Future<void> addOrUpdate(AttendanceModel attendance) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals("schId", attendance.scheduleId),
        Filter.equals("attendeeId", attendance.attendeeId),
      ]),
    );

    final recordSnapshot = await store.find(await db, finder: finder);

    if (recordSnapshot.isNotEmpty) {
      await store.record(recordSnapshot.first.key).update(
            await db,
            attendance.toJson(),
          );
    } else {
      await store.add(await db, attendance.toJson());
    }
  }

  Future<void> updateAttendance(AttendanceModel attendance) async {
    await store.update(
      await db,
      attendance.toJson(),
      finder: Finder(
        filter: Filter.and([
          Filter.equals("schId", attendance.scheduleId),
          Filter.equals("attendeeId", attendance.attendeeId),
        ]),
      ),
    );
  }
}
