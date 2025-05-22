import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'phish_detective.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sms_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            body TEXT,
            date INTEGER,
            isSafe INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertHistory(String body, int date, int isSafe) async {
    final dbClient = await db;
    return await dbClient.insert('sms_history', {
      'body': body,
      'date': date,
      'isSafe': isSafe,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final dbClient = await db;
    return await dbClient.query('sms_history', orderBy: 'date DESC');
  }

  Future<void> clearHistory() async {
    final dbClient = await db;
    await dbClient.delete('sms_history');
  }
}
