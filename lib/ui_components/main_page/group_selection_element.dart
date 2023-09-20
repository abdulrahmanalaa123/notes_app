import 'package:flutter/material.dart';

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
          ? const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8)
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
                ? ElementsCountComponent(count: count)
                : const SizedBox.shrink(),
          ]),
    );
  }
}
