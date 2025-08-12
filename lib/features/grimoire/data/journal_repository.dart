import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nava_demon_lords_diary/common/db/app_database.dart';
import 'package:nava_demon_lords_diary/features/grimoire/domain/journal_entry.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) => JournalRepository());

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getAll();
});

class JournalRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<List<JournalEntry>> getAll() async {
    final db = await _db;
    final rows = await db.query('journal_entries', orderBy: 'createdAt DESC');
    return rows.map(JournalEntry.fromMap).toList();
  }

  Future<int> insert(JournalEntry entry) async {
    final db = await _db;
    return db.insert('journal_entries', entry.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }
}
