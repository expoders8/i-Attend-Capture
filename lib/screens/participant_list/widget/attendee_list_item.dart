// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../../_model/attendee_model.dart';

class AttendeeListItem extends StatelessWidget {
  final AttendeeModel attendee;
  final void Function(AttendeeModel)? onTap;

  const AttendeeListItem({
    super.key,
    required this.attendee,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap?.call(attendee),
      title: Text(
        "${attendee.lastName!}, ${attendee.firstName!}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(attendee.emailId ?? ""),
      // trailing: Image.asset(
      //   "assets/images/user.png",
      //   width: 60,
      // ),
    );
  }
}
