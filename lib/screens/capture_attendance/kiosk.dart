// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/kiosk_info_tile.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/kiosk_result_overlay.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/scanner_widget.dart';
import 'package:i_attend_capture/screens/capture_attendance/kiosk.x.dart';

import '../../_state/sync_service.dart';
import '../../_widgets/bottom_button.dart';

class Kiosk extends StatelessWidget {
  const Kiosk({super.key});

  static final page = GetPage(
    name: '/kiosk',
    page: () => const Kiosk(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<KioskX>(
      init: KioskX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Capture Kiosk"),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: controller.handleBack,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: controller.gotoHome,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.eventModel.value != null)
                KioskInfoTile(
                  eventModel: controller.eventModel.value!,
                  attendanceCount: controller.attendanceCounter,
                  isCheckIn: controller.isCheckIn.isTrue,
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (controller.showSearchView.isFalse &&
                        controller.showResult.isFalse)
                      Positioned.fill(
                        child: ScannerWidget(
                          cameraController: controller.cameraController,
                          onScanned: controller.onQrCodeDetected,
                        ),
                      ),
                    // if (controller.showSearchView.isTrue)
                    //   Positioned.fill(
                    //     child: AttendeeSearchWidget(
                    //       hintText: 'Search by {Last Name}',
                    //       onSelected: controller.handleAttendeeSelection,
                    //     ),
                    //   ),
                    if (controller.showResult.isTrue &&
                        controller.lastResult != null)
                      Positioned.fill(
                        child: KioskResultOverlay(
                          lastResult: controller.lastResult!,
                        ),
                      ),
                  ],
                ),
              ),
              if (controller.showSearchView.isFalse &&
                  SyncService.X.isAnyDataForSync.isTrue) ...[
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 60,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: BottomButton(
                        //     title: 'SEARCH',
                        //     onTap: controller.toggleSearchView,
                        //   ),
                        // ),
                        // const VerticalDivider(
                        //   thickness: 1,
                        //   color: Colors.black,
                        // ),
                        Expanded(
                          child: BottomButton(
                            title: 'SYNC',
                            onTap: controller.syncData,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
