// ignore_for_file: public_member_api_docs, must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_attend_capture/screens/capture_attendance/_widget/qr_scanner_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerWidget extends StatefulWidget {
  final MobileScannerController cameraController;
  final Function(String) onScanned;

  const ScannerWidget({
    super.key,
    required this.cameraController,
    required this.onScanned,
  });

  @override
  State<ScannerWidget> createState() => __QrCodeScannerState();
}

class __QrCodeScannerState extends State<ScannerWidget> {
  Timer? _timer;
  final qrKey = GlobalKey(debugLabel: 'QR');
  final getStorage = GetStorage();
  int selectScanner = 2;

  @override
  void initState() {
    super.initState();
    setSelectScanner();
    //var data = getStorage.read('selectScanner');
  }

  Future<void> setSelectScanner() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt('selectScanner');
    setState(() {
      selectScanner = data ?? 2;
    });
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "", true, ScanMode.BARCODE);
  //     if (_timer == null || !_timer!.isActive) {
  //       debugPrint('Barcode found! $barcodeScanRes');
  //       widget.onScanned(barcodeScanRes);
  //       _timer = Timer(const Duration(seconds: 2), () {});
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280
        : 330.0;
    return Scaffold(
        body: Stack(
      children: [
        selectScanner == 1
            ? Positioned.fill(
                child: MobileScanner(
                  controller: widget.cameraController,
                  onDetect: (capture) async {
                    //if (_timer == null || !_timer!.isActive) {
                    final List barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                        widget.onScanned(barcode.rawValue!);
                      }
                    }

                    // _timer = Timer(const Duration(seconds: 2), () {
                    //   //Pausing Camera for 3 seconds for next scan
                    // });
                    //}
                  },
                  scanWindow: Rect.fromCenter(
                    center: MediaQuery.of(context).size.center(Offset.zero),
                    width: scanArea,
                    height: scanArea,
                  ),
                  overlay: const QRScannerOverlay(
                    overlayColor: Colors.black54,
                  ),
                  onScannerStarted: (arguments) => {
                    //check debug app
                  },
                ),
              )
            : QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
              ),
        selectScanner == 1
            ? Container()
            : Center(
                child: Lottie.asset(
                  'assets/scan2.json',
                  width: 330,
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ),
        Positioned(
          top: -9,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selectScanner = 2;
                      });
                      getStorage.write('selectScanner', 2);
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('selectScanner', 2);
                    },
                    child: Container(
                      color: selectScanner == 2
                          ? Colors.white
                          : const Color.fromARGB(255, 203, 205, 208),
                      width: Get.width / 2,
                      height: 50,
                      child: Center(
                        child: Text(
                          "QR Code",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        selectScanner = 1;
                      });
                      getStorage.write('selectScanner', 1);
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('selectScanner', 1);
                    },
                    child: Container(
                      color: selectScanner == 1
                          ? Colors.white
                          : const Color.fromARGB(255, 203, 205, 208),
                      width: Get.width / 2,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Barcode",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              child: Text(
                "Position your Barcode or QR Code inside the viewfinder box to scan it.",
                textAlign: TextAlign.center,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Place the QR code in the viewfinder to scan.',
              style: Get.textTheme.titleMedium?.copyWith(
                color: Colors.white54,
              ),
            ),
          ),
        ))
      ],
    ));

    //     Stack(
    //   children: [
    //     Positioned.fill(
    //       child: MobileScanner(
    //         controller: widget.cameraController,
    //         onDetect: (capture) async {
    //           //if (_timer == null || !_timer!.isActive) {
    //           final List barcodes = capture.barcodes;
    //           for (final barcode in barcodes) {
    //             if (barcode.rawValue != null) {
    //               debugPrint('Barcode found! ${barcode.rawValue}');
    //               widget.onScanned(barcode.rawValue!);
    //             }
    //           }

    //           // _timer = Timer(const Duration(seconds: 2), () {
    //           //   //Pausing Camera for 3 seconds for next scan
    //           // });
    //           //}
    //         },
    //         scanWindow: Rect.fromCenter(
    //           center: MediaQuery.of(context).size.center(Offset.zero),
    //           width: scanArea,
    //           height: scanArea,
    //         ),
    //         overlay: const QRScannerOverlay(
    //           overlayColor: Colors.black54,
    //         ),
    //         onScannerStarted: (arguments) => {
    //           //check debug app
    //         },
    //       ),
    //     ),
    //     Align(
    //       alignment: Alignment.topCenter,
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           "Position your Barcode or QR Code inside the viewfinder box to scan it.",
    //           textAlign: TextAlign.center,
    //           style: Get.textTheme.titleMedium?.copyWith(
    //             color: Colors.white54,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Text(
    //           'Place the QR code in the viewfinder to scan.',
    //           style: Get.textTheme.titleMedium?.copyWith(
    //             color: Colors.white54,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen(
      (scanData) {
        // controller.dispose();
        if (_timer == null || !_timer!.isActive) {
          debugPrint('Barcode found! ${scanData.code}');
          widget.onScanned(scanData.code!);

          _timer = Timer(const Duration(seconds: 10), () {
            //Pausing Camera for 3 seconds for next scan
          });
        }
        // Navigator.pop(context, scanData.code);
      },
    );
  }

  // @override
  // void dispose() {
  //   widget.cameraController.stop();
  //   widget.cameraController.dispose();
  //   _timer?.cancel();
  //   super.dispose();
  // }
}
