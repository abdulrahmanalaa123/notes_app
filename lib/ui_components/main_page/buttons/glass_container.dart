import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer(
      {required this.blur,
      required this.opacity,
      required this.child,
      required this.padding,
      required this.margin,
      super.key});
  final double blur;
  final double opacity;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
