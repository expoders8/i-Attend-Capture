// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/settings/_widget/login_dialog.dart';
import 'package:i_attend_capture/screens/settings/_widget/sync_frequency_dialog.dart';

import '../../_core/notification_utils.dart';
import '../../_state/app_service.dart';
import '_widget/setting_tile_item.dart';
import 'settings_screen.x.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final page = GetPage(
    name: '/settings',
    page: () => const SettingsScreen(),
  );

  @override
  Widget build(BuildContext context) {
    const double dividerThickness = 1;

    return GetBuilder<SettingsScreenX>(
      init: SettingsScreenX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF673BB7),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                }),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: AppService.X.gotoHome,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 10),
            children: <Widget>[
              // SettingSwitchItem(
              //   switchTitle: "Attendance Confirmation",
              //   value:
              //       controller.settings.value?.attendanceConfirmation ?? false,
              //   callback: ({required value}) async {
              //     await controller.updateAttendanceConfirmation(value);
              //   },
              // ),
              // const Divider(thickness: dividerThickness),
              // SettingSwitchItem(
              //   switchTitle: "Success Sound",
              //   value: SettingsScreenX.X.settings.value?.successSound ?? false,
              //   callback: ({required value}) {
              //     return controller.updateSuccessSound(value);
              //   },
              // ),
              // const Divider(thickness: dividerThickness),
              // SettingSwitchItem(
              //   switchTitle: "Failure Sound",
              //   value: SettingsScreenX.X.settings.value?.failureSound ?? false,
              //   callback: ({required value}) =>
              //       controller.updateFailureSound(value),
              // ),
              // const Divider(thickness: dividerThickness),
              SettingTileItem(
                title: "Periodic Sync",
                subTitle: controller.syncFrequencyString,
                callback: () async => Get.dialog(const SyncFrequencyDialog()),
              ),
              const Divider(thickness: dividerThickness),
              // SettingTileItem(
              //   title: "Mobile Configuration",
              //   callback: () async {
              //     if ((await Get.dialog(LoginDialog())) == true) {
              //       await Get.dialog(const CodeConfiguration());
              //     }
              //   },
              // ),
              // const Divider(thickness: dividerThickness),
              // SettingTileItem(
              //   title: "Organization ID",
              //   subTitle: controller.settings.value?.organizationId ?? "",
              //   callback: () async {
              //     if (await Get.dialog(LoginDialog()) == true) {
              //       await Get.dialog(OrganizationIdDialog());
              //     }
              //   },
              // ),
              // const Divider(thickness: dividerThickness),
              // SettingTileItem(
              //   title: "Sync Events",
              //   subTitle: controller.syncEventDaysString,
              //   callback: () async => Get.dialog(const SyncEventDialog()),
              // ),
              // const Divider(thickness: dividerThickness),
              SettingTileItem(
                title: "Export Attendance to CSV file",
                subTitle: "All Attendance data will be written to a CSV file.",
                callback: controller.exportAttendanceToCsv,
              ),
              const Divider(thickness: dividerThickness),
              SettingTileItem(
                title: "Reset Application",
                subTitle: "Deletes All Events & Attendance Data",
                callback: () async {
                  if (await Get.dialog(LoginDialog()) == true) {
                    await NotificationUtils.showAlert(
                      content:
                          "Resetting App will erase all the data and all attendance data. Do you really want to reset?",
                      btnNegative: "No",
                      btnPositive: "Yes",
                      btnNegativeCallback: Get.back,
                      btnPositiveCallback: () {
                        Get.back();
                        controller.resetApplication();
                      },
                    );
                  }
                },
              ),
              const Divider(thickness: dividerThickness),
              SettingTileItem(title: "About", callback: controller.gotoAboutUs),
              const Divider(thickness: dividerThickness),
            ],
          ),
        );
      },
    );
  }
}
