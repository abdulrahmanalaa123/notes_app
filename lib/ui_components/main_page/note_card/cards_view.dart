import 'package:flutter/material.dart';

import 'notes_grid_view.dart';

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
  @override
  //TODO
  //ListView Instead of grid
  Widget build(BuildContext context) {
    return const NotesGridView();
  }
}
