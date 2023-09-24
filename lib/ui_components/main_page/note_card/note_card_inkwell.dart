import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../pages/edit_note_page.dart';
import '../../../view_models/multi_select_provider.dart';

class NoteCardsInkWell extends StatelessWidget {
  const NoteCardsInkWell({
    super.key,
    required this.borderRadius,
    required this.margin,
    required this.note,
  });

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
          child: InkWell(
            onTap: () {
              if (context.read<MultiSelect>().isMultiSelectEnabled) {
                context.read<MultiSelect>().checkUncheck(note);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          note: note,
                        )));
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
