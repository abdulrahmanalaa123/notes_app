import 'package:flutter/material.dart';
import 'package:notes_app/constants/more_options.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/group.dart';
import '../../../models/notes.dart';
import '../../../pages/edit_note_page.dart';

class OptionsButton extends StatelessWidget {
  OptionsButton({required this.note, required this.left, super.key});
  final controller = MenuController();
  final bool left;
  final Note note;
  //options list was removed from here because it is only needed once
  @override
  Widget build(BuildContext context) {
    //only show him groups where the notes hasnt already belonged to
    //it is read because each time a noteview item is shown this options button
    //is built i think its a bit expensive but what do i know
    //so thats  why we use read instead of select
    final groupList = context
        .read<NotesViewModel>()
        .groupList
        .sublist(1)
        .where((element) => !note.noteData.hasGroup(group: element));
    final selectedGroup = context.read<NotesViewModel>().selectedGroup;
    return MenuAnchor(
      controller: controller,
      anchorTapClosesMenu: true,
      style: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(note.noteData.color),
        //side: MaterialStatePropertyAll<BorderSide>(
        //    BorderSide(color: Colors.black)),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditNote(
                      note: note,
                    )));
          },
          child: Text(Options.options[0]),
        ),
        MenuItemButton(
          onPressed: () async {
            final viewModel = context.read<NotesViewModel>();
            //tested that it doesnt need to await to perform the fucntion
            //since its fast i think but await is left for correctness
            await viewModel.notesErrorIndicator.oneInputFuncWrapper<void, Note>(
                func: viewModel.removeNote, object: note, context: context);
          },
          child: Text(Options.options[1]),
        ),
        const Divider(
          color: Colors.black,
        ),
        SubmenuButton(
          menuStyle: MenuStyle(
              backgroundColor: MaterialStatePropertyAll(note.noteData.color)),
          menuChildren: groupList
              .map((e) => MenuItemButton(
                    onPressed: () async {
                      final viewModel = context.read<NotesViewModel>();
                      await viewModel.notesErrorIndicator
                          .twoInputFuncWrapper<void, List<Note>, Group>(
                              func: viewModel.addNotesToGroup,
                              object: [note],
                              object2: e,
                              context: context);
                    },
                    child: Text(e.groupName),
                  ))
              .toList(),
          child: Text(Options.options[2]),
        ),
        if (note.noteData.groups != null && note.noteData.groups!.isNotEmpty)
          if (selectedGroup == null)
            SubmenuButton(
              menuStyle: MenuStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(note.noteData.color)),
              menuChildren: note.noteData.groups!
                  .map((e) => MenuItemButton(
                        onPressed: () async {
                          final viewModel = context.read<NotesViewModel>();
                          await viewModel.notesErrorIndicator
                              .twoInputFuncWrapper<void, List<Note>, Group>(
                                  func: viewModel.removeNotesFromGroup,
                                  object: [note],
                                  object2: e,
                                  context: context);
                        },
                        child: Text(e.groupName),
                      ))
                  .toList(),
              child: Text(Options.options[3]),
            )
          else
            MenuItemButton(
              onPressed: () async {
                final viewModel = context.read<NotesViewModel>();
                await viewModel.notesErrorIndicator
                    .twoInputFuncWrapper<void, List<Note>, Group>(
                        func: viewModel.removeNotesFromGroup,
                        object: [note],
                        object2: selectedGroup,
                        context: context);
              },
              child: Text(Options.options[3]),
            ),
      ],
      builder: (context, controller, _) => IconButton(
        onPressed: () {
          if (!controller.isOpen) {
            controller.open();
          } else {
            controller.close();
          }
        },
        icon: const Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        style: IconButton.styleFrom(
            backgroundColor: note.noteData.color.withOpacity(0.5)),
      ),
    );
  }
}
