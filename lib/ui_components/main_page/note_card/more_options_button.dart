import 'package:flutter/material.dart';

import '../../../models/notes.dart';

class OptionsButton extends StatelessWidget {
  OptionsButton({required this.note, super.key});
  final Note note;
  final options = ['Edit', 'Delete', 'Add To Group', 'Remove From Group'];
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            onPressed: () {},
            child: Text(options[0]),
          ),
          MenuItemButton(
            onPressed: () {},
            child: Text(options[1]),
          ),
          MenuItemButton(
            onPressed: () {},
            child: Text(options[2]),
          ),
        ],
        builder: (context, _, k) => IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          style: IconButton.styleFrom(
              backgroundColor: note.noteData.color.withOpacity(0.5)),
        ),
      ),
    );
  }
}
