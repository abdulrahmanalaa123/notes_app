import 'package:flutter/material.dart';

import '../../../models/notes.dart';
import 'checkable_note_card_component.dart';

import 'card_date_component.dart';

class NotesCard extends StatelessWidget {
  const NotesCard(
      {required this.note,
      required this.borderRadius,
      required this.margin,
      required this.left,
      required this.multiSelect,
      super.key});
  final bool left;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final Note note;
  final bool multiSelect;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CheckableNoteCardComponent(
            borderRadius: borderRadius,
            margin: margin,
            note: note,
            multiSelect: multiSelect,
          ),
        ),
        !multiSelect ? const SizedBox(height: 8) : const SizedBox.shrink(),
        !multiSelect
            ? CardDateComponent(left: left, note: note)
            : const SizedBox.shrink(),
      ],
    );
  }
}
