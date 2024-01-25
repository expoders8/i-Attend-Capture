// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.body,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 300,
            child: Center(
              child: Image.asset(image),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
