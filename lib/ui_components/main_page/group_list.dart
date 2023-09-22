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
    // but i dont get the reason it doesnt rebuild
    //final groupList =
    //    context.select<NotesViewModel, List<Group>>((val) => val.groupList);
    print('rebuilding');
    //TODO
    //groups List is a bit janky for some reason idk if its because of watch or select but it is
    //need to fix it or at least figure out why if its not hurtful then fuck it
    //IVe tried enough maybe not well enough but enough time might check it later
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
