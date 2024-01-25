// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class SettingSwitchItem extends StatelessWidget {
  final String switchTitle;
  final bool value;
  final Function({required bool value}) callback;

  const SettingSwitchItem({
    required this.value,
    required this.switchTitle,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        switchTitle,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      trailing: Switch(
        value: value,
        activeColor: Colors.blue,
        onChanged: (value) => callback(value: value),
      ),
    );
  }
}
