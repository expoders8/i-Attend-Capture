// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/participant_list/widget/attendee_search_widget.dart';

import '../event_list/event_list.dart';

class ParticipantList extends StatelessWidget {
  final String hintText;

  const ParticipantList({
    super.key,
    this.hintText = "Search Participant",
  });

  static final page = GetPage(
    name: '/participant_list',
    page: () => const ParticipantList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Participant List"),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.person_add_alt_1),
          //   onPressed: () {
          //     Get.dialog(const AddParticipantsDialog());
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Get.offAllNamed(EventList.page.name);
            },
          ),
        ],
      ),
      body: const AttendeeSearchWidget(),
    );
  }
}
