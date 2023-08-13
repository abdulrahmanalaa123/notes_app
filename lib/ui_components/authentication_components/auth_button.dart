import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants/style_constants.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {required this.authFunc,
      required this.text,
      required this.shadow,
      super.key});

  final void Function() authFunc;
  final String text;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: authFunc,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
              color: Constants.yellow, style: BorderStyle.solid, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Constants.beige,
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
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
