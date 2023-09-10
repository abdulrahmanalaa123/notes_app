import 'package:flutter/material.dart';

import '../models/notes.dart';

class TestingNote extends StatefulWidget {
  const TestingNote({super.key});

  @override
  State<TestingNote> createState() => _TestingNoteState();
}

class _TestingNoteState extends State<TestingNote> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    bodyController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Enter your Title',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: titleController,
          ),
          const Text(
            'Enter your body',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: bodyController,
          ),
          const Text(
            'Enter your desc',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: descriptionController,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    Note(
                        body: bodyController.text,
                        title: titleController.text,
                        description: descriptionController.text,
                        createdAt: DateTime.now()));
              },
              child: const Text('Save your Note'))
        ],
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
