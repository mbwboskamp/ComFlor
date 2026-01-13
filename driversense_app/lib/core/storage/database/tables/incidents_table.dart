import 'package:drift/drift.dart';

/// Table for storing incident reports
class Incidents extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Associated trip ID (null if reported outside of a trip)
  TextColumn get tripId => text().nullable()();

  /// Incident type code
  TextColumn get type => text()();

  /// Latitude where incident occurred
  RealColumn get latitude => real().nullable()();

  /// Longitude where incident occurred
  RealColumn get longitude => real().nullable()();

  /// Text description of the incident
  TextColumn get description => text().nullable()();

  /// Local path to voice recording file
  TextColumn get voiceNotePath => text().nullable()();

  /// Transcription of voice note
  TextColumn get voiceTranscription => text().nullable()();

  /// Local path to photo file
  TextColumn get photoPath => text().nullable()();

  /// Whether this is an urgent incident
  BoolColumn get isUrgent => boolean().withDefault(const Constant(false))();

  /// Whether driver requested a callback
  BoolColumn get contactRequested => boolean().withDefault(const Constant(false))();

  /// When the incident was reported
  DateTimeColumn get reportedAt => dateTime()();

  /// Whether the incident has been synced
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  /// Server-side URL for uploaded voice note
  TextColumn get voiceNoteUrl => text().nullable()();

  /// Server-side URL for uploaded photo
  TextColumn get photoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
