import 'notes.dart';

class Group {
  int? id;
  final String groupName;
  List<Note>? notesList;

  Group({this.id, required this.groupName, this.notesList});

  //both change group and removenote could be changed
  //to a list function that takes a list of selected notes
  //and change their groups or remove them all from the group

  void addToGroup(List<Note> note) {
    notesList ??= [];
    notesList!.addAll(note);
  }

  void setId(int newId) {
    id ??= newId;
  }

  void removeNote(Note note) {
    notesList?.remove(note);
  }

  void changeGroup(Note note, covariant Group group) {
    removeNote(note);
    group.addToGroup([note]);
  }

  factory Group.fromRow(Map<String, dynamic> row) =>
      Group(id: row['id'], groupName: row['group_name']);

  Map<String, dynamic> toRow() {
    Map<String, dynamic> initialMap = {'group_name': groupName};
    if (id != null) {
      initialMap['id'] = id;
    }
    return initialMap;
  }
}
