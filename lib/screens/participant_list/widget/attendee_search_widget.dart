// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/participant_list/widget/attendee_list_item.dart';
import 'package:i_attend_capture/screens/participant_list/widget/attendee_search_widget.x.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../_model/attendee_model.dart';

class AttendeeSearchWidget extends StatelessWidget {
  final String hintText;
  final Function(AttendeeModel)? onSelected;

  const AttendeeSearchWidget({
    this.hintText = "Search Participant",
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendeeSearchWidgetX>(
      init: AttendeeSearchWidgetX(),
      builder: (controller) {
        return Column(
          children: [
            Obx(
              () => TextField(
                autofocus: true,
                controller: controller.searchController,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  suffixIcon: (controller.query.value ?? '').isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: controller.clearQuery,
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: controller.setQuery,
              ),
            ),
            const Divider(thickness: 1, height: 1),
            Expanded(
              child: PagedListView<int, AttendeeModel>.separated(
                separatorBuilder: (context, index) => const Divider(),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<AttendeeModel>(
                  itemBuilder: (context, item, index) => AttendeeListItem(
                    attendee: item,
                    onTap: onSelected != null
                        ? (item) {
                            onSelected!(item);
                            controller.clearQuery();
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
