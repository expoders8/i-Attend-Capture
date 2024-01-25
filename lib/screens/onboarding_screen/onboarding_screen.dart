// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/onboarding_screen/widget/onboarding_page.dart';

import '../../_core/preference_utils.dart';
import '../sign_in_screen/sign_in_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static final page = GetPage(
    name: '/onboarding_screen',
    page: () => const OnboardingScreen(),
  );

  Future<void> _goToSignInScreen() async {
    await PreferenceUtils.setIsFirstTime(isOnboardingShown: true);
    await Get.offAllNamed(SignInScreen.page.name);
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'GO TO LOGIN',
      onFinish: _goToSignInScreen,
      finishButtonStyle: const FinishButtonStyle(
        backgroundColor: Colors.blue,
      ),
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: _goToSignInScreen,
      controllerColor: Colors.blue,
      totalPage: 4,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: const [
        SizedBox(),
        SizedBox(),
        SizedBox(),
        SizedBox(),
      ],
      speed: 1.8,
      pageBodies: const [
        OnboardingPage(
          image: 'assets/images/create_event_icon3.png',
          title: 'Create Events',
          body:
              'Create events and manage attendance data. You can create events for a single day or multiple days.',
        ),
        OnboardingPage(
          image: 'assets/images/mark_attendance_icon_2.png',
          title: 'Capture Attendance',
          body:
              'Capture attendance by scanning badges with RFID, QR Code or Barcode. You can always do a name lookup if badges are not available.',
        ),
        OnboardingPage(
          image: 'assets/images/attendance_icon_2.png',
          title: 'View Attendance',
          body:
              'View attendance data by event or participant. Access check-in and check-out times of participants.',
        ),
        OnboardingPage(
          image: 'assets/images/sync_icon_2.png',
          title: 'Sync Attendance',
          body:
              'Choose how often you want to sync attendance to the server. Designed carefully for your convenience and efficiency.',
        ),
      ],
    );
  }
}
