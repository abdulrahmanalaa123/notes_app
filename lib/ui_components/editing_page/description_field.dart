import 'package:flutter/material.dart';

import '../../constants/style_constants.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.descriptionController,
  });

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          controller: descriptionController,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Your description here',
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Constants.backGround, width: 2))),
        ),
      ),
    );
  }
}
