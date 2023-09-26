import 'package:flutter/material.dart';
import 'buttons/add_group_button.dart';
import 'current_group_text.dart';

class GroupTextIdentifier extends StatelessWidget {
  const GroupTextIdentifier({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex: 2, child: GroupNameText()),
          Expanded(child: AddGroupButton()),
        ],
      ),
    );
  }
}
