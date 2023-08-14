import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {required this.controller,
      this.focusNode,
      required this.isPassword,
      required this.label,
      required this.validator,
      this.formatter,
      required this.hintText,
      this.labelColor,
      this.borderColor,
      this.activeBorderColor,
      this.cursorColor,
      this.inputSize,
      super.key});

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputFormatter? formatter;
  final String hintText;
  final FocusNode? focusNode;
  final bool isPassword;
  final Color? labelColor;
  final Color? borderColor;
  final Color? activeBorderColor;
  final Color? cursorColor;
  final double? inputSize;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextFormField(
        autofocus: false,
        //controller is here for the submit button probably
        controller: widget.controller,
        cursorColor: widget.cursorColor ?? Constants.beige,
        inputFormatters:
            (widget.formatter == null) ? null : [widget.formatter!],
        enabled: true,
        style: TextStyle(color: Colors.white, fontSize: widget.inputSize ?? 14),
        obscureText: widget.isPassword,
        validator: widget.validator,
        textInputAction: TextInputAction.next,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: widget.labelColor ?? Constants.beige),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor ?? Constants.beige,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: widget.activeBorderColor ?? Constants.yellow),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(10)),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
