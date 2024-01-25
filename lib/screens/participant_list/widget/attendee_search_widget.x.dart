// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../_core/logger.dart';
import '../../../_model/attendee_model.dart';
import '../../../_repository/attendee_repository.dart';

class AttendeeSearchWidgetX extends GetxController {
  final pageSize = 20;

  final searchController = TextEditingController();

  final query = RxnString();

  final PagingController<int, AttendeeModel> pagingController =
      PagingController(
    firstPageKey: 0,
  );

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  void _init() {
    pagingController.addPageRequestListener(
      (pageKey) async => listAttendees(page: pageKey),
    );

    debounce(
      query,
      (value) {
        pagingController.refresh();
      },
      time: 500.milliseconds,
    );
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> setQuery(String? query) async => this.query.value = query;

  Future<void> clearQuery() async {
    query.value = null;
    searchController.text = "";
  }

  Future<void> listAttendees({
    int page = 0,
  }) async {
    try {
      final offset = page * pageSize;

      final List<AttendeeModel> attendeesList =
          await AttendeeRepository.X.getAttendees(
        offset: offset,
        pageSize: pageSize,
        query: query.value,
      );

      logger.i("getAttendeesList : ${attendeesList.length}");

      if (pageSize > attendeesList.length) {
        pagingController.appendLastPage(attendeesList);
      } else {
        pagingController.appendPage(attendeesList, page + 1);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
