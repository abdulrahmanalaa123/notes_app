import 'dart:collection';

import 'notes.dart';
import 'notes_list.dart';

class Group {
  final int id;
  final int userId;
  final String groupName;
  NotesList _notesList;

  Group(
      {required this.id,
      required this.userId,
      required this.groupName,
      required NotesList notesList})
      : _notesList = notesList;

  //both change group and removenote could be changed
  //to a list function that takes a list of selected notes
  //and change their groups or remove them all from the group
  UnmodifiableListView<Note> getAll() {
    return _notesList.selectAll();
  }

  void addToGroup(Note note) {
    _notesList.addNote(note);
  }

  void removeNote(Note note) {
    _notesList.deleteNote(note);
  }

  void changeGroup(Note note, covariant Group group) {
    removeNote(note);
    group.addToGroup(note);
  }
}
