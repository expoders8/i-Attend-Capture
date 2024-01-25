import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_attend_capture/screens/sign_in_screen/sign_in_screen.x.dart';
import 'package:i_attend_capture/screens/sign_in_screen/sing_in_footer.dart';

import '../../_widgets/code_configuration/code_configuration.dart';
import '../../_widgets/styled_text_form_field.dart';

///
class SignInScreen extends StatelessWidget {
  ///
  SignInScreen({super.key});

  ///
  static final page =
      GetPage(name: '/sign_in_screen', page: () => SignInScreen());

  ///
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInScreenX());

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/capture_login.png'),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "i-Attend CAPTURE",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      offset: const Offset(3, 3),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                margin: const EdgeInsets.all(18),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  children: [
                                    StyledTextFormField(
                                      onSaved: controller.organizationId,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Organization ID is Required";
                                        }

                                        return null;
                                      },
                                      readOnly: controller.isSigningIn.value,
                                      textInputAction: TextInputAction.next,
                                      labelText: "Enter Your Organization ID",
                                      prefixIcon: const Icon(
                                        Icons.group,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    StyledTextFormField(
                                      onSaved: controller.username,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Username is Required";
                                        }

                                        return null;
                                      },
                                      readOnly: controller.isSigningIn.value,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      labelText: "Enter Your Username",
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    StyledTextFormField(
                                      onSaved: controller.password,
                                      obscureText: true,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Password is Required";
                                        }

                                        return null;
                                      },
                                      readOnly: controller.isSigningIn.value,
                                      textInputAction: TextInputAction.done,
                                      labelText: "Enter Your Password",
                                      prefixIcon: const Icon(
                                        Icons.key,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Obx(
                                      () => Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                backgroundColor:
                                                    const Color(0xFF5D34A4),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 9,
                                                        horizontal: 10),
                                              ),
                                              onPressed: !controller
                                                      .isSigningIn.value
                                                  ? () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      final formState =
                                                          formKey.currentState!;
                                                      if (formState
                                                          .validate()) {
                                                        formState.save();
                                                        controller.signIn();
                                                      }
                                                    }
                                                  : null,
                                              child: controller
                                                      .isSigningIn.value
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : const Text(
                                                      "Login",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () =>
                                          Get.dialog(WebUrlConfigDialog()),
                                      child: const Text('Configure App'),
                                    ),
                                    const SizedBox(height: 30),
                                    const SignInFooter()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
