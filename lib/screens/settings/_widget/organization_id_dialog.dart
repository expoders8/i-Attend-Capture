// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_widgets/styled_text_form_field.dart';
import '../settings_screen.x.dart';

class OrganizationIdDialog extends StatelessWidget {
  OrganizationIdDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var orgId = SettingsScreenX.X.settings.value?.organizationId ?? "";

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Organization ID"),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: StyledTextFormField(
                initialValue: orgId,
                validator: (val) => val?.isEmpty ?? true
                    ? "Please Enter Organization ID"
                    : null,
                keyboardType: TextInputType.text,
                maxLines: 1,
                onSaved: (newValue) {
                  setState(() {
                    orgId = newValue!;
                  });
                },
                labelText: "Enter Organization ID",
                prefixIcon: const Icon(
                  Icons.group,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  await SettingsScreenX.X.updateOrganizationID(orgId);
                  Get.back();
                }
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }
}
