import 'dart:async';

import 'package:flutter/material.dart';

import '../project/c_text.dart';

class CustomButton extends StatefulWidget {
  String? title;
  Widget? titleWidget;
  FutureOr<void> Function() onPressed;
  Color? backgroundColor;
  Color? hoverColor;
  Color? borderColor;
  Color? textColor;
  Color? loadingColor;
  double radius;
  double? minWidth;
  double height;
  double padding;
  bool isEnabled;
  double elevation;
  bool isExpanded;

  CustomButton({
    super.key,
    this.title,
    this.titleWidget,
    required this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.borderColor,
    this.textColor,
    this.loadingColor,
    this.radius = 100,
    this.minWidth = 100,
    this.padding = 24,
    this.height = 40,
    this.isEnabled = true,
    this.elevation = 0,
    this.isExpanded = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    setState(() => _isLoading = true);
    try {
      await widget.onPressed.call();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    widget.textColor ??= widget.isEnabled ? Colors.white : Colors.grey.shade400;
    widget.backgroundColor ??= theme.primaryColor;
    widget.loadingColor ??= widget.backgroundColor;

    return widget.isExpanded ? Expanded(child: _buildWidget()) : _buildWidget();
  }

  Widget _buildWidget() {
    final bool isButtonActive = widget.isEnabled && !_isLoading;

    return MaterialButton(
      onPressed: isButtonActive ? _handlePressed : null,
      minWidth: widget.minWidth,
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
        side: !widget.isEnabled
            ? BorderSide(color: Colors.grey.shade400)
            : _isLoading
            ? BorderSide(color: widget.loadingColor!)
            : widget.borderColor != null
            ? BorderSide(color: widget.borderColor!)
            : BorderSide(color: widget.backgroundColor!),
      ),
      elevation: widget.elevation,
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      child: _isLoading
          ? _circleLoading()
          : widget.titleWidget ?? _titleWidget(),
    );
  }

  Widget _titleWidget() {
    return CText(
      widget.title,
      color: widget.textColor,
      isBold: true,
      textAlign: TextAlign.center,
      isOverflow: true,
    );
  }

  Widget _circleLoading() {
    return SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(
        color: widget.loadingColor,
        strokeWidth: 3,
      ),
    );
  }
}
