// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_screen.x.dart';

class SyncFrequencyDialog extends StatelessWidget {
  const SyncFrequencyDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Sync Events"),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final val = SettingsScreenX.X.syncFrequency[index];
            final isManual = val == -1;

            return Obx(
              () => RadioListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                value: val,
                title: Text(
                  isManual
                      ? 'Manual'
                      : val == 60
                          ? '1 hour'
                          : '$val min',
                ),
                groupValue: SettingsScreenX.X.syncFrequencyValue.value,
                onChanged: (value) {
                  SettingsScreenX.X.syncFrequencyValue.value = value!.toInt();
                },
              ),
            );
          },
          itemCount: SettingsScreenX.X.syncFrequency.length,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Apply"),
          onPressed: () async {
            await SettingsScreenX.X.updateSyncFrequency();
            Get.back();
          },
        ),
      ],
    );
  }
}
