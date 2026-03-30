import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../custom/custom_input.dart';

class CInput extends StatelessWidget {
  final bool enabled;
  final bool autofocus;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputMaskList;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final TextAlign textAlign;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSubmitted;
  final void Function()? onTap;

  const CInput({
    super.key,
    this.enabled = true,
    this.autofocus = false,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.inputMaskList,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      enabled: enabled,
      autofocus: autofocus,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      inputMaskList: inputMaskList,
      maxLines: maxLines,
      maxLength: maxLength,
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      obscureText: obscureText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      textAlign: textAlign,
      readOnly: readOnly ?? false,
    );
  }
}
