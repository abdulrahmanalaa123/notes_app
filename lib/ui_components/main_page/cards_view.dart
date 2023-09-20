import 'dart:math';

import 'package:flutter/material.dart';

import 'note_card/notes_grid_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
    required this.gridState,
  });

  final bool gridState;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final Random rand = Random();

  @override
  Widget build(BuildContext context) {
    return NotesGridView(rand: rand);
  }
}
