import 'package:flutter/material.dart';

import '../../../models/notes.dart';

class NoteCardTitleFavorite extends StatefulWidget {
  const NoteCardTitleFavorite({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<NoteCardTitleFavorite> createState() => _NoteCardTitleFavoriteState();
}

class _NoteCardTitleFavoriteState extends State<NoteCardTitleFavorite> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            widget.note.noteData.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        )
      ],
    );
  }
}
