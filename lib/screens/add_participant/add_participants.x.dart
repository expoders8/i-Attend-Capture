// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddParticipantsX extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final badgeIdController = TextEditingController();
  final companyController = TextEditingController();
  final externalIdController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final mobileController = TextEditingController();

  Future<void> addParticipant() async {}

  Future<void> addAttendee() async {
    // String headerString =
    //     "${organizationIdController.text}:${usernameController.text}:${passwordController.text}";
    // logger.i(headerString);

    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded = "Basic ${stringToBase64.encode(headerString)}";

    // logger.i("encodedValue : $encoded");

    // signInResponseModel = await ApiProvider.X.signIn(encoded, "fcmToken");
    // if (signInResponseModel?.isError ?? false) {
    //   showSnackBar(signInResponseModel?.errorMessage ??
    //       "Something went wrong while signing in.".tr);
    //   return;
    // }

    // await inject.get<ClientRepository>().insert(signInResponseModel!);

    // Get.offAllNamed(EventList.page.name);

    // logger.i("signInResponseModel : ${signInResponseModel?.clientId}");
  }
}
