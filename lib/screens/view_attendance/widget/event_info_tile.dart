// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/date_formatter.dart';
import '../../../_model/event_model.dart';

class EventInfoTile extends StatelessWidget {
  final EventModel eventModel;
  final String subTitle;

  const EventInfoTile({
    super.key,
    required this.eventModel,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: Colors.deepPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventModel.eventName,
            style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
              Flexible(
                child: Text(
                  getEventFormattedTime(
                    eventModel.startTime,
                    eventModel.endTime,
                  ),
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                subTitle,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
