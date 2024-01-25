// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/view_scans/view_scans.x.dart';
import 'package:i_attend_capture/screens/view_scans/widget/scan_list_item.dart';

class ViewScans extends StatelessWidget {
  const ViewScans({super.key});

  static final page = GetPage(
    name: '/view_scans',
    page: () => const ViewScans(),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewScansX>(
      init: ViewScansX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text("Check In/Out"),
          ),
          body: SafeArea(
            child: Obx(
              () {
                if (controller.attendance.value?.scans?.isNotEmpty ?? false) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.attendance.value!.scans!.length,
                    itemBuilder: (context, index) => ScanListItem(
                      attendee: controller.attendee.value!,
                      attendance: controller.attendance.value!,
                      event: controller.eventModel.value!,
                      scan: controller.attendance.value!.scans![index],
                      onDeleteTap: controller.onDeleteTap,
                      onEditTap: controller.onEditTap,
                    ),
                  );
                }

                return const Center(
                  child: Text("No data found"),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
