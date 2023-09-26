import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../models/notes_data.dart';
import '../../../view_models/notes_view_model/notes_view_model.dart';

class HeartButton extends StatelessWidget {
  const HeartButton({required this.note, super.key});

  final Note note;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final viewModel = context.read<NotesViewModel>();
        if (note.noteData.isFavorite == 0) {
          await viewModel.notesErrorIndicator
              .twoInputFuncWrapper<void, Note, NoteData>(
                  func: viewModel.editNote,
                  object: note,
                  object2: NoteData.copyWith(note.noteData, favorite: 1),
                  context: context);
        } else {
          await viewModel.notesErrorIndicator
              .twoInputFuncWrapper<void, Note, NoteData>(
                  func: viewModel.editNote,
                  object: note,
                  object2: NoteData.copyWith(note.noteData, favorite: 0),
                  context: context);
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
