// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/notification_utils.dart';
import '../../../_core/preference_utils.dart';
import '../../settings/_widget/login_dialog.dart';

enum KioskModePinDialogMode {
  lock,
  unlock,
}

class KioskModePinDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final KioskModePinDialogMode mode;
  final Function() onProceed;

  KioskModePinDialog({
    super.key,
    required this.mode,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    String? pin;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pin",
                    style: Get.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  const Text("Enter PIN to lock/unlock Kiosk Mode"),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) =>
                        value?.isEmpty ?? true ? "Required" : null,
                    onSaved: (newValue) {
                      setState(() {
                        pin = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.pin),
                      border: OutlineInputBorder(),
                      labelText: "Enter PIN-CODE",
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: Get.back,
                        child: Text(
                          "Cancel",
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (mode == KioskModePinDialogMode.unlock)
                        TextButton(
                          onPressed: () async {
                            if (await Get.dialog(LoginDialog()) == true) {
                              onProceed();
                            }
                          },
                          child: const Text("Forgot PIN?"),
                        ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }

                          _formKey.currentState?.save();

                          if (mode == KioskModePinDialogMode.unlock) {
                            if (PreferenceUtils.getKioskModePin() == pin) {
                              Get.back();
                              onProceed();
                            } else {
                              NotificationUtils.showErrorSnackBar(
                                message: "Please provide correct PIN",
                              );
                            }
                          } else {
                            await PreferenceUtils.setKioskModePin(pin!);
                            Get.back();
                            onProceed();
                          }
                        },
                        child: const Text("Proceed"),
                      ),
                    ],
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
