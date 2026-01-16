import 'package:drift/drift.dart';

/// Table for caching check questions from API
class Questions extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Question code for identification
  TextColumn get code => text()();

  /// Question category: 'wellness', 'safety', 'vehicle'
  TextColumn get category => text()();

  /// Question text to display
  TextColumn get text => text()();

  /// JSON object mapping scale values to labels
  TextColumn get scaleLabels => text()();

  /// Check type this question belongs to: 'start', 'end', 'both'
  TextColumn get checkType => text().withDefault(const Constant('both'))();

  /// Display order within category
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether the question is currently active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Questions version from API
  TextColumn get version => text()();

  @override
  Set<Column> get primaryKey => {id};
}
