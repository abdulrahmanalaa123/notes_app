import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

import '../../../view_models/multi_select_provider.dart';
import 'card_actions.dart';
import 'note_card.dart';
import 'note_card_inkwell.dart';

class NotesGridView extends StatelessWidget {
  const NotesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final noteList = context.watch<NotesViewModel>().selectedList;
    final bool multiSelect = context
        .select<MultiSelect, bool>((value) => value.isMultiSelectEnabled);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 300,
        ),
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          //TODO
          //implement last when you have the notes
          //if ((index-itemCount <= 1 && itemCount%2 == 0) || (index-itemCount < 1 && itemCount%2 != 0)) last = true;
          final note = noteList[index];
          final left = index % 2 == 0;
          final first = index <= 1;

          final margin = EdgeInsets.only(
              left: left ? 16 : 0,
              right: !left ? 16 : 0,
              top: first ? 16 : 0,
              bottom:
                  !context.read<MultiSelect>().isMultiSelectEnabled ? 26 : 0);
          final borderRadius = BorderRadius.only(
              topLeft: left ? Radius.zero : const Radius.circular(30),
              topRight: const Radius.circular(30),
              bottomLeft: const Radius.circular(30),
              bottomRight: left ? const Radius.circular(30) : Radius.zero);
          return Stack(
            children: [
              NotesCard(
                note: note,
                //left or right
                margin: margin,
                borderRadius: borderRadius,
                left: left,
                multiSelect: multiSelect,
              ),
              NoteCardsInkWell(
                  margin: margin, borderRadius: borderRadius, note: note),
              !multiSelect
                  ? CardActions(
                      borderRadius: borderRadius, margin: margin, note: note)
                  : const SizedBox.shrink(),
            ],
          );
        });
  }
}
