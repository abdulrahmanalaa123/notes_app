import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 4,
        controller: titleController,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 48,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Untitled',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.backGround, width: 2))),
      ),
    );
  }
}
