import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/notes_view_model/notes_view_model.dart';
import 'elements_count_component.dart';

class GroupSelectionElement extends StatelessWidget {
  const GroupSelectionElement(
      {required this.groupName,
      this.first = false,
      required this.selected,
      this.count,
      super.key});
  final String groupName;
  final bool selected;
  final int? count;
  final bool first;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: first
          ? const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: selected ? Colors.white : Colors.white30, width: 2)),
      child: Row(
          mainAxisAlignment: !selected
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Text(
              groupName,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.white30,
                  fontWeight: FontWeight.w400,
                  fontSize: 24),
            ),
            selected ? const SizedBox(width: 12) : const SizedBox.shrink(),
            selected
                ? ElementsCountComponent(
                    //the count is simply a read because any change to the list will affect
                    //the listview.builder so in turn will rebuild this so at the moment of rebuilding
                    //this will be right probably
                    count: context.read<NotesViewModel>().selectedList.length)
                : const SizedBox.shrink(),
          ]),
    );
  }
}
