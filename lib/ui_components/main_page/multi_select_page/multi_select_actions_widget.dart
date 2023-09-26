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
    //on each selection it rebuilds so it reads once on initiation and after each selection it
    //reads then on clearing they're all not selected again so it reads again so its useless to use select
    //on the selected List here
    final List<Note> filteredListOfNotes =
        context.read<NotesViewModel>().selectedList;
    final bool allSelected =
        context.select<MultiSelect, int>((value) => value.checkSet.length) ==
            filteredListOfNotes.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
        ),
        MultiSelectActionButton(
          icon: CupertinoIcons.delete,
          asyncFunc: () async {
            final List<Note> selectedList =
                context.read<MultiSelect>().checkSet.toList();
            final viewModel = context.read<NotesViewModel>();
            await viewModel.notesErrorIndicator
                .oneInputFuncWrapper<void, List<Note>>(
                    func: viewModel.removeListOfNote,
                    object: selectedList,
                    context: context);
            if (context.mounted) {
              context.read<MultiSelect>().clear();
            }
          },
          text: 'delete',
        ),
        const SizedBox(
          width: 16,
        ),
        if (selectedGroup != null)
          MultiSelectActionButton(
            icon: CupertinoIcons.minus,
            text: 'Remove',
            func: () async {
              final List<Note> selectedList =
                  context.read<MultiSelect>().checkSet.toList();
              final viewModel = context.read<NotesViewModel>();
              await viewModel.notesErrorIndicator
                  .twoInputFuncWrapper<void, List<Note>, Group>(
                      func: viewModel.removeNotesFromGroup,
                      object: selectedList,
                      object2: selectedGroup,
                      context: context);
            },
          ),
        const SizedBox(
          width: 16,
        ),
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
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
