import 'package:notes_app/constants/table_names.dart';
import 'package:notes_app/helpers/sql_helper.dart';

import '../helpers/sp_helper.dart';
import '../models/group.dart';
import '../models/image_model.dart';
import '../models/notes.dart';

//TODO
//better error handling and removing try and catches and just
//using one at the view layer and proper error messages
//except unique error messages
//find them and see if there is a better implementation
//I think none is needed
class NoteRepo {
  static final NoteRepo _noteRepo = NoteRepo._();
  bool _open = false;
  final SqlHelper _sqlHelper;
  String? userId;
  SharedPreferenceHelper? _storageHelper;

  NoteRepo._() : _sqlHelper = SqlHelper();

  factory NoteRepo() {
    return _noteRepo;
  }
  Future<bool> init() async {
    _storageHelper = SharedPreferenceHelper();
    userId = await _storageHelper!.get('currentUser', String);
    _open = await _sqlHelper.open();
    print('Database is open: $_open');
    return _open;
  }

  get open => _open;
  //addnote
  //the note is pass by reference so all we need is a true and false indicator
  Future<bool> addNote(Note note) async {
    if (!_open) {
      return false;
    }
    int? id;
    bool state = false;
    //adding userId to the row before adding it to the database
    Map<String, dynamic> dataMap = note.toRow();
    dataMap['user_id'] = userId;
    id = await _sqlHelper.create(
        table: TableNames.notes, data: dataMap, raw: false);
    if (id != null && id != 0) {
      state = true;
      note.setId(id);
    } else {
      return state;
    }

    //id will be always not null since the above insertion went smoothly
    //state will always be true if it goes this far so no need to check for state
    if (note.noteData.imgPaths != null) {
      //should be replaced by a batch insertion in the sqlhelper but left as is for now
      //TODO
      //implement a batch insertion in sqlhelper
      Future.wait(note.noteData.imgPaths!.map((e) async {
        state = await addImage(e, note);
      }));
    }
    if (note.noteData.groups != null) {
      //should be replaced by a batch insertion in the sqlhelper but left as is for now
      //TODO
      //implement a batch insertion in sqlhelper
      Future.wait(note.noteData.groups!.map((e) async {
        state = await addNoteToGroup(note, e);
      }));
    }
    return state;
  }

  // turn into a transaction
  //because of rollback but i wont do it i know how so fuck it
  //its a hassle to edit my sqlhelper
  //deletenote
  Future<bool> deleteNote(Note note) async {
    if (!_open) {
      return false;
    }
    bool state = false;

    state = await _sqlHelper.delete(
        table: TableNames.notes, id: note.id, userId: userId, raw: false);
    if (state) {
      state = await _noteRemoveDatabaseReferences(note);
      return state;
    }
    return state;
  }

  Future<bool> _noteRemoveDatabaseReferences(Note note) async {
    if (!_open) {
      return false;
    }
    //here is true because if it deletes all and there was nothing then its done
    //deleting so it will be true as default and false if any issue occurs
    bool state = true;
    if (note.noteData.groups != null && note.noteData.groups!.isNotEmpty) {
      state = await _noteInstanceDeleteGroups(note);
    }
    if (note.noteData.imgPaths != null && note.noteData.imgPaths!.isNotEmpty) {
      state = await _noteInstanceDeleteImages(note);
    }
    return state;
  }

  Future<bool> _noteInstanceDeleteImages(Note note) async {
    if (!_open) {
      return false;
    }
    return await _sqlHelper.delete(
        raw: true,
        query: 'DELETE from ${TableNames.images} WHERE note_id = ?',
        argumentsList: [note.id.toString()]);
  }

  Future<bool> _noteInstanceDeleteGroups(Note note) async {
    if (!_open) {
      return false;
    }
    return await _sqlHelper.delete(
        raw: true,
        query:
            'DELETE FROM ${TableNames.notesJunc} WHERE ${TableNames.notesJunc}.note_id = ? ',
        argumentsList: [note.id.toString()]);
  }

  //updateNote
  Future<bool> updateNote(Note note) async {
    if (!_open) {
      return false;
    }
    bool state;

    state = await _sqlHelper.update(
        table: TableNames.notes, data: note.toRow(), id: note.id!, raw: false);
    return state;

    //TODO
    //implement reading changed images in sp or some sort instead of readling all images then comparing to my current list
    //id will be always not null since the above insertion went smoothly
    //either all of these should be a transaction
    //or shouldnt since transactions would be an overhead of computing
    //this was solved by adding id to the note.toRow so even if updated the above
    //it wouldnt set differnt notes on several retries of the above operation
    //I tried adding updating imagePaths but i see as kind of trivial since the path
    //will be the link of the image or the path in the phone and if its not there then you cant update it
    //and updating it would require me to add an image model and have an id so it seems redundant so im removing it in update in of itself
    //since the methods of updating would be adding or deleting and the interface exists
    //try {
    //  if (state) {
    //    newPaths.map((e) async {
    //      await _sqlHelper.update(
    //          table: TableNames.imageList,
    //          data: {'path': e, 'img_list_id': note.imgListId},
    //          id: note.userId,
    //          raw: true);
    //    });
    //    //no mapping is done for the image paths because the cascade property is set
    //  }
    //} catch (e) {
    //  print(e);
    //  return false;
    //}
    //return true;
  }

  //although i really cant think of a usecase for it
  //since im coding this before the UI its here for convenience and completing the CRUD
  //readNote
  Future<Note?> readNote(int id) async {
    if (!_open) {
      return null;
    }
    //get the note
    List<Map<String, dynamic>>? map = await _sqlHelper.read(
        raw: false, table: TableNames.notes, id: id, userId: userId);
    //only null if not initialized
    if (map == null || map.isEmpty) {
      return null;
    }

    //same as _notesFromRows but
    Note note = Note.fromRow(map.first);
    //select all images with the note_id = noteid
    note = await _noteAddImagesToInstance(note);
    //tihs works because of the referencing concept
    return await _noteAddGroupsToInstance(note);
  }

  //readAll
  Future<List<Note>> readAll() async {
    if (!_open) {
      return [];
    }
    //get the note
    List<Map<String, dynamic>>? map = await _sqlHelper.read(
        raw: false,
        table: TableNames.notes,
        userId: userId,
        orderBy: 'last_edited DESC');
    //only null if not initialized
    if (map == null || map.isEmpty) {
      return [];
    }

    return await _notesFromRows(map);
  }

  Future<List<Group>> readAllGroups() async {
    if (!_open) {
      return [];
    }
    //get the note
    List<Map<String, dynamic>>? map = await _sqlHelper.read(
        raw: false, table: TableNames.group, userId: userId);
    //only null if not initialized
    if (map == null || map.isEmpty) {
      return [];
    }

    final listOfGroups = map.map((e) => Group.fromRow(e)).toList();
    //select all images with the note_id = noteid

    return listOfGroups;
  }

  //this wont be used unless we have a database opened so its pointless to put an is open check
  Future<List<Note>> _notesFromRows(List<Map<String, dynamic>> map) async {
    final listOfNotes = map.map((e) => Note.fromRow(e));
    //select all images with the note_id = noteid
    final finalList = await Future.wait(listOfNotes.map((note) async {
      note = await _noteAddImagesToInstance(note);
      return await _noteAddGroupsToInstance(note);
    }).toList());

    return finalList;
  }

  Future<Note> _noteAddImagesToInstance(Note note) async {
    List<Map<String, dynamic>>? imgMap = await _sqlHelper.read(
        raw: true,
        query: 'SELECT * from ${TableNames.images} WHERE note_id = ?',
        argumentsList: [note.id.toString()]);
    if (imgMap == null || imgMap.isEmpty) {
      return note;
    } else {
      final imgList = imgMap.map((e) {
        return ImageModel.fromRow(e);
      }).toList();
      note.noteData.addImage(imgPath: imgList);
    }
    return note;
  }

  Future<Note> _noteAddGroupsToInstance(Note note) async {
    List<Map<String, dynamic>>? groupMap = await _sqlHelper.read(
        raw: true,
        query:
            'SELECT ${TableNames.group}.* FROM ${TableNames.group} INNER JOIN ${TableNames.notesJunc} ON ${TableNames.group}.id = ${TableNames.notesJunc}.group_id WHERE ${TableNames.notesJunc}.note_id = ? ',
        argumentsList: [note.id.toString()]);
    if (groupMap == null || groupMap.isEmpty) {
      return note;
    } else {
      final groupList = groupMap.map((e) {
        return Group.fromRow(e);
      }).toList();
      note.noteData.addToGroup(newGroups: groupList);
    }
    return note;
  }

  //readGroup
  //this is probably a useless method i couldnt imagine a usecase
  //its here in case i need it
  Future<List<Note>> readGroupNotes(Group group) async {
    if (!_open) {
      return [];
    }
    //get the note
    List<Map<String, dynamic>>? map = await _sqlHelper.read(
        raw: true,
        query:
            'SELECT Notes.* FROM Notes INNER JOIN NotesJunction ON Notes.id = NotesJunction.note_id WHERE NotesJunction.group_id = ? ',
        argumentsList: [group.id.toString()]);
    //only null if not initialized
    if (map == null || map.isEmpty) {
      return [];
    }

    return _notesFromRows(map);
  }

  //addGRoup
  Future<bool> addGroup(Group group) async {
    if (!_open) {
      return false;
    }
    int? id;

    Map<String, dynamic> dataMap = group.toRow();
    dataMap['user_id'] = userId;
    id = await _sqlHelper.create(
        table: TableNames.group, data: dataMap, raw: false);
    if (id != null) {
      group.setId(id);
      return true;
    } else {
      return false;
    }
  }

  //deleteGRoup
  Future<bool> deleteGroup(Group group) async {
    if (!_open) {
      return false;
    }
    bool state;

    state = await _sqlHelper.delete(
        table: TableNames.group, id: group.id, userId: userId, raw: false);

    if (state) {
      state = await _sqlHelper.delete(
          raw: true,
          query: 'DELETE FROM ${TableNames.notesJunc} WHERE group_id = ?',
          argumentsList: [group.id.toString()]);
    }

    return state;
  }

  //addNotetoGroup
  Future<bool> addNoteToGroup(Note note, Group group) async {
    if (!_open) {
      return false;
    }
    int? id = await _sqlHelper.create(
        raw: false,
        table: TableNames.notesJunc,
        data: {'note_id': note.id, 'group_id': group.id});
    if (id != null) {
      note.noteData.addToGroup(newGroups: [group]);

      return true;
    }
    return false;
  }

  //removeNoteFromGroup
  Future<bool> removeNoteFromGroup(Note note, Group group) async {
    if (!_open) {
      return false;
    }
    bool state = false;
    state = await _sqlHelper.delete(
        raw: true,
        query:
            'DELETE FROM ${TableNames.notesJunc} WHERE note_id = ? AND group_id = ?',
        argumentsList: [note.id.toString(), group.id.toString()]);

    if (state) {
      note.noteData.removeFromGroup(group: group);
      return state;
    }
    return state;
  }

  //havent been used in my features so ill leave it
  //but should check
  Future<bool> changeGroup(
      {required Note note,
      required Group group1,
      required Group group2}) async {
    if (!_open) {
      return false;
    }
    bool state = await _sqlHelper.update(
        raw: true,
        query:
            'UPDATE ${TableNames.notesJunc} SET group_id = ? WHERE note_id = ? AND group_id = ?',
        argumentsList: [
          group2.id.toString(),
          note.id.toString(),
          group1.id.toString()
        ]);
    if (state) {
      note.noteData.removeFromGroup(group: group1);
      note.noteData.addToGroup(newGroups: [group2]);
      return true;
    }
    return false;
  }

  //addImageToList
  Future<bool> addImage(ImageModel image, Note note) async {
    if (!_open) {
      return false;
    }
    Map<String, dynamic> dataMap = image.toRow();
    dataMap['user_id'] = userId;
    dataMap['note_id'] = note.id;
    int? id = await _sqlHelper.create(
        raw: false, table: TableNames.images, data: dataMap);
    if (id != 0 && id != null) {
      image.setId(id);
      note.noteData.addImage(imgPath: [image]);
      return true;
    }

    return false;
  }

  //deleteImageFromList
  Future<bool> deleteImage(ImageModel image) async {
    if (!_open) {
      return false;
    }
    return await _sqlHelper.delete(
        raw: false, table: TableNames.images, userId: userId, id: image.id);
  }

  Future<bool> dispose() async {
    return await _sqlHelper.close();
  }

  Future<void> updateUserId() async {
    userId = await _storageHelper?.get('currentUser', String);
  }
}
