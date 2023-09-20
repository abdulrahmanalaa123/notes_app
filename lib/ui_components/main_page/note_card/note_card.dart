import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notes.dart';
import '../../../view_models/multi_select_provider.dart';
import 'checkable_note_card_component.dart';

import 'card_date_component.dart';

class NotesCard extends StatelessWidget {
  const NotesCard(
      {required this.note, this.first = false, required this.left, super.key});
  final bool left;
  final bool first;
  final Note note;

  @override
  Widget build(BuildContext context) {
    final bool multiSelect = context
        .select<MultiSelect, bool>((value) => value.isMultiSelectEnabled);
    return Column(
      children: [
        Expanded(
          child: CheckableNoteCardComponent(
            left: left,
            first: first,
            note: note,
            multiSelect: multiSelect,
          ),
        ),
        !multiSelect ? const SizedBox(height: 8) : const SizedBox.shrink(),
        !multiSelect
            ? CardDateComponent(left: left, note: note)
            : const SizedBox.shrink(),
      ],
    );
  }
}
