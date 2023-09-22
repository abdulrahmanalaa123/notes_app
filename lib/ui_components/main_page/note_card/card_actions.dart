import 'package:flutter/material.dart';

import '../../../models/notes.dart';
import 'heart_button.dart';
import 'more_options_button.dart';

class CardActions extends StatelessWidget {
  const CardActions(
      {required this.borderRadius,
      required this.margin,
      required this.note,
      super.key});
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final Note note;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OptionsButton(note: note),
                  HeartButton(note: note),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
