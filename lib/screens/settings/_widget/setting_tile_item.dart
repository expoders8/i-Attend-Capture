// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class SettingTileItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final VoidCallback callback;

  const SettingTileItem({
    required this.title,
    this.subTitle,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: subTitle != null ? Text(subTitle ?? '') : null,
      onTap: callback,
    );
  }
}
