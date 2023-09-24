import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BodyField extends StatelessWidget {
  const BodyField({
    super.key,
    required this.titleController,
    required this.bodyController,
  });

  final TextEditingController titleController;
  final TextEditingController bodyController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        //which basically means if youre in an editing state
        autofocus: titleController.text.isNotEmpty ? true : false,
        keyboardType: TextInputType.multiline,
        //left here before it was null
        //but maxlines enforcement is set to none so this acts
        //as just a bigger area to just focus out the textfield
        //the arbitary number is cringe
        //but fuck it
        //TODO
        //find a better implementation to add all
        //to a singleChildScrollView and add an extra space in
        //which it will focus this textfield by pressing in it
        maxLines: 16,
        textInputAction: TextInputAction.newline,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        controller: bodyController,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Text Here',
        ),
        onChanged: (val) {
          print(val);
        },
      ),
    );
  }
}
