// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/scanner_widget.dart';
import 'package:i_attend_capture/screens/capture_attendance/qr_scanner.x.dart';

import '../../_state/app_service.dart';
import '../../_state/sync_service.dart';

class QRScanner extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRScanner({Key? key}) : super(key: key);

  static final page = GetPage(
    name: '/qr_scanner',
    page: () => QRScanner(),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: QrScannerX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF673BB7),
            title: const Text(
              "Scan Name Badge",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
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
                  Icons.sync,
                  color: Colors.white,
                ),
                onPressed: SyncService.X.sync,
              ),
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: AppService.X.gotoHome,
              ),
            ],
          ),
          body: ScannerWidget(
            cameraController: controller.cameraController,
            onScanned: controller.handleBadge,
          ),
        );
      },
    );
  }
}
