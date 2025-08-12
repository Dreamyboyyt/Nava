import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nava_demon_lords_diary/common/db/app_database.dart';
import 'package:nava_demon_lords_diary/features/conquests/domain/conquest.dart';

final conquestRepositoryProvider = Provider<ConquestRepository>((ref) {
  return ConquestRepository();
});

final conquestsProvider = FutureProvider<List<Conquest>>((ref) async {
  final repo = ref.watch(conquestRepositoryProvider);
  return repo.getAll();
});

class ConquestRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<List<Conquest>> getAll() async {
    final db = await _db;
    final rows = await db.query(
      'conquests',
      // Order by status (pending -> inProgress -> completed), then by dueAt with NULLS LAST
      orderBy:
          "CASE status WHEN 'pending' THEN 0 WHEN 'inProgress' THEN 1 ELSE 2 END, (dueAt IS NULL), dueAt ASC",
    );
    return rows.map(Conquest.fromMap).toList();
  }

  Future<int> insert(Conquest conquest) async {
    final db = await _db;
    return db.insert('conquests', conquest.toMap());
  }

  Future<int> update(Conquest conquest) async {
    final db = await _db;
    return db.update('conquests', conquest.toMap(), where: 'id = ?', whereArgs: [conquest.id]);
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('conquests', where: 'id = ?', whereArgs: [id]);
  }
}
