// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class EventDetailItem extends StatelessWidget {
  final String itemTitle;
  final String itemDescription;
  const EventDetailItem({
    super.key,
    required this.itemTitle,
    required this.itemDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemTitle,
              style: const TextStyle(color: Colors.blue, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(itemDescription),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
