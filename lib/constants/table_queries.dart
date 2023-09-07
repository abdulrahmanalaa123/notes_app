import 'table_names.dart';

class TableQueries {
  static const users = '''        CREATE TABLE ${TableNames.users}(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          image_path TEXT
        );''';

  static const imageList =
      'CREATE TABLE ${TableNames.imageList}(id INTEGER PRIMARY KEY AUTOINCREMENT);';
  static const imagePath = '''        
  CREATE TABLE ${TableNames.images}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          path TEXT NOT NULL,
          user_id INTEGER,
          image_list_id INTEGER,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION,
          FOREIGN KEY(image_list_id)
            REFERENCES ImageLists(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
        );
        ''';
  static const Notes = '''    
  CREATE TABLE ${TableNames.notes}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          title TEXT NOT NULL,
          body TEXT,
          description TEXT,
          is_favorite INTEGER DEFAULT 0,
          last_edited TEXT,
          image_list_id INTEGER NULL,
          user_id INTEGER,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION,
          FOREIGN KEY(image_list_id)
            REFERENCES ImageLists(id)
              ON DELETE SET NULL
              ON UPDATE NO ACTION
        );
        ''';
  static const groups = '''        
         CREATE TABLE ${TableNames.group}(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_name TEXT NOT NULL, 
          user_id INTEGER,
          FOREIGN KEY(user_id)
            REFERENCES Users(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
        );
        ''';
  static const notesjunction = '''
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
