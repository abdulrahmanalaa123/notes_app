import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/edit_note_page.dart';
import 'package:provider/provider.dart';

import '../../../models/group.dart';
import '../../../view_models/notes_view_model/notes_view_model.dart';

class MainModeActionButtons extends StatelessWidget {
  const MainModeActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    //it was already by a filtered by a bool but i realized
    //i need the group when it is filtered and instead of adding
    //non-necessary layers i use the selected group right away
    //it might be bad for an overhead of always having an instance of the group
    //in the widget even when its in All and its not needed for example
    Group? selectedGroup =
        context.select<NotesViewModel, Group?>((value) => value.selectedGroup);
    return Row(
      mainAxisAlignment: selectedGroup != null
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EditNote()));
          },
          icon: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
            size: 30,
          ),
          style: IconButton.styleFrom(backgroundColor: Colors.black),
        ),
        if (selectedGroup != null && selectedGroup.groupName != 'Favourite')
          IconButton(
              onPressed: () async {
                final viewModel = context.read<NotesViewModel>();
                await viewModel.notesErrorIndicator
                    .oneInputFuncWrapper<void, Group>(
                        func: viewModel.removeGroup,
                        object: selectedGroup,
                        context: context);
                //return to All notes
                viewModel.switchIndex(-1);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
              style: IconButton.styleFrom(backgroundColor: Colors.black)),
      ],
    );
  }
}
