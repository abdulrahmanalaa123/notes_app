import 'table_names.dart';

class TableQueries {
  static const users = '''        CREATE TABLE ${TableNames.users}(
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          image_path TEXT
        );''';

  static const imageList =
      'CREATE TABLE ${TableNames.imageList}(id INTEGER PRIMARY KEY AUTOINCREMENT,);';
  static const imagePath = '''        
  CREATE TABLE ${TableNames.images}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          path TEXT NOT NULL,
          user_id TEXT,
          note_id INTEGER,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION,
          FOREIGN KEY(note_id)
            REFERENCES Notes(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
        );
        ''';
  //image_list_id INTEGER,
  // FOREIGN KEY(image_list_id)
  // REFERENCES ImageLists(id)
  // ON DELETE CASCADE
  // ON UPDATE NO ACTION
  static const notes = '''
  CREATE TABLE ${TableNames.notes}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          title TEXT NOT NULL,
          body TEXT,
          description TEXT,
          is_favorite INTEGER DEFAULT 0,
          last_edited TEXT,
          user_id TEXT NOT NULL,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
        );
        ''';
  static const groups = '''        
         CREATE TABLE ${TableNames.group}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_name TEXT NOT NULL, 
          user_id TEXT NOT NULL,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
        );
        ''';
  static const notesJunction = '''
        CREATE TABLE ${TableNames.notesJunc}(
          note_id INTEGER,
          group_id INTEGER NULL,
          FOREIGN KEY(note_id)
            REFERENCES Notes(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION,
          FOREIGN KEY(group_id)
            REFERENCES Groups(id)
              ON DELETE SET NULL
              ON UPDATE NO ACTION
        );
        ''';
}
