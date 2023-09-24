import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/notes.dart';

class CardDateComponent extends StatelessWidget {
  const CardDateComponent({
    super.key,
    required this.left,
    required this.note,
  });

  final bool left;
  final Note note;
  String _dateParsingFunc() {
    final now = DateTime.now();
    final difference = note.noteData.lastEdited!.difference(now);

    if (!note.createdAt.isAtSameMomentAs(note.noteData.lastEdited!)) {
      if (difference.inDays > 0) {
        return 'Last edited ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return 'Last edited ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      }
      return 'Last edited ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'created at: ${DateFormat('yyyy-MM-dd').format(note.createdAt)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = _dateParsingFunc();

    return Row(
      children: [
        if (left)
          const SizedBox(
            width: 16,
          ),
        Flexible(
          child: Text(
            date,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
