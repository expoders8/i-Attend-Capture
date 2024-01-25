// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/event_list/event_list.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  static final page = GetPage(name: '/about_us', page: () => const AboutUs());
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Get.offAllNamed(EventList.page.name);
            },
          ),
        ],
      ),
      // appBar: AppBar(
      //   title: const Text("Settings"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       onPressed: () {
      //         Get.offAllNamed(EventList.page.name);
      //       },
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Text(
              "i-Attend Capture :  No More Pen and Paper Sign-in Sheets!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "i-Attend Capture is designed to be your hero in accurately capturing Attendance and Registration for Events, Classes, Continuing Education, Training, Conferences, Workshops and  other Meets! This application supports RFID, Barcode and Name Look-up to authenticate your attendees.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text:
                        "i-Attend Capture works in conjunction with i-Attend Cloud. Please visit ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                    text: "http://www.i-Attend.com ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = "http://www.i-Attend.com";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                  const TextSpan(
                    style: TextStyle(color: Colors.black),
                    text: "for more information.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Created with love by TNETIC, Inc., a Chicago company."),
          ],
        ),
      ),
    );
  }
}
