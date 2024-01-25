// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/_widgets/code_configuration/code_configuration.x.dart';

import '../styled_text_form_field.dart';

class WebUrlConfigDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  WebUrlConfigDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodeConfigurationX>(
      init: CodeConfigurationX(),
      builder: (controller) {
        return AlertDialog(
          title: const Text(
            "Configuration Code",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Code is supplied by i-Attend. Do not modify this value.",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Keep this value empty to set to default.",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.labelLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                StyledTextFormField(
                  controller: controller.servicesUrlController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  labelText: "Web Services URL",
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.isURL) {
                      return "Invalid URL";
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: controller.resetConfigCode,
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  controller.submit();
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
