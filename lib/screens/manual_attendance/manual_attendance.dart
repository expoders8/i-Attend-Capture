import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/manual_attendance/manual_attendance.x.dart';

import '../../_widgets/user_attendance_card.dart';
import '../event_list/event_list.dart';

///
class ManualAttendance extends StatelessWidget {
  ///
  const ManualAttendance({super.key});

  ///
  static final page =
      GetPage(name: '/manual_attendance', page: () => const ManualAttendance());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManualAttendanceX>(
      init: ManualAttendanceX(),
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Manual Attendance"),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Get.offAllNamed(EventList.page.name);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search...',
                      suffixIcon: const Icon(Icons.clear),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: const <Widget>[UserAttendanceCard()],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
