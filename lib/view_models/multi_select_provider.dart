import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/notes.dart';

class MultiSelect extends ChangeNotifier {
  bool _multiSelectOption = false;
  final HashSet<Note> _checkHashSet = HashSet<Note>();
  MultiSelect();

  bool get isMultiSelectEnabled => _multiSelectOption;
  HashSet<Note> get checkSet => _checkHashSet;

  void changeMode() {
    _multiSelectOption = !_multiSelectOption;
    notifyListeners();
  }

  void checkUncheck(Note note) {
    if (_checkHashSet.contains(note)) {
      _checkHashSet.remove(note);
    } else {
      _checkHashSet.add(note);
    }
    notifyListeners();
  }

  //supposedly an O(1) operation since its a hashset
  bool isChecked(Note note) {
    return _checkHashSet.contains(note);
  }

  void checkAll(Iterable<Note> notes) {
    _checkHashSet.addAll(notes);
    notifyListeners();
  }

  void unCheckAll(Iterable<Note> notes) {
    _checkHashSet.removeAll(notes);
    notifyListeners();
  }

  void clear() {
    _checkHashSet.clear();
    notifyListeners();
  }
}
