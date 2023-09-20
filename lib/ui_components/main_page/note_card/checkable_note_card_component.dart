import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../view_models/multi_select_provider.dart';
import 'note_card_title_favorite.dart';

class CheckableNoteCardComponent extends StatelessWidget {
  const CheckableNoteCardComponent({
    super.key,
    required this.left,
    required this.first,
    required this.note,
    required this.multiSelect,
  });

  final bool left;
  final bool first;
  final Note note;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        context.select<MultiSelect, bool>((value) => value.isChecked(note));
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          margin: EdgeInsets.only(
              left: left ? 16 : 0, right: !left ? 16 : 0, top: first ? 16 : 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: note.noteData.color,
            borderRadius: BorderRadius.only(
                topLeft: left ? Radius.zero : const Radius.circular(30),
                topRight: const Radius.circular(30),
                bottomLeft: const Radius.circular(30),
                bottomRight: left ? const Radius.circular(30) : Radius.zero),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              NoteCardTitleFavorite(note: note),
              const SizedBox(
                height: 16,
              ),
              Text(
                note.noteData.description!,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        multiSelect && isSelected
            ? DecoratedBox(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
