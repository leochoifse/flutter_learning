import 'package:sqflite/sqflite.dart';

class DatabaseModal {
  static var database;

  static dbInit() async {
    database = await openDatabase(
      'my_db.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE test (
            id INTEGER PRIMARY KEY,
            name TEXT,
            data LONG TEXT
            submit_status CHARACTER(30),
            created_at TIMESTAMP,
            submitted_at TIMESTAMP,
          )
        ''');
      },
    );
  }

  static Future<int> insertRecord(String tableName, Map dataMap) async {
    var db = await database;
    dataMap["submit_status"] = SubmitStatus.pending;
    dataMap["created_at"] = DateTime.now().toString();
    return await db.insert(tableName, dataMap);
  }
}

enum SubmitStatus {
  pending,
  submitted,
}
