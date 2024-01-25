// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextFormField extends TextFormField {
  StyledTextFormField({
    Key? key,
    String? labelText,
    bool obscureText = false,
    TextEditingController? controller,
    GestureTapCallback? onTap,
    int? minLines,
    int? maxLines = 1,
    Function(String)? onChanged,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? suffixText,
    TextInputType? keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onFieldSubmitted,
    String? initialValue,
  }) : super(
          key: key,
          onTap: onTap,
          maxLines: maxLines,
          minLines: minLines,
          controller: controller,
          obscureText: obscureText,
          autofocus: false,
          readOnly: readOnly,
          autocorrect: false,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          enableInteractiveSelection: false,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
          obscuringCharacter: "*",
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: labelText,
            // labelStyle: const TextStyle(color: colorTextLight),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            suffixStyle: const TextStyle(
              color: Colors.red,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
          ),
        );
}
