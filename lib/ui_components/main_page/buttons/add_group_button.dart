import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/notes_view_model/notes_view_model.dart';
import '../add_group_dialog.dart';

class AddGroupButton extends StatelessWidget {
  const AddGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //TODO
        //showDialog to enter GroupName
        final String? groupName = await showDialog<String?>(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              //mainly refactored to add its own textcontroller and properly dispose it
              return const AddGroupDialog();
            });
        if (groupName != null && context.mounted) {
          final viewModel = context.read<NotesViewModel>();
          await viewModel.notesErrorIndicator.oneInputFuncWrapper<void, String>(
              func: viewModel.addGroup, object: groupName, context: context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        padding: const EdgeInsets.all(8),
        child: const Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              'Add Group',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
