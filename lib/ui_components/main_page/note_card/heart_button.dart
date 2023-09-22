import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../view_models/notes_view_model/notes_view_model.dart';

class HeartButton extends StatelessWidget {
  const HeartButton({required this.note, super.key});

  final Note note;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (note.noteData.isFavorite == 0) {
          context.read<NotesViewModel>().editNote(note, favorite: 1);
        } else {
          context.read<NotesViewModel>().editNote(note, favorite: 0);
        }
      },
      icon: note.noteData.isFavorite == 0
          ? const Icon(
              CupertinoIcons.heart,
              color: Colors.black,
            )
          : const Icon(
              CupertinoIcons.heart_fill,
              color: Colors.black,
            ),
      style: IconButton.styleFrom(
          backgroundColor: note.noteData.color.withOpacity(0.5)),
    );
  }
}
