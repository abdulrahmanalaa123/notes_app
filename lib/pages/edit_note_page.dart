import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_data.dart';
import 'package:notes_app/view_models/notes_view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

import '../models/notes.dart';
import 'package:notes_app/constants/style_constants.dart';

import '../ui_components/editing_page/action_buttons.dart';
import '../ui_components/editing_page/body_field.dart';
import '../ui_components/editing_page/color_picker.dart';
import '../ui_components/editing_page/description_field.dart';
import '../ui_components/editing_page/title_field.dart';

class EditNote extends StatefulWidget {
  const EditNote({this.note, super.key});
  final Note? note;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late final TextEditingController descriptionController;
  late Color color;
  late Color excludedColor;

  final random = Random();
  @override
  void initState() {
    titleController = TextEditingController(text: widget.note?.noteData.title);
    bodyController = TextEditingController(text: widget.note?.noteData.body);
    descriptionController =
        TextEditingController(text: widget.note?.noteData.description);
    color = widget.note != null ? widget.note!.noteData.color : Constants.beige;
    excludedColor = _excludeColor();
    super.initState();
  }

  void _switchColors(Color newColor) {
    setState(() {
      if (newColor != color) {
        color = newColor;
        excludedColor = _excludeColor();
      }
    });
  }

  Color _excludeColor() {
    return Constants.listOfColors
        .where((element) => element != color)
        .toList()[random.nextInt(4)];
  }

  //at this point my mind is giving me blanks
  //so i just gotta finish this version and optimize later
  //keep that in mind in this page
  Future<void> _navigationFunc() async {
    //for ease of use
    final note = widget.note;
    bool state = false;
    if (note != null) {
      final state1 = titleController.text != note.noteData.title;
      final state2 = bodyController.text != note.noteData.body;
      final state3 = descriptionController.text != note.noteData.description;
      final state4 = color != note.noteData.color;
      state = state1 || state2 || state3 || state4;
    } else {
      if (titleController.text.isNotEmpty) {
        await context.read<NotesViewModel>().addNote(Note(
            createdAt: DateTime.now(),
            noteData: NoteData(
                title: titleController.text,
                body: bodyController.text,
                description: descriptionController.text,
                color: color)));
      }
    }
    if (state) {
      //state will never be true unless it checks in the firstplace
      //context will never be used or in an async gap since the above
      //functions will never intertwine so ill disregard the warning
      await context.read<NotesViewModel>().editNote(note!,
          newName: titleController.text,
          newText: bodyController.text,
          newDescription: descriptionController.text,
          newColor: color);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: color,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NotePageActionButtons(
                      func: _navigationFunc,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DescriptionField(
                              descriptionController: descriptionController),
                        ),
                        ColorPicker(color: excludedColor, func: _switchColors),
                        const SizedBox(
                          width: 28,
                        )
                      ],
                    )
                  ],
                ),
                TitleField(titleController: titleController),
                BodyField(
                  titleController: titleController,
                  bodyController: bodyController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
