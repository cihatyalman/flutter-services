import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  bool enabled;
  bool autofocus;
  TextEditingController? controller;
  void Function(String? value)? onChanged;
  void Function(String? value)? onSubmitted;
  void Function()? onTap;
  String? initialValue;
  String? labelText;
  String? helperText;
  String? hintText;
  String? errorText;
  TextStyle? textStyle;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputMaskList;
  bool obscureText;
  int? maxLines;
  int? maxLength;
  double radius;
  EdgeInsets contentPadding;
  bool readOnly;
  Color? backgroundColor;
  TextAlign textAlign;
  TextCapitalization textCapitalization;

  CustomInput({
    super.key,
    this.enabled = true,
    this.autofocus = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.initialValue,
    this.labelText,
    this.helperText,
    this.hintText,
    this.errorText,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputMaskList,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.radius = 8,
    this.contentPadding = const EdgeInsets.all(8),
    this.readOnly = false,
    this.backgroundColor,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
  }) : assert(!obscureText || maxLines == 1);

  @override
  Widget build(BuildContext context) {
    textStyle ??= Theme.of(context).textTheme.bodyMedium;

    if (![controller, initialValue].contains(null)) {
      controller!.text = initialValue!;
    }
    return TextField(
      enabled: enabled,
      autofocus: autofocus,
      controller: (controller ?? TextEditingController(text: initialValue)),
      onChanged: (value) =>
          onChanged?.call(value.trim().isEmpty ? null : value),
      onSubmitted: (value) =>
          onSubmitted?.call(value.trim().isEmpty ? null : value),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      cursorHeight: 20,
      style: textStyle,
      keyboardType: keyboardType,
      inputFormatters: inputMaskList,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      textAlignVertical: (prefixIcon != null || suffixIcon != null)
          ? TextAlignVertical.center
          : null,
    );
  }

  /// Proje genelinde [CustomInput] bileşeninin tasarım standartlarını belirler.
  ///
  /// **Kullanım Notu:**
  /// Bu bileşenin görsel tutarlılığını sağlamak için [MaterialApp] içerisindeki
  /// `theme` (ThemeData) kısmına aşağıdaki atamayı yapmanız önerilir:
  ///
  /// ```dart
  /// theme: ThemeData(
  ///   inputDecorationTheme: CustomInput.theme,
  /// ),
  /// ```
  ///
  /// Eğer global olarak değil de sadece belirli bir sayfada kullanmak isterseniz,
  /// widget'ı bir [Theme] widget'ı ile sarmalayarak bu temayı uygulayabilirsiniz.
  static InputDecorationTheme get theme => InputDecorationTheme(
    filled: true,
    fillColor: Colors.black.withAlpha(8),
    contentPadding: EdgeInsets.all(8),
    helperMaxLines: 3,
    errorMaxLines: 3,
    hintStyle: TextStyle(color: Colors.grey.shade600),
    labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    floatingLabelStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade900,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red.shade300),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade900),
    ),
  );
}
