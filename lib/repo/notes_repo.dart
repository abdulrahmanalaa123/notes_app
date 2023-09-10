import 'package:notes_app/constants/table_names.dart';
import 'package:notes_app/helpers/sql_helper.dart';

import '../models/group.dart';
import '../models/image_model.dart';
import '../models/notes.dart';

//the image list table is useless but its better in deletion
//due to the cascade property
//although its such a hassle and i would understand if it is seen as useless
//but I've already just given into it
//nvm on second thought its much worse
//TODO
//error handling in either this Repo
//or in the viewModel or controller
class NoteRepo {
  final SqlHelper _sqlHelper;
  String? userId;
  NoteRepo({required this.userId}) : _sqlHelper = SqlHelper();

  Future<bool> init() async {
    return await _sqlHelper.open();
  }

  //addnote
  //the note is pass by reference so all we need is a true and false indicator
  Future<bool> addNote(Note note) async {
    int? id;
    try {
      //adding userId to the row before adding it to the database
      Map<String, dynamic> dataMap = note.toRow();
      dataMap['user_id'] = userId;
      print(userId);
      print(dataMap);
      id = await _sqlHelper.create(
          table: TableNames.notes, data: dataMap, raw: false);
      if (id != null && id != 0) {
        note.setId(id);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    //id will be always not null since the above insertion went smoothly

    try {
      if (note.imgPaths != null) {
        //should be replaced by a batch insertion in the sqlhelper but left as is for now
        //TODO
        //implement a batch insertion in sqlhelper
        note.imgPaths!.map((e) async {
          await addImage(e, note.id!);
        });
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  // turn into a transaction
  //deletenote
  Future<bool> deleteNote(Note note) async {
    try {
      return await _sqlHelper.delete(
          table: TableNames.notes, id: note.id, userId: userId, raw: false);
    } catch (e) {
      print(e);
      return false;
    }
    //id will be always not null since the above insertion went smoothly
    //there is no need for this because i think cascade is set
    //ill leave it commented in case it doesnt work
    // try {
    //   if (note.imgPaths != null && state) {
    //     state = await _sqlHelper.delete(
    //         query: 'DELETE FROM ${TableNames.images} WHERE note_id = ?',
    //         argumentsList: [note.id.toString()],
    //         raw: true);
    //   }
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
    // return true;
  }

  //updateNote
  Future<bool> updateNote(Note note) async {
    try {
      return await _sqlHelper.update(
          table: TableNames.notes,
          data: note.toRow(),
          id: note.id!,
          raw: false);
    } catch (e) {
      return false;
    }
    //id will be always not null since the above insertion went smoothly
    //either all of these should be a transaction
    //or shouldnt since transactions would be an overhead of computing
    //this was solved by adding id to the note.toRow so even if updated the above
    //it wouldnt set differnt notes on several retries of the above operation
    //I tried adding updating imagePaths but i see as kind of trivial since the path
    //will be the link of the image or the path in the phone and if its not there then you cant update it
    //and updating it would require me to add an image model and have an id so it seems redundant so im removing it in update in of itself
    //since the methods of updating would be adding or deleting and the interface exists
    // try {
    //   if (newPaths != null && state) {
    //     newPaths.map((e) async {
    //       await _sqlHelper.update(
    //           table: TableNames.imageList,
    //           data: {'path': e, 'img_list_id': note.imgListId},
    //           id: note.userId,
    //           raw: true);
    //     });
    //     //no mapping is done for the image paths because the cascade property is set
    //   }
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
    // return true;
  }

  //although i really cant think of a usecase for it
  //since im coding this before the UI its here for convenience and completing the CRUD
  //readNote
  Future<Note?> readNote(int id) async {
    try {
      //get the note
      List<Map<String, dynamic>>? map = await _sqlHelper.read(
          raw: false, table: TableNames.notes, id: id, userId: userId);
      //only null if not initialized
      if (map == null || map.isEmpty) {
        return null;
      }

      final note = Note.fromRow(map.first);
      //select all images with the note_id = noteid
      return await _noteAddImagesToInstance(note);
    } catch (e) {
      //could return null but this is basic so it shouldnt be allowed
      print('Error is: $e');
      rethrow;
    }
  }

  //readAll
  Future<List<Note>> readAll() async {
    try {
      //get the note
      List<Map<String, dynamic>>? map = await _sqlHelper.read(
          raw: false,
          table: TableNames.notes,
          userId: userId,
          orderBy: 'last_edited');
      //only null if not initialized
      if (map == null || map.isEmpty) {
        return [];
      }

      final listOfNotes = map.map((e) => Note.fromRow(e));
      //select all images with the note_id = noteid
      final finalList = await Future.wait(listOfNotes.map((note) async {
        return await _noteAddImagesToInstance(note);
      }).toList());

      return finalList;
    } catch (e) {
      print("Error is $e");
      rethrow;
    }
  }

  //readGroup
  Future<bool> readGroupNotes(Group group) async {
    try {
      //get the note
      List<Map<String, dynamic>>? map = await _sqlHelper.read(
          raw: true,
          query:
              'SELECT Notes.* FROM Notes INNER JOIN NotesJunction ON Notes.id = NotesJunction.note_id WHERE NotesJunction.group_id = ? ',
          argumentsList: [group.id.toString()]);
      //only null if not initialized
      if (map == null || map.isEmpty) {
        return false;
      }

      final listOfNotes = map.map((e) => Note.fromRow(e));
      //select all images with the note_id = noteid
      final finalList = await Future.wait(listOfNotes.map((note) async {
        return await _noteAddImagesToInstance(note);
      }).toList());

      group.addToGroup(finalList);
      return true;
    } catch (e) {
      print("Error is $e");
      rethrow;
    }
  }

  //addGRoup
  Future<bool> addGroup(Group group) async {
    int? id;
    try {
      id = await _sqlHelper.create(
          table: TableNames.group, data: group.toRow(), raw: false);
      group.setId(id!);
    } catch (e) {
      print(e);
      return false;
    }
    //also could be optimized by batch operations
    //by adding a batch input and editing or creating a batch option of all functions
    //but fuck it
    if (group.notesList != null) {
      try {
        group.notesList!.map((e) async {
          await _sqlHelper.create(
              raw: false,
              table: TableNames.notesJunc,
              data: {'note_id': e.id, 'group_id': group.id});
        });
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  //deleteGRoup
  Future<bool> deleteGroup(Group group) async {
    bool state;
    try {
      state = await _sqlHelper.delete(
          table: TableNames.group, id: group.id, userId: userId, raw: false);
      return state;
    } catch (e) {
      print(e);
      return false;
    }
    //id will be always not null since the above insertion went smoothly
    //there is no need for this because i think cascade is set
    //ill leave it commented in case it doesnt work
    // try {
    //   if (note.imgPaths != null && state) {
    //     state = await _sqlHelper.delete(
    //         query: 'DELETE FROM ${TableNames.images} WHERE note_id = ?',
    //         argumentsList: [note.id.toString()],
    //         raw: true);
    //   }
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
    // return state;
  }

  //addNotetoGroup
  Future<bool> addNoteToGroup(Note note, Group group) async {
    try {
      _sqlHelper.create(
          raw: false,
          table: TableNames.notesJunc,
          data: {'note_id': note.id, 'group_id': group.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  //removeNoteFromGroup
  Future<bool> removeNoteFromGroup(Note note, Group group) async {
    try {
      return _sqlHelper.update(
          raw: true,
          query:
              'UPDATE ${TableNames.notesJunc} SET group_id = NULL WHERE note_id = ? AND group_id = ?',
          argumentsList: [note.id.toString(), group.id.toString()]);
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeGroup(
      {required Note note,
      required Group group1,
      required Group group2}) async {
    try {
      return _sqlHelper.update(
          raw: true,
          query:
              'UPDATE ${TableNames.notesJunc} SET group_id = ? WHERE note_id = ? AND group_id = ?',
          argumentsList: [
            group2.id.toString(),
            note.id.toString(),
            group1.id.toString()
          ]);
    } catch (e) {
      return false;
    }
  }

  //addImageToList
  Future<bool> addImage(ImageModel image, int noteId) async {
    int? id;
    try {
      Map<String, dynamic> dataMap = image.toRow();
      dataMap['user_id'] = userId;
      dataMap['note_id'] = noteId;
      id = await _sqlHelper.create(
          raw: false, table: TableNames.images, data: dataMap);
      if (id != 0 && id != null) {
        image.setId(id);
        return true;
      }
    } catch (e) {
      print('Errors is: $e');
      return false;
    }
    return false;
  }

  //deleteImageFromList
  Future<bool> deleteImage(ImageModel image) async {
    try {
      return await _sqlHelper.delete(
          raw: false, table: TableNames.images, userId: userId, id: image.id);
    } catch (e) {
      print('Error is: $e');
      return false;
    }
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
      note.addImage(imgPath: imgList);
    }
    return note;
  }

  Future<bool> dispose() async {
    return await _sqlHelper.close();
  }

  void changeUserId(String? newUserId) {
    userId = newUserId;
  }
}
