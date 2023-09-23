import 'package:flutter/material.dart';

class MultiSelectActionButton extends StatelessWidget {
  const MultiSelectActionButton({
    super.key,
    required this.icon,
    this.asyncFunc,
    this.func,
    required this.text,
    this.color,
  });

  final IconData icon;
  final Future<void> Function()? asyncFunc;
  final void Function()? func;
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    //this limits us to not using a height constraint on the glass container
    //since if you use column its endless
    return IntrinsicWidth(
      stepHeight: 70,
      child: Column(
        children: [
          IconButton(
            onPressed: func ?? asyncFunc,
            icon: Icon(
              icon,
              color: color ?? Colors.white,
              size: 30,
            ),
            style: IconButton.styleFrom(backgroundColor: Colors.black),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
