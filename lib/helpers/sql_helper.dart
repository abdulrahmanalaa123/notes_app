import 'package:notes_app/helpers/sqlite_initialization_helper.dart';
import 'package:sqflite/sqflite.dart';

//every crud is working initially atm
//TODO
//need to implement batch and batch added as input to the functions
//being able to initiate batch performances through transactions
//but maybe fuck this right now
class SqlHelper {
  static final SqlHelper _sqlRepo = SqlHelper._();
  final SqlInitializationHelper _helper;
  Database? _db;

  SqlHelper._() : _helper = SqlInitializationHelper();

  factory SqlHelper() => _sqlRepo;

  Future<bool> open() async {
    if (_db != null) {
      return true;
    }

    //not putting _db = null check since already been checked above
    await _helper.initPath();
    bool alreadyExists = await databaseExists(_helper.finalPath);
    print('this database exists: $alreadyExists');
    if (alreadyExists) {
      _db = await openDatabase(_helper.finalPath);
      print(_db);
      print('Database Opened');
      return true;
    }

    //then finally if not all of those open a database
    try {
      _db = await _helper.create();
      print(_db);
      return true;
    } catch (e) {
      print('Error = $e');
      return false;
    }
  }

  //TODO
  //batch insertions and deletions

  //batchopen doesnt return ids when inserted into the database it just operates and doesnt return
// Batch? batchOpen() {
//   final db = _db;
//   if (db != null) {
//     final batch = db.batch();
//     return batch;
//   }
//   return null;
// }

// Future<bool> batchCommit(Batch batch) async {
//    if (batch != null) {
//      await batch.commit();
//      return true;
//    }
//    return false;
//  }

  //table shouldnt be entered unless you have raw as false
  //since its used in the default method
  //add row
  Future<int?> create(
      {String? table,
      Map<String, dynamic>? data,
      required bool raw,
      String? query,
      List<String>? argumentsList}) async {
    //to access null check
    final db = _db;

    if (db == null) {
      return null;
    }

    int id;
    if (!raw) {
      try {
        id = await db.insert(table!, data!,
            conflictAlgorithm: ConflictAlgorithm.replace);
        return id;
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Raw query with raw = false';
      }
    } else {
      try {
        //this would be the basic insert raw with an arguments list
        //     'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        //       ['another name', 12345678, 3.1416]
        id = await db.rawInsert(query!, argumentsList);
        return id;
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Non-Raw query with raw = true';
      }
    }
  }

  //table shouldnt be entered unless you have raw as false
  //since its used in the default method

  Future<List<Map<String, dynamic>>?> read(
      {String? table,
      int? id,
      String? userId,
      required bool raw,
      String? query,
      List<String>? argumentsList,
      String? orderBy}) async {
    //to access null check
    final db = _db;

    if (db == null) {
      //this will define that its null means something is wrong and no database is initialized
      //maybe just return an empty string but maybe will be done later at deployement
      //TODO
      //return empty list and null right now is for error checking
      return null;
    }

    List<Map<String, dynamic>> maps;
    if (!raw) {
      //since each data has id but doesnt need it but every table has user_id and probably needs it if queried on its own
      //if not just use rawQuery well i dont know how to generalize this class this is the best i can do
      //really my mind is just giving up on this so this is the best ive reached so far
      try {
        maps = await db.query(table!,
            where: id != null ? "id = ? " : 'user_id = ?',
            whereArgs: id != null ? [id, userId] : [userId]);
        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Raw query with raw = false';
      }
    } else {
      try {
        maps = await db.rawQuery(query!, argumentsList);
        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Non-Raw query with raw = true';
      }
    }
  }

  //should use default if updating by id like notes table
  Future<bool> update(
      {String? table,
      Map<String, dynamic>? data,
      int? id,
      required bool raw,
      String? query,
      List<String>? argumentsList}) async {
    final db = _db;

    if (db == null) {
      return false;
    }
    if (!raw) {
      //since each data has id but doesnt need it but every table has user_id and probably needs it if queried on its own
      //if not just use rawQuery well i dont know how to generalize this class this is the best i can do
      //really my mind is just giving up on this so this is the best ive reached so far
      try {
        await db.update(table!, data!, where: 'id = ?', whereArgs: [id]);
        return true;
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Raw query with raw = false';
      }
    } else {
      try {
        //    this is the format and the second line is the arguments list which would be the map values specifically
        //    'UPDATE Test SET name = ?, value = ? WHERE name = ?',
        //     ['updated name', '9876', 'some name']
        await db.rawUpdate(query!, argumentsList);
        return true;
      } catch (e) {
        // if it is a database exception i can return false instead of rethrowing idk yet
        //of the best design choice
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Non-Raw query with raw = true';
      }
    }
  }

  Future<bool> delete(
      {String? table,
      int? id,
      String? userId,
      required bool raw,
      String? query,
      List<String>? argumentsList}) async {
    //to access null check
    final db = _db;

    if (db == null) {
      return false;
    }

    if (!raw) {
      //since each data has id but doesnt need it but every table has user_id and probably needs it if queried on its own
      //if not just use rawQuery well i dont know how to generalize this class this is the best i can do
      //really my mind is just giving up on this so this is the best ive reached so far
      try {
        await db.delete(table!,
            where: id != null ? "id = ?" : 'user_id = ?',
            whereArgs: id != null ? [id, userId] : [userId]);
        return true;
      } catch (e) {
        // if it is a database exception i can return false instead of rethrowing idk yet
        //of the best design choice
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Raw query with raw = false';
      }
    } else {
      try {
        //
        //'DELETE FROM Test WHERE name = ?',
        // ['another name']
        await db.rawDelete(query!, argumentsList);
        return true;
      } catch (e) {
        if (e is DatabaseException) {
          rethrow;
        }
        throw 'Using Non-Raw query with raw = true';
      }
    }
  }

  Future<bool> close() async {
    if (_db == null) {
      return false;
    } else {
      await _db!.close();
      return true;
    }
  }
}
