import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/questions_table.dart';
import 'package:driversense_app/core/storage/database/tables/mood_tiles_table.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Questions, MoodTiles])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(super.db);

  // Questions

  /// Get all questions
  Future<List<Question>> getAllQuestions() {
    return (select(questions)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get questions by check type
  Future<List<Question>> getQuestionsByCheckType(String checkType) {
    return (select(questions)
          ..where((t) =>
              t.isActive.equals(true) &
              (t.checkType.equals(checkType) | t.checkType.equals('both')))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get questions by category
  Future<List<Question>> getQuestionsByCategory(String category) {
    return (select(questions)
          ..where((t) => t.isActive.equals(true) & t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Insert or update questions
  Future<void> upsertQuestions(List<QuestionsCompanion> questionsList) async {
    await batch((batch) {
      for (final question in questionsList) {
        batch.insert(questions, question, onConflict: DoUpdate((_) => question));
      }
    });
  }

  /// Delete all questions
  Future<int> deleteAllQuestions() {
    return delete(questions).go();
  }

  /// Replace all questions
  Future<void> replaceAllQuestions(List<QuestionsCompanion> questionsList) async {
    await transaction(() async {
      await deleteAllQuestions();
      await batch((batch) {
        batch.insertAll(questions, questionsList);
      });
    });
  }

  /// Get questions version
  Future<String?> getQuestionsVersion() async {
    final question = await (select(questions)..limit(1)).getSingleOrNull();
    return question?.version;
  }

  // Mood Tiles

  /// Get all mood tiles
  Future<List<MoodTile>> getAllMoodTiles() {
    return (select(moodTiles)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get mood tiles by category
  Future<List<MoodTile>> getMoodTilesByCategory(String category) {
    return (select(moodTiles)
          ..where((t) => t.isActive.equals(true) & t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Insert or update mood tiles
  Future<void> upsertMoodTiles(List<MoodTilesCompanion> tilesList) async {
    await batch((batch) {
      for (final tile in tilesList) {
        batch.insert(moodTiles, tile, onConflict: DoUpdate((_) => tile));
      }
    });
  }

  /// Delete all mood tiles
  Future<int> deleteAllMoodTiles() {
    return delete(moodTiles).go();
  }

  /// Replace all mood tiles
  Future<void> replaceAllMoodTiles(List<MoodTilesCompanion> tilesList) async {
    await transaction(() async {
      await deleteAllMoodTiles();
      await batch((batch) {
        batch.insertAll(moodTiles, tilesList);
      });
    });
  }

  /// Watch all questions
  Stream<List<Question>> watchAllQuestions() {
    return (select(questions)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Watch all mood tiles
  Stream<List<MoodTile>> watchAllMoodTiles() {
    return (select(moodTiles)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }
}
