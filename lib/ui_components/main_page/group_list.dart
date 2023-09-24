import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/group.dart';
import '../../view_models/notes_view_model/notes_view_model.dart';
import 'group_selection_element.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //select doesnt change notesViewModel when changing but watch does
    //it rebuilds the whole widget
    //mbe has sth to do with stateless and stateful widgets
    //probably was because i call after popping so its already built

    //i presume the problem is in that select selects the list and any edit to the note or groups
    //and adding them to the list they are edited because the notify listeners in each of its functions
    //and not the selector where select works best for singular values and watch is better for global editing
    //states like adding group or editing note or adding it etc.
    //and watching the list in itself wont give any feedback on changes happened to the children of the list
    final groupList = context.watch<NotesViewModel>().groupList;
    final Group? selectedGroup =
        context.select<NotesViewModel, Group?>((value) => value.selectedGroup);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      //adding 1 to the all category
      itemCount: groupList.length + 1,
      itemBuilder: (context, index) {
        // i read since its rebuilt

        bool selected = (selectedGroup == null && index == 0) ||
            (index >= 1 && groupList[index - 1] == selectedGroup);
        return GestureDetector(
          onTap: () {
            context.read<NotesViewModel>().switchIndex(index - 1);
          },
          child: GroupSelectionElement(
              groupName: index == 0 ? 'All' : groupList[index - 1].groupName,
              first: index == 0 ? true : false,
              selected: selected),
        );
      },
    );
  }
}
