import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/style_constants.dart';
import '../../../models/notes.dart';
import '../../../models/notes_data.dart';
import 'note_card.dart';
import 'note_card_inkwell.dart';

class NotesGridView extends StatelessWidget {
  const NotesGridView({
    super.key,
    required this.rand,
  });

  final Random rand;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 300,
        ),
        itemCount: 7,
        itemBuilder: (context, index) {
          int colorInd = rand.nextInt(5);

          final note = Note(
              noteData: NoteData(
                  title:
                      'hello this a test to test the notes title limit what todo',
                  body:
                      'blalalallalalalahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\nhhhhgggggggggggggggggssssssssssssssssssssss',
                  color: Constants.listOfColors[colorInd]),
              createdAt: DateTime.now());
          bool first = false;
          bool last = false;
          bool left = false;
          //dont know anyother way to combine either without the ifs
          if (index <= 1) first = true;
          //TODO
          //implement last when you have the notes
          //if ((index-itemCount <= 1 && itemCount%2 == 0) || (index-itemCount < 1 && itemCount%2 != 0)) last = true;
          if (index % 2 == 0) left = true;

          return Stack(
            children: [
              NotesCard(
                note: note,
                left: left,
                first: first,
              ),
              NoteCardsInkWell(left: left, first: first, note: note),
            ],
          );
        });
  }
}
