import 'notes.dart';

//current group architecture and repo handling
//turns out i store a lsit for all group
//so suppose a user adds all notes to all groups
//ill have that copy of all notes to these groups
//in the database they refer to one but how i fetch and store is the issue
//instead of giving them a group attribute and using group model
//i store all of them in this model
//but for that to happen i need a one to many relationship
//but the many to many feature is what proposed this architecture
//ill leave it at that but im done for now
//idk maybe filter wiht a list of groups  as an attribute in the note
//and they refer to a group object with a note junction
//and do the filtering in here with list.contains
//but this proposes the issue that is always performance vs memory
//groups model is fast but is a memory problem while using a list of groups
//saves space for sure but each time you filter you need to query which is probably better but ill stick to this
//because i dont want to redo all again
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
