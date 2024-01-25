// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/add_participant/add_participant.dart';
import '../../screens/add_participant/add_participants.x.dart';
import '../styled_text_form_field.dart';

class AddParticipantsDialog extends StatelessWidget {
  const AddParticipantsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddParticipantsX>(
      init: AddParticipantsX(),
      builder: (controller) {
        return AlertDialog(
          title: const Text("Add Participant"),
          content: Wrap(
            children: [
              Column(
                children: [
                  StyledTextFormField(
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    labelText: "First Name",
                    suffixText: "*",
                    prefixIcon: const Icon(Icons.group, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledTextFormField(
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    labelText: "Last Name",
                    suffixText: "*",
                    prefixIcon: const Icon(Icons.group, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledTextFormField(
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    labelText: "Email Address",
                    suffixText: "*",
                    prefixIcon: const Icon(Icons.group, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledTextFormField(
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    labelText: "Badge Id",
                    prefixIcon: const Icon(Icons.group, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledTextFormField(
                    validator: (val) {
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    labelText: "Company",
                    prefixIcon: const Icon(Icons.group, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.toNamed(AddParticipant.page.name);
                        },
                        child: const Text("More Info"),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
