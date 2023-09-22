import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/notes_view_model/notes_view_model.dart';
import 'multi_select_page/multi_select_actions_widget.dart';
import 'buttons/glass_container.dart';
import 'buttons/main_page_action_buttons.dart';

class PageActions extends StatelessWidget {
  const PageActions({
    super.key,
    required this.multiSelect,
  });

  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    //its read because when changing multiSelect which in turn requires a group
    //for sure you ahve changed the group before so it would never change
    //thats why read works for our case while we need to read current group like in the mainPage buttons
    //we have a select statement inside
    final bool inGroup = context.read<NotesViewModel>().selectedGroup != null;
    return GlassContainer(
      blur: 15,
      opacity: 0.2,
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: !multiSelect
            ? 130
            : inGroup
                ? 40
                : 110,
      ),
      child: !multiSelect
          ? const MainModeActionButtons()
          : const MultiSelectActions(),
    );
  }
}
