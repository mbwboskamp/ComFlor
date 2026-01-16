import 'package:drift/drift.dart';

/// Table for caching mood tiles from API
class MoodTiles extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Mood code for identification
  TextColumn get code => text()();

  /// Emoji to display
  TextColumn get emoji => text()();

  /// Label text to display
  TextColumn get label => text()();

  /// Mood category: 'positive', 'neutral', 'negative'
  TextColumn get category => text()();

  /// Display order
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this mood is currently active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Mood tiles version from API
  TextColumn get version => text()();

  @override
  Set<Column> get primaryKey => {id};
}
