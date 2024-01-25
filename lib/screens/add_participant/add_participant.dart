// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/add_participant/add_participants.x.dart';
import 'package:i_attend_capture/screens/event_list/event_list.dart';

import '../../_widgets/styled_text_form_field.dart';

class AddParticipant extends StatelessWidget {
  AddParticipant({super.key});

  static final page =
      GetPage(name: '/add_participant', page: () => AddParticipant());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddParticipantsX>(
      init: AddParticipantsX(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Participant"),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: Get.back,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Get.offAllNamed(EventList.page.name);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        StyledTextFormField(
                          validator: (val) => (val ?? "").isEmpty
                              ? "First Name is Required"
                              : null,
                          labelText: "First Name",
                          suffixText: "*",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          validator: (val) => (val ?? "").isEmpty
                              ? "Last Name is Required"
                              : null,
                          labelText: "Last Name",
                          suffixText: "*",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          validator: (val) => (val ?? "").isEmpty
                              ? "Email Address is Required"
                              : null,
                          labelText: "Email Address",
                          suffixText: "*",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "Badge Id",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "External Id",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "Company",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          validator: (val) {
                            return null;
                          },
                          labelText: "Address 1",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "Address 2",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "City",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          validator: (val) {
                            return null;
                          },
                          labelText: "State",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "Zip Code",
                        ),
                        const SizedBox(height: 10),
                        StyledTextFormField(
                          labelText: "Mobile No",
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      final formState = formKey.currentState!;
                      if (formState.validate()) {
                        formState.save();
                        controller.addParticipant();
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
