import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({required this.authFunc, required this.text, super.key});

  final void Function() authFunc;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: authFunc,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFF7D44C),
          fixedSize: Size(250, 50),
          elevation: 2,
          padding: const EdgeInsets.all(10),
          textStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        child: Text(
          text,
        ));
  }
}
