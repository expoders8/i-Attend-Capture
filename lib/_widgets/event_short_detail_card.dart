// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class EventShotDetailCard extends StatelessWidget {
  final String eventTitle;
  final String eventTime;
  final int eventAttendeeCount;
  final bool showEventAttendeeCount;
  const EventShotDetailCard({
    this.eventAttendeeCount = 0,
    required this.eventTitle,
    required this.eventTime,
    this.showEventAttendeeCount = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: true,
        child: Container(
          padding: const EdgeInsets.all(18),
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    eventTime,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              Visibility(
                visible: showEventAttendeeCount,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Attendance Count:",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          eventAttendeeCount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
