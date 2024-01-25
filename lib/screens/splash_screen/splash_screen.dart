// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/splash_screen/splash_screen.x.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static final page = GetPage(
    name: '/',
    page: () => const SplashScreen(),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenX>(
      init: SplashScreenX(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xff374A67),
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        child: TweenAnimationBuilder(
                          duration: 1.seconds,
                          tween: Tween<double>(begin: 1.0, end: 32.0),
                          builder: (
                            BuildContext context,
                            double value,
                            Widget? child,
                          ) {
                            return Text(
                              "i-Attend CAPTURE",
                              style: TextStyle(
                                fontSize: value,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TweenAnimationBuilder(
                      duration: 1.seconds,
                      tween: Tween<double>(begin: 1.0, end: 14.0),
                      builder:
                          (BuildContext context, double value, Widget? child) {
                        return Column(
                          children: const [
                            Text(
                              "This app works in conjunction with i-Attend CLOUD.",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Developed by TNETIC, Inc.",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Copyright ©. All rights reserved.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
