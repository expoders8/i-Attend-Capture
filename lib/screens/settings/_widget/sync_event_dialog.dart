// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/constants.dart';
import '../settings_screen.x.dart';

class SyncEventDialog extends StatelessWidget {
  const SyncEventDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedValue = SettingsScreenX.X.settings.value?.syncEventDays ??
        kDefaultSyncEventDays;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Sync Events"),
          content: SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: selectedValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: SettingsScreenX.X.syncEventDays.map((items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text('$items'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text("Days"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Get.back(),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                SettingsScreenX.X.updateSyncPeriod(selectedValue);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
