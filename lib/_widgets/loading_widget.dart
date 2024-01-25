// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../_state/app_service.dart';

class LoadingScreen {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      return builder != null
          ? builder(context, LoadingCustom(child: child!))
          : LoadingCustom(child: child!);
    };
  }
}

class LoadingCustom extends StatelessWidget {
  final Widget child;

  const LoadingCustom({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          child,
          if (AppService.X.loaderRx.value)
            ColoredBox(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (!AppService.X.loaderRx.value) Container(),
        ],
      ),
    );
  }
}
