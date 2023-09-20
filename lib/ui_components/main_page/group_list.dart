import 'package:flutter/material.dart';

import 'group_selection_element.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        bool first = false;
        if (index == 0) first = true;
        return GroupSelectionElement(
            groupName: 'hello', first: first, selected: first);
      },
    );
  }
}
