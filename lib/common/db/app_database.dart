import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  static const _dbName = 'nava_diary.db';
  static const _dbVersion = 1;

  static Database? _database;

  static Future<Database> instance() async {
    if (_database != null) return _database!;
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _dbName);
    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE conquests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            details TEXT,
            difficulty INTEGER NOT NULL,
            status TEXT NOT NULL,
            dueAt INTEGER
          );
        ''');
        await db.execute("CREATE INDEX idx_conquests_status ON conquests(status)");
        await db.execute("CREATE INDEX idx_conquests_dueAt ON conquests(dueAt)");
        await db.execute('''
          CREATE TABLE mood_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value INTEGER NOT NULL,
            note TEXT,
            createdAt INTEGER NOT NULL
          );
        ''');
        await db.execute("CREATE INDEX idx_mood_entries_createdAt ON mood_entries(createdAt DESC)");
        await db.execute('''
          CREATE TABLE journal_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            tags TEXT,
            createdAt INTEGER NOT NULL
          );
        ''');
        await db.execute("CREATE INDEX idx_journal_entries_createdAt ON journal_entries(createdAt DESC)");
      },
    );
    return _database!;
  }
}
