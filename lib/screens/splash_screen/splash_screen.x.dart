// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../_core/preference_utils.dart';
import '../event_list/event_list.dart';
import '../onboarding_screen/onboarding_screen.dart';
import '../sign_in_screen/sign_in_screen.dart';

class SplashScreenX extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          _init();
        },
      );
    });
  }

  Future<void> _init() async {
    final isFirstTime = PreferenceUtils.getIsFirstTime();
    final loggedInUser = PreferenceUtils.getLoggedInUser();

    if (isFirstTime) {
      await Get.offAndToNamed(OnboardingScreen.page.name);
    } else if (loggedInUser != null) {
      await Get.offAllNamed(EventList.page.name);
    } else {
      await Get.offAndToNamed(SignInScreen.page.name);
    }
  }
}
