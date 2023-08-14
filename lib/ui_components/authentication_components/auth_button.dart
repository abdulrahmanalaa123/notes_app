import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {required this.authFunc,
      required this.text,
      required this.shadow,
      this.borderColor,
      this.bodyColor,
      this.textColor,
      super.key});

  final void Function() authFunc;
  final String text;
  final bool shadow;
  final Color? borderColor;
  final Color? bodyColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: authFunc,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Constants.yellow,
              style: BorderStyle.solid,
              width: 2),
          borderRadius: BorderRadius.circular(10),
          color: bodyColor ?? Constants.beige,
          boxShadow: shadow
              ? [
                  const BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0.1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                    blurStyle: BlurStyle.normal,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
