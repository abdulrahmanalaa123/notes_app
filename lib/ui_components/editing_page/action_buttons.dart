import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_page/buttons/glass_container.dart';

class NotePageActionButtons extends StatelessWidget {
  const NotePageActionButtons({
    required this.func,
    super.key,
  });
  final Future<void> Function() func;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GlassContainer(
          blur: 15,
          opacity: 0.1,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: IconButton(
              onPressed: func,
              icon: const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              )),
        ),
        GlassContainer(
          blur: 15,
          opacity: 0.1,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.share,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}
