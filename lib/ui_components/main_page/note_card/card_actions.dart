import 'package:flutter/material.dart';

import '../../../models/notes.dart';
import 'heart_button.dart';
import 'more_options_button.dart';

class CardActions extends StatelessWidget {
  const CardActions(
      {required this.borderRadius,
      required this.margin,
      required this.left,
      required this.note,
      super.key});
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final Note note;
  final bool left;
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
                  OptionsButton(note: note, left: left),
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
