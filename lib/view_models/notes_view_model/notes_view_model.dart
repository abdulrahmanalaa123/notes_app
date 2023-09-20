import 'package:flutter/material.dart';
import 'package:notes_app/repo/notes_repo.dart';

import '../../models/group.dart';
import '../../models/notes.dart';

//this is dogshit the design of passing the provider
//as well as the restarting making the userID = to null
//as well as the list not showing any progress
//init doesnt work on opening after relogging in for some reason
//I dont know what is the problem
//TODO
//if the initializer in the constructor works then leave it cuz it kind of makes sense
//if not then figure out a way to initialize on logging in and disposing on logging out
//add the rest of the functionality to the viewModel
//the user_id is null when logging in from cache is an issue
//and i removed the dispose method  from the view model needs to be reassigned and invoked properly
class NotesViewModel extends ChangeNotifier {
  List<Note> _notesList = [];
  List<Group> _groupList = [];
  final NoteRepo? _noteRepo;
  bool _open = false;

  NotesViewModel() : _noteRepo = NoteRepo() {
    print('initializing instance x');
  }
  Future<void> init() async {
    //the nullable check is for extra layer of safety
    await _noteRepo!.init();
    _open = _noteRepo!.open;
    await readAll();
  }

  get notesList => _notesList;

  void sortByDate() {
    _notesList.sort((Note a, Note b) => a.compareTo(b));
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
    _groupList.clear();
    await _noteRepo!.dispose();
    notifyListeners();
    super.dispose();
  }

  Future<bool> addNote(Note note) async {
    if (!_open) {
      print('were here');
      return false;
    }
    bool state = await _noteRepo!.addNote(note);
    if (state) {
      _notesList.insert(0, note);
    }
    print('note id is:${note.id}');
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
    print(note.id);
    notifyListeners();
    return state;
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
}
