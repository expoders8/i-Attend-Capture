// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const BottomButton({
    super.key,
    this.onTap,
    required this.title,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
