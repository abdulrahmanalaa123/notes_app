import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/style_constants.dart';
import '../../../models/group.dart';
import '../../../models/notes.dart';
import '../../../view_models/multi_select_provider.dart';
import '../../../view_models/notes_view_model/notes_view_model.dart';
import 'multi_select_action_button.dart';

class MultiSelectActions extends StatelessWidget {
  const MultiSelectActions({super.key});

  //when initiating this widget then all states are set and wouldnt
  //change so all of the contexts are read inside this widget for that reason
  @override
  Widget build(BuildContext context) {
    final Group? selectedGroup = context.read<NotesViewModel>().selectedGroup;
    final List<Note> filteredListOfNotes =
        context.read<NotesViewModel>().selectedList;
    final bool allSelected =
        context.select<MultiSelect, int>((value) => value.checkSet.length) ==
            filteredListOfNotes.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MultiSelectActionButton(
          icon: CupertinoIcons.delete,
          asyncFunc: () async {
            final List<Note> selectedList =
                context.read<MultiSelect>().checkSet.toList();
            await context.read<NotesViewModel>().removeListOfNote(selectedList);
            if (context.mounted) {
              context.read<MultiSelect>().clear();
            }
          },
          text: 'delete',
        ),
        selectedGroup != null
            ? MultiSelectActionButton(
                icon: CupertinoIcons.minus,
                text: 'Remove From Group',
                func: () async {
                  final List<Note> selectedList =
                      context.read<MultiSelect>().checkSet.toList();
                  print('selected Group: $selectedGroup');
                  await context.read<NotesViewModel>().removeNotesFromGroup(
                      notes: selectedList, group: selectedGroup);
                },
              )
            : const SizedBox.shrink(),
        MultiSelectActionButton(
          icon: Icons.select_all_rounded,
          text: allSelected ? 'Deselect All' : 'Select All',
          color: allSelected ? Constants.yellow : null,
          func: () {
            if (!allSelected) {
              context.read<MultiSelect>().checkAll(filteredListOfNotes);
            } else {
              context.read<MultiSelect>().unCheckAll(filteredListOfNotes);
            }
          },
        ),
      ],
    );
  }
}
