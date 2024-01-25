// ignore_for_file: public_member_api_docs

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInFooter extends StatelessWidget {
  const SignInFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "i-Attend: Attendance Tracking",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 20, child: VerticalDivider(color: Colors.black)),
            Text(
              "Registration",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Evaluation",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 20, child: VerticalDivider(color: Colors.black)),
            Text(
              "Certificates",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 20, child: VerticalDivider(color: Colors.black)),
            Text(
              "Reports",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: "Developed by ",
            children: [
              TextSpan(
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                //make link blue and underline
                text: "TNETIC.inc",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    //on tap code here, you can navigate to other page or URL
                  },
              ),

              //more text paragraph, sentences here.
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Copyright ©. All rights reserved.",
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }
}
