// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/app_setup/app_setup.x.dart';

class AppSetup extends StatelessWidget {
  const AppSetup({super.key});

  static final page = GetPage(
    name: '/app-setup',
    page: () => const AppSetup(),
  );

  @override
  Widget build(BuildContext context) {
    return GetX<AppSetupX>(
      init: AppSetupX(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset("assets/images/cube_loading.gif"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    controller.message.value,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
