// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:i_attend_capture/_repository/private_attendee_repository.dart';
import 'package:sembast/sembast.dart';

import '../_core/db_client.dart';
import '../_model/attendee_model.dart';
import '../_model/event_model.dart';

class AttendeeRepository extends DBClient {
  final store = intMapStoreFactory.store("attendee");
  List<Filter> filters = [];
  static AttendeeRepository get X => Get.find();

  Future<void> addOrUpdate(AttendeeModel attendee) async {
    final rec = await store.findFirst(
      await db,
      finder: Finder(filter: Filter.equals("ID", attendee.attendeeId)),
    );

    attendee.firstName = attendee.firstName?.trim();
    attendee.lastName = attendee.lastName?.trim();

    if (rec != null) {
      await update(attendee, rec.key);
    } else {
      await insert(attendee);
    }
  }

  Future<void> addOrUpdateList(List<AttendeeModel> attendees) async {
    await (await db).transaction((t) async {
      for (final attendee in attendees) {
        final rec = await store.findFirst(
          t,
          finder: Finder(filter: Filter.equals("ID", attendee.attendeeId)),
        );

        if (rec != null) {
          final curAttendee = AttendeeModel.fromJson(rec.value);
          curAttendee.firstName =
              attendee.firstName?.trim() ?? curAttendee.firstName;
          curAttendee.lastName =
              attendee.lastName?.trim() ?? curAttendee.lastName;
          curAttendee.badgeId = attendee.badgeId?.trim() ?? curAttendee.badgeId;
          curAttendee.emailId = attendee.emailId?.trim() ?? curAttendee.emailId;
          curAttendee.externalID =
              attendee.externalID?.trim() ?? curAttendee.externalID;
          curAttendee.photo = attendee.photo?.trim() ?? curAttendee.photo;

          await store.record(rec.key).update(t, curAttendee.toJson());
        } else {
          await store.add(t, attendee.toJson());
        }
      }
    });
  }

  Future<int> insert(AttendeeModel failedAttendanceModel) async =>
      store.add(await db, failedAttendanceModel.toJson());

  Future<void> update(AttendeeModel attendee, int id) async =>
      store.record(id).update(await db, attendee.toJson());

  Future<List<AttendeeModel>> getAttendees({
    int? offset,
    int? pageSize,
    String? query,
  }) async {
    final filters = <Filter>[];
    if (query != "clear") {
      if ((query ?? "").isNotEmpty) {
        var queryParts = query!.split(',');

        var lastNameQuery = queryParts.length > 0 ? queryParts[0].trim() : "";
        var firstNameQuery = queryParts.length > 1 ? queryParts[1].trim() : "";
        filters.add(
          Filter.matchesRegExp(
            "LastName",
            RegExp(lastNameQuery, caseSensitive: false),
          ),
        );

        filters.add(
          Filter.matchesRegExp(
            "FirstName",
            RegExp(firstNameQuery, caseSensitive: false),
          ),
        );
      }
      print("filter $filters");

      final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [
          SortOrder("LastName"),
          SortOrder("FirstName"),
          SortOrder("EmailAddress"),
        ],
        limit: pageSize,
        offset: offset,
      );

      final recordSnapshot = await store.find(await db, finder: finder);
      print("fillter data $recordSnapshot");
      return recordSnapshot.map((snapshot) {
        final attendee = AttendeeModel.fromJson(snapshot.value);

        return attendee;
      }).toList();
    } else {
      print("clear");
      var userInputQuery = "Smithsdfsdfsd, Johnsdfsdfsdfsdfsdfsdfsdf";
      applyFilters(userInputQuery);
    }
    return [];

    // final filters = <Filter>[];

    // if ((query ?? "").isNotEmpty) {
    //   var queryParts = query!.split(',');

    //   var lastNameQuery = queryParts.length > 0 ? queryParts[0].trim() : "";
    //   var firstNameQuery = queryParts.length > 1 ? queryParts[1].trim() : "";

    //   if (lastNameQuery.isNotEmpty && lastNameQuery != "") {
    //     filters.add(
    //       Filter.matchesRegExp(
    //         "LastName",
    //         RegExp(lastNameQuery, caseSensitive: false),
    //       ),
    //     );
    //   }

    //   if (firstNameQuery.isNotEmpty && firstNameQuery != "") {
    //     filters.add(
    //       Filter.matchesRegExp(
    //         "FirstName",
    //         RegExp(firstNameQuery, caseSensitive: false),
    //       ),
    //     );
    //   }
    // }
    // final finder = Finder(
    //   filter: Filter.and(filters),
    //   sortOrders: [
    //     SortOrder("LastName"),
    //     SortOrder("FirstName"),
    //     SortOrder("EmailAddress"),
    //   ],
    //   limit: pageSize,
    //   offset: offset,
    // );

    // final recordSnapshot = await store.find(await db, finder: finder);
  }

  void applyFilters(String query) {
    filters.clear();
    var queryParts = query.split(',');
    var lastNameQuery = queryParts.length > 0 ? queryParts[0].trim() : "";
    var firstNameQuery = queryParts.length > 1 ? queryParts[1].trim() : "";
    filters.add(
      Filter.matchesRegExp(
        "LastName",
        RegExp(lastNameQuery, caseSensitive: false),
      ),
    );
    filters.add(
      Filter.matchesRegExp(
        "FirstName",
        RegExp(firstNameQuery, caseSensitive: false),
      ),
    );
  }

  Future<AttendeeModel?> get(num id) async {
    final finder = Finder(
      filter: Filter.equals("ID", id),
    );

    final record = await store.findFirst(await db, finder: finder);

    if (record == null) {
      return null;
    }

    return AttendeeModel.fromJson(record.value);
  }

  Future<AttendeeModel?> getByBadgeId(String badgeId) async {
    final finder = Finder(
      filter: Filter.matchesRegExp(
        "BadgeID",
        RegExp('^$badgeId\$', caseSensitive: false),
      ),
    );

    final record = await store.findFirst(await db, finder: finder);

    if (record == null) {
      return null;
    }

    return AttendeeModel.fromJson(record.value);
  }

  Future<AttendeeModel?> getByExternalId(String externalId) async {
    final finder = Finder(
      filter: Filter.matchesRegExp(
        "ExternalID",
        RegExp('^$externalId\$', caseSensitive: false),
      ),
    );

    final record = await store.findFirst(await db, finder: finder);

    if (record == null) {
      return null;
    }

    return AttendeeModel.fromJson(record.value);
  }

  Future<void> deleteByIds(List<int> ids) async {
    await store.delete(
      await db,
      finder: Finder(filter: Filter.inList("ID", ids)),
    );
  }

  Future<void> deleteStore() async {
    await store.delete(await db);
  }

  Future<List<AttendeeModel>> listByIds(List<num> ids) async {
    final finder = Finder(
      filter: Filter.inList("ID", ids),
      sortOrders: [
        SortOrder("LastName"),
        SortOrder("FirstName"),
        SortOrder("EmailAddress"),
      ],
    );

    final recordSnapshot = await store.find(
      await db,
      finder: finder,
    );

    return recordSnapshot
        .map((snapshot) => AttendeeModel.fromJson(snapshot.value))
        .toList();
  }

  Future<List<AttendeeModel>> listForManualAttendance({
    required EventModel event,
    String? search,
    int offset = 0,
    int pageSize = 10,
  }) async {
    final filters = <Filter>[];

    final sortOrders = [
      SortOrder("LastName"),
      SortOrder("FirstName"),
      SortOrder("EmailAddress"),
    ];

    final allowedAttendeeIds = await Get.find<PrivateAttendeeRepository>()
        .getPrivateAttendeeIds(event.eventId!);

    if ((event.allowOnTimeReg ?? false) == true &&
        allowedAttendeeIds.isNotEmpty) {
      filters.add(Filter.inList("ID", allowedAttendeeIds));
    }

    if (search != null) {
      filters.add(
        Filter.matchesRegExp(
          "LastName",
          RegExp(search, caseSensitive: true),
        ),
      );
    }

    final recordSnapshot = await store.find(
      await db,
      finder: Finder(
        filter: Filter.and(filters),
        sortOrders: sortOrders,
        limit: pageSize,
        offset: offset,
      ),
    );

    return recordSnapshot
        .map((snapshot) => AttendeeModel.fromJson(snapshot.value))
        .toList();
  }
}
