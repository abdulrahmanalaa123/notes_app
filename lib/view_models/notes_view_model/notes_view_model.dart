import 'package:flutter/material.dart';
import 'package:notes_app/repo/notes_repo.dart';

import '../../models/group.dart';
import '../../models/notes.dart';

//TODO
//move the tries and catch from the helper to the view model or the UI
//and just changing the return of confirmation functions and just changing it to void
class NotesViewModel extends ChangeNotifier {
  List<Note> _notesList = <Note>[];
  List<Group> groupList = <Group>[
    Group(groupName: 'Favourite'),
  ];
  Group? _selectedGroup;
  final NoteRepo? _noteRepo;
  bool _open = false;

  NotesViewModel() : _noteRepo = NoteRepo();

  Future<void> init() async {
    await _noteRepo!.init();
    _open = _noteRepo!.open;
    await readAll();
    await readAllGroups();
  }

  get selectedGroup => _selectedGroup;
  get selectedList {
    if (_selectedGroup != null) {
      //to return a filtered group the first design choice was to make another list
      //that contains selected values but at editing it turned out to be a havoc where editing
      //wouldnt show on the current list which was a copy and not a reference of the list
      //so we should return a sublisted list of notes which contains a reference to the original list
      //and is at the same time filtered which is a hundred folds a better design choice
      return _filterByGroup(_selectedGroup!) ?? <Note>[];
    }
    {
      return _notesList;
    }
  }

  //usually done after applying filter or no effect will be seen
  //dumb dynamic but it combines functionality instead of retyping the same code
  //or pass selection as a state or using it before getting context
  //which is much better this way
  List<Note>? _filterByGroup(Group group) {
    if (_notesList.isNotEmpty) {
      if (group.groupName == 'Favourite') {
        return _notesList.where((element) {
          return element.noteData.isFavorite == 1;
        }).toList();
      } else {
        return _notesList.where((element) {
          return element.noteData.hasGroup(group: group);
        }).toList();
      }
    }
    notifyListeners();
    return null;
  }

  void switchIndex(int newIndex) {
    //after deleting a group the selected group is null
    //which means it references the element and doesnt copy it
    //which is insanely convenient!
    if (newIndex >= 0) {
      _selectedGroup = groupList[newIndex];
    } else {
      _selectedGroup = null;
    }
    notifyListeners();
  }

  void sortByDate() {
    //this reverse sort because a to b resulted in an inverted list
    _notesList.sort((Note a, Note b) => b.compareTo(a));
    notifyListeners();
  }

  void sortByText() {
    _notesList.sort((Note a, Note b) => a.compareByText(b));
    notifyListeners();
  }

  void sortByTitle() {
    _notesList.sort((Note a, Note b) => a.compareByTitle(b));
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    _notesList.clear();
    groupList.clear();
    await _noteRepo!.dispose();
    notifyListeners();
    super.dispose();
  }

  Future<bool> addGroup({required String groupName}) async {
    if (!_open) {
      return false;
    }
    Group requiredGroup = Group(groupName: groupName);
    bool state = await _noteRepo!.addGroup(requiredGroup);
    if (state) {
      groupList.add(requiredGroup);
    }
    print('group id is:${requiredGroup.id}');
    notifyListeners();
    return state;
  }

  Future<bool> removeGroup(Group group) async {
    if (!_open) {
      return false;
    }

    bool state = await _noteRepo!.deleteGroup(group);
    if (state) {
      groupList.remove(group);
      //although the where is inefficient
      //it might benefit if the groups list in the notes are large
      //so filtering the elements first would reduce the amount of times you need to restructure
      //the note
      //for (var e in _notesList.where((element) => element.noteData.hasGroup(group: group)))
      //nvm fuck it its worse probably but it will be left for further inspection maybe some trial and error
      for (var e in _notesList) {
        e.noteData.removeFromGroup(group: group);
      }
      //this line is related to the my apps functionality where
      //if you delete a group you must be selecting it
      //so it would refer you to the all notes
      //it would better be added to the UI instead since this wouldnt
      //be reusable completely in this current form

      //_selectedGroup = null;
    }
    print('removed group id is :${group.id}');
    notifyListeners();
    return state;
  }

  Future<void> _addNoteToGroup(
      {required Note note, required Group group}) async {
    if (_open) {
      //if i use it it will probably be ported from a hashset in multiselect
      //so i must reference that note in my original list to modify the elements app wise
      //turns out i added a functionality where i do not add from a different list but fuck it its here to universalize
      //the function no need to compose 2 functions just for an extra functionality
      //fuck it
      int noteIndex = _notesList.indexOf(note);
      await _noteRepo!.addNoteToGroup(_notesList[noteIndex], group);
      notifyListeners();
    }
  }

  Future<void> _removeNoteFromGroup(
      {required Note note, required Group group}) async {
    if (_open) {
      int noteIndex = _notesList.indexOf(note);
      //i get the index first to reference the note since it would be coming from
      //a hashset in the multiselect thats why i want to pass an object refernce not another object
      await _noteRepo!.removeNoteFromGroup(_notesList[noteIndex], group);
      notifyListeners();
    }
  }

  Future<bool> removeNotesFromGroup(
      {required Iterable<Note> notes, required Group group}) async {
    if (!_open) {
      return false;
    }
    Future.wait(notes.map((e) async {
      await _removeNoteFromGroup(group: group, note: e);
    }));

    notifyListeners();
    return true;
  }

  Future<bool> addNotesToGroup(
      {required Iterable<Note> notes, required Group group}) async {
    if (!_open) {
      return false;
    }
    Future.wait(notes.map((e) async {
      await _addNoteToGroup(group: group, note: e);
    }));
    notifyListeners();
    return true;
  }

  //all of those are bad has no error handling but fuck it for now
  //first get it to work then add error Handling
  //TODO
  //error handling
  Future<bool> addNote(Note note) async {
    if (!_open) {
      return false;
    }
    bool state = await _noteRepo!.addNote(note);
    if (state) {
      //insert is at 0 because added note is probably the most recent
      _notesList.insert(0, note);
    }
    print('note id is:${note.id}');
    notifyListeners();
    return state;
  }

  //TODO
  //implement updating with a new notesData object
  //and adding that newDataObject to edit the Note
  //which would required me to add
  //the images adding functionality
  //and the groups adding functionality in the editing phase
  //or just
  Future<bool> editNote(
    Note note, {
    String? newName,
    String? newText,
    String? newDescription,
    int? favorite,
    Color? newColor,
  }) async {
    if (!_open) {
      return false;
    }
    //supposedly this would be from the notepage and
    //using the gridview which would be passed a reference to the list
    //element so if not i must get the index first then edit it
    //ill leave it to check first and then if not ill will add a index get
    //then element reference
    //it gets an element reference which is good
    note.noteData.editFields(
        newName: newName,
        newText: newText,
        newDescription: newDescription,
        newColor: newColor,
        favorite: favorite);

    bool state = await _noteRepo!.updateNote(note);
    //resort after editing any note
    sortByDate();
    notifyListeners();
    return state;
  }

  Future<bool> removeNote(Note note) async {
    if (!_open) {
      return false;
    }
    bool state = await _noteRepo!.deleteNote(note);
    if (state) {
      _notesList.remove(note);
    }
    notifyListeners();
    return state;
  }

  Future<bool> removeListOfNote(Iterable<Note> notes) async {
    if (!_open) {
      return false;
    }
    //future.wait is needed to initiate an insance of the notesmap
    //since its a lazy iterable and needs to be called upon to run
    //and since its an iterable of a future for it to work we need to wait
    //so each future in the list is awaited
    Future.wait(notes.map((e) async {
      await removeNote(e);
    }));

    notifyListeners();
    return true;
  }

  //probably useless
  Future<bool> addListOfNote(Iterable<Note> notes) async {
    if (!_open) {
      return false;
    }
    Future.wait(notes.map((e) async {
      await addNote(e);
    }));

    notifyListeners();
    return true;
  }

  Future<bool> readAll() async {
    if (!_open) {
      return false;
    }
    _notesList = await _noteRepo!.readAll();
    if (_notesList.isNotEmpty) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> readAllGroups() async {
    if (!_open) {
      return false;
    }
    groupList.addAll(await _noteRepo!.readAllGroups());
    if (groupList.isNotEmpty) {
      notifyListeners();
      return true;
    }
    return false;
  }
}
