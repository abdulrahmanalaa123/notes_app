import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../view_models/multi_select_provider.dart';
import 'note_card_title_favorite.dart';

class CheckableNoteCardComponent extends StatelessWidget {
  const CheckableNoteCardComponent({
    super.key,
    required this.borderRadius,
    required this.margin,
    required this.note,
    required this.multiSelect,
  });

  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final Note note;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        context.select<MultiSelect, bool>((value) => value.isChecked(note));
    return Stack(
      children: [
        Container(
          margin: margin.copyWith(bottom: 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: note.noteData.color,
            borderRadius: borderRadius,
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              NoteCardTitleFavorite(note: note),
              const SizedBox(
                height: 16,
              ),
              Text(
                note.noteData.description!.isNotEmpty
                    ? note.noteData.description!
                    : note.noteData.body,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        //this works without sizing because its all in expanded
        //in the parent widget
        if (multiSelect && isSelected)
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }
}
