import 'dart:io';

import 'package:notes_app/constants/table_queries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqlInitializationHelper {
  String finalPath = '';

  Future<void> initPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    finalPath = join(directory.path, 'finalNotesDb');
  }

  Future<Database> create() async {
    await initPath();
    Database database =
        await openDatabase(finalPath, version: 1, onCreate: _onCreate);
    return database;
  }

  Future<void> _onCreate(Database database, int version) async {
    //should add created time to the user but ill add it later
    //should add images but ill leave it out for now
    await database.execute(TableQueries.users);
    // await database.execute(TableQueries.imageList);
    await database.execute(TableQueries.imagePath);
    await database.execute(TableQueries.notes);
    await database.execute(TableQueries.groups);
    await database.execute(TableQueries.notesJunction);
  }
//    await database.execute('PRAGMA foreign_keys = ON');
}
//old database design reformatted for better usage
//'''
//    CREATE TABLE Users(
//      id INTEGER PRIMARY KEY,
//      name TEXT NOT NULL,
//      email TEXT NOT NULL UNIQUE,
//      image_path TEXT UNIQUE
//    );
//    CREATE TABLE Notes(
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//      created_at TEXT DEFAULT datetime('now','localtime'),
//      title TEXT NOT NULL,
//      body TEXT,
//      description TEXT,
//      is_favorite INTEGER CHECK(is_favorite IN (0,1)),
//      last_edited TEXT,
//      user_id INTEGER,
//      FOREIGN KEY(user_id)
//        REFERENCES Users(id)
//          ON DELETE CASCADE
//          ON UPDATE NO ACTION
//    );
//
//    CREATE TABLE NotesLists(
//    id INTEGER PRIMARY KEY AUTOINCREMENT,
//    user_id INTEGER,
//      FOREIGN KEY(user_id)
//        REFERENCES Users(id)
//          ON DELETE CASCADE
//          ON UPDATE NO ACTION
//    );
//
//    CREATE TABLE NotesJunction(
//      note_id INTEGER,
//      notes_list_id INTEGER,
//      FOREIGN KEY(notes_list_id)
//        REFERENCES NotesLists(id)
//          ON DELETE CASCADE
//          ON UPDATE NO ACTION
//      FOREIGN KEY(note_id)
//        REFERENCES Notes(id)
//          ON DELETE CASCADE
//          ON UPDATE NO ACTION
//    );
//
//    CREATE TABLE Groups(
//    id INTEGER PRIMARY KEY AUTOINCREMENT,
//    group_name TEXT NOT NULL,
//    user_id INTEGER,
//    notes_list_id INTEGER,
//      FOREIGN KEY(user_id)
//        REFERENCES Users(id)
//          ON DELETE CASCADE
//          ON UPDATE NO ACTION,
//      FOREIGN KEY(notes_list_id)
//        REFERENCES NotesLists(id)
//          ON DELETE SET NULL
//          ON UPDATE NO ACTION
//    );
//    '''
