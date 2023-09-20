import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../view_models/multi_select_provider.dart';

class NoteCardsInkWell extends StatelessWidget {
  const NoteCardsInkWell({
    super.key,
    required this.left,
    required this.first,
    required this.note,
  });

  final bool left;
  final bool first;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: left ? 16 : 0,
          right: !left ? 16 : 0,
          top: first ? 16 : 0,
          bottom: !context.read<MultiSelect>().isMultiSelectEnabled ? 26 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: left ? Radius.zero : const Radius.circular(30),
            topRight: const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            bottomRight: left ? const Radius.circular(30) : Radius.zero),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (context.read<MultiSelect>().isMultiSelectEnabled) {
                context.read<MultiSelect>().checkUncheck(note);
              } else {
                //TODO
                //gotoediting Page
              }
            },
            onLongPress: () {
              if (!context.read<MultiSelect>().isMultiSelectEnabled) {
                context.read<MultiSelect>().changeMode();
                context.read<MultiSelect>().checkUncheck(note);
              }
            },
          ),
        ),
      ),
    );
  }
}
