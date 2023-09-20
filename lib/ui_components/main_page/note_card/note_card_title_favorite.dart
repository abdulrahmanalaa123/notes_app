import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

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
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                if (widget.note.noteData.isFavorite == 0) {
                  widget.note.noteData.editFields(favorite: 1);
                } else {
                  widget.note.noteData.editFields(favorite: 0);
                }
                //TODO
                //editNote
                context.read<NotesViewModel>();
              });
            },
            icon: widget.note.noteData.isFavorite == 0
                ? const Icon(
                    CupertinoIcons.heart,
                    color: Colors.black,
                  )
                : const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.black,
                  ),
            style: IconButton.styleFrom(
                backgroundColor: widget.note.noteData.color.withOpacity(0.5)),
          ),
        )
      ],
    );
  }
}
