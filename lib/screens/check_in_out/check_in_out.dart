// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/check_in_out/check_in_out.x.dart';

import '../../_widgets/user_check_in_card.dart';

class CheckInOut extends StatelessWidget {
  const CheckInOut({super.key});

  static final page =
      GetPage(name: '/check_in_out', page: () => const CheckInOut());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInOutX>(
      init: CheckInOutX(),
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Check In/Out"),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: const <Widget>[
                    UserCheckInCard(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
