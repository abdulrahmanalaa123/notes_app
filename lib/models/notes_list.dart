import 'dart:collection';

import 'image_model.dart';
import 'notes.dart';

//deprecated
@deprecated
class NotesList {
  final int id;
  final int userId;
  List<Note> _notesList;

  NotesList(
      {required this.id, required this.userId, required List<Note> notesList})
      : _notesList = notesList;

  UnmodifiableListView<Note> selectAll() {
    return UnmodifiableListView(_notesList);
  }

  Note selectCopy(Note note) {
    return _notesList[_notesList.indexOf(note, 0)];
  }

  int _innerSelect(Note note) {
    return _notesList.indexOf(note, 0);
  }

  void edit(Note note, {String? name, String? text, String? description}) {
    // _notesList[_innerSelect(note)]
    //     .editFields(newName: name, newText: text, newDescription: description);
  }

  void addImg(Note note, {required ImageModel imgPath}) {
    //_notesList[_innerSelect(note)].addImage(imgPath: [imgPath]);
  }

  void deleteImg(Note note, {required ImageModel imgPath}) {
    // _notesList[_innerSelect(note)].addImage(imgPath: [imgPath]);
  }

  void addNote(Note note) {
    _notesList.add(note);
  }

  void deleteNote(Note note) {
    _notesList.remove(note);
  }

  void sortByTime() {
    _notesList.sort((Note a, Note b) => a.compareTo(b));
  }

  void sortByText() {
    _notesList.sort((Note a, Note b) => a.compareByText(b));
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
