// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_model/attendee_model.dart';

class AttendanceSearchAutocomplete extends RawAutocomplete<AttendeeModel> {
  AttendanceSearchAutocomplete({
    required AutocompleteOptionsBuilder<AttendeeModel> optionsBuilder,
    required AutocompleteOnSelected<AttendeeModel> onSelected,
    required TextEditingController textEditingController,
    FocusNode? focusNode,
    required AutocompleteOptionToString<AttendeeModel> displayStringForOption,
    String? hintText,
    required Function(String) onFieldSubmitted,
  }) : super(
          optionsBuilder: optionsBuilder,
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<AttendeeModel> onSelected,
            Iterable<AttendeeModel> options,
          ) {
            final ScrollController firstController = ScrollController();
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: 200, maxWidth: Get.width - 50),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: firstController,
                    child: ListView.separated(
                      controller: firstController,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final AttendeeModel option = options.elementAt(index);

                        return InkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(displayStringForOption(option)),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          onSelected: onSelected,
          displayStringForOption: displayStringForOption,
          textEditingController: textEditingController,
          focusNode: focusNode,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback _onFieldSubmitted,
          ) {
            return TextFormField(
              autofocus: true,
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              onFieldSubmitted: (String value) {
                onFieldSubmitted(value);
              },
            );
          },
        );
}
