import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/style_constants.dart';
import '../../models/group.dart';
import '../../view_models/notes_view_model/notes_view_model.dart';

//refactored just for rebuild instead of writing the context.select inside the text widget specifically
//which makes more sense to me
class GroupNameText extends StatelessWidget {
  const GroupNameText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Group? group =
        context.select<NotesViewModel, Group?>((value) => value.selectedGroup);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            group != null ? group.groupName : 'All',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 48,
              color: Constants.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Notes',
            style: TextStyle(
              fontSize: 48,
              color: Constants.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
