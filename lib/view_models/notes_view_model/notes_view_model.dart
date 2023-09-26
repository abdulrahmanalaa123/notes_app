import 'package:flutter/material.dart';
import 'package:notes_app/models/general_error_indicator.dart';
import 'package:notes_app/repo/notes_repo.dart';

import '../../models/group.dart';
import '../../models/notes.dart';
import '../../models/notes_data.dart';

//move the tries and catch from the helper to the view model or the UI
//and just changing the return of confirmation functions and just changing it to void

//This was done but the implementation had two issues either putting this here and rewrite everyFunction
//to request for context as an input parameter which is a feasible solution or just adding the error indicator
//object to all function calls which made more sense in the context of its a UI solution so it must be in the UI
//and not a programmatic solution so passing context to a function that should only read from the databse or fetch data
//doesnt make much sense although i see it as a better and a more neat implementation
//ill just change every operation instead of sending a confirmation which is useless to just a void function
//removed the open check since it made more sense to be in the notesRepo and not the viewing model
class NotesViewModel extends ChangeNotifier {
  List<Note> _notesList = <Note>[];
  // i coudlve set it to private and a getter to allow no outside access
  //but it insists on it being final idk why
  List<Group> groupList = <Group>[
    Group(groupName: 'Favourite'),
  ];
  Group? _selectedGroup;
  final NotesErrorIndicator notesErrorIndicator;
  final NoteRepo _noteRepo;

  NotesViewModel()
      : _noteRepo = NoteRepo(),
        notesErrorIndicator = NotesErrorIndicator();

  Future<void> init() async {
    await _noteRepo.init();

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
      //for specifically the case of updating and usage
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

  //all will be used if we use filters
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
    await _noteRepo.dispose();
    notifyListeners();
    super.dispose();
  }

  Future<void> addGroup(String groupName) async {
    Group requiredGroup = Group(groupName: groupName);
    bool state = await _noteRepo.addGroup(requiredGroup);
    if (state) {
      groupList.add(requiredGroup);
    }
    notifyListeners();
  }

  Future<void> removeGroup(Group group) async {
    //deleteGroup deletes all references in of itself which is a bit of an inconsistency
    //instead of using the removeNoteFromGroup function in the noteRepo or here but it is more efficient and not needed for anotehr function
    bool state = await _noteRepo.deleteGroup(group);
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

      //_selectedGroup = null;
      //this line is related to the my apps functionality where
      //if you delete a group you must be selecting it
      //so it would refer you to the all notes
      //it would better be added to the UI instead since this wouldnt
      //be reusable completely in this current form
    }
    notifyListeners();
  }

  Future<void> _addNoteToGroup(
      {required Note note, required Group group}) async {
    //if i use it it will probably be ported from a hashset in multiselect
    //so i must reference that note in my original list to modify the elements app wise
    //turns out i added a functionality where i do not add from a different list but fuck it its here to universalize
    //the function no need to compose 2 functions just for an extra functionality
    //fuck it
    int noteIndex = _notesList.indexOf(note);
    await _noteRepo.addNoteToGroup(_notesList[noteIndex], group);
    notifyListeners();
  }

  Future<void> _removeNoteFromGroup(
      {required Note note, required Group group}) async {
    int noteIndex = _notesList.indexOf(note);
    //i get the index first to reference the note since it would be coming from
    //a hashset in the multiselect thats why i want to pass an object refernce to my list notes not another object
    await _noteRepo.removeNoteFromGroup(_notesList[noteIndex], group);
    notifyListeners();
  }

  Future<void> removeNotesFromGroup(Iterable<Note> notes, Group group) async {
    Future.wait(notes.map((e) async {
      await _removeNoteFromGroup(group: group, note: e);
    }));

    notifyListeners();
  }

  Future<void> addNotesToGroup(Iterable<Note> notes, Group group) async {
    Future.wait(notes.map((e) async {
      await _addNoteToGroup(group: group, note: e);
    }));
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    bool state = await _noteRepo.addNote(note);
    if (state) {
      //insert is at 0 because added note is probably the most recent
      _notesList.insert(0, note);
    }
    notifyListeners();
  }

  //TODO
  //implement updating with a new notesData object
  //and adding that newDataObject to edit the Note
  //which would required me to add
  //the images adding functionality
  //and the groups adding functionality in the editing phase
  //so probably i wont do so fuck it
  Future<void> editNote(
    Note note,
    NoteData newNoteData,
  ) async {
    NoteData rollBackData = NoteData.copy(note.noteData);

    //supposedly this would be from the notepage and
    //using the gridview which would be passed a reference to the list
    //element so if not i must get the index first then edit it
    //ill leave it to check first and then if not ill will add a index get
    //then element reference
    //it gets an element reference which is good

    //here its not a copy because
    //i only need the new fields dont need imgPaths and groups
    note.noteData.editFields(
        newName: newNoteData.title,
        newText: newNoteData.body,
        newDescription: newNoteData.description,
        newColor: newNoteData.color,
        favorite: newNoteData.isFavorite);

    //i give it a new note just to edit so i must edit the past note or i could give a new note the same id
    //it would literally be the same as the rollback method so fuck it
    //even if not fuck it as well
    bool state = await _noteRepo.updateNote(note);
    if (state) {
      //resort after editing any note
      sortByDate();
      notifyListeners();
    } else {
      //revert the data if it hasnt changed
      note.noteData = NoteData.copy(rollBackData);
    }
  }

  Future<void> removeNote(Note note) async {
    bool state = await _noteRepo.deleteNote(note);
    if (state) {
      _notesList.remove(note);
    }
    notifyListeners();
  }

  Future<void> removeListOfNote(Iterable<Note> notes) async {
    //future.wait is needed to initiate an insance of the notesmap
    //since its a lazy iterable and needs to be called upon to run
    //and since its an iterable of a future for it to work we need to wait
    //so each future in the list is awaited
    Future.wait(notes.map((e) async {
      await removeNote(e);
    }));
    notifyListeners();
  }

  //probably useless
  Future<void> addListOfNote(Iterable<Note> notes) async {
    Future.wait(notes.map((e) async {
      await addNote(e);
    }));
    notifyListeners();
  }

  Future<void> readAll() async {
    _notesList = await _noteRepo.readAll();
    //dont know if this is useful maybe just notify listeners its pointless
    notifyListeners();
  }

  Future<void> readAllGroups() async {
    groupList.addAll(await _noteRepo.readAllGroups());
    notifyListeners();
  }
}
