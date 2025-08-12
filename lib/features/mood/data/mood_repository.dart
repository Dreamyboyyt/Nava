import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nava_demon_lords_diary/common/db/app_database.dart';
import 'package:nava_demon_lords_diary/features/mood/domain/mood_entry.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) => MoodRepository());

final latestMoodProvider = FutureProvider<MoodEntry?>((ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  final items = await repo.getAll(limit: 1);
  return items.isEmpty ? null : items.first;
});

class MoodRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<List<MoodEntry>> getAll({int? limit}) async {
    final db = await _db;
    final rows = await db.query(
      'mood_entries',
      orderBy: 'createdAt DESC',
      limit: limit,
    );
    return rows.map(MoodEntry.fromMap).toList();
  }

  Future<int> insert(MoodEntry entry) async {
    final db = await _db;
    return db.insert('mood_entries', entry.toMap());
  }
}
