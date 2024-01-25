// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_core/notification_utils.dart';
import '../../../_core/preference_utils.dart';
import '../../../_provider/auth_provider.dart';
import '../../../_widgets/styled_text_form_field.dart';

class LoginDialog extends StatelessWidget {
  LoginDialog({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? _username = PreferenceUtils.getLoggedInUserId();
    String? _password;

    // if (kDebugMode) {
    //   _password = 'trial0801';
    // }

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Login"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledTextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter User ID";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _username = newValue;
                    });
                  },
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  initialValue: _username,
                  labelText: "Username",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                StyledTextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Password";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _password = newValue;
                    });
                  },
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  initialValue: _password,
                  obscureText: true,
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.key, color: Colors.blue),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final formState = formKey.currentState!;
                          if (formState.validate()) {
                            formState.save();
                            final response = await AuthProvider.X.signIn(
                              PreferenceUtils.getSettings().organizationId!,
                              _username!,
                              _password!,
                              "fcmToken",
                            );
                            if (response.isError != true) {
                              Get.back(result: true);
                            } else {
                              NotificationUtils.showErrorSnackBar(
                                message: response.errorMessage ??
                                    "Something went wrong while signing in.",
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
