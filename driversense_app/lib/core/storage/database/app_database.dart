import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Tables
import 'package:driversense_app/core/storage/database/tables/checks_table.dart';
import 'package:driversense_app/core/storage/database/tables/trips_table.dart';
import 'package:driversense_app/core/storage/database/tables/track_points_table.dart';
import 'package:driversense_app/core/storage/database/tables/incidents_table.dart';
import 'package:driversense_app/core/storage/database/tables/privacy_zones_table.dart';
import 'package:driversense_app/core/storage/database/tables/vehicles_table.dart';
import 'package:driversense_app/core/storage/database/tables/pending_syncs_table.dart';
import 'package:driversense_app/core/storage/database/tables/messages_table.dart';
import 'package:driversense_app/core/storage/database/tables/questions_table.dart';
import 'package:driversense_app/core/storage/database/tables/mood_tiles_table.dart';

// DAOs
import 'package:driversense_app/core/storage/database/daos/checks_dao.dart';
import 'package:driversense_app/core/storage/database/daos/trips_dao.dart';
import 'package:driversense_app/core/storage/database/daos/track_points_dao.dart';
import 'package:driversense_app/core/storage/database/daos/incidents_dao.dart';
import 'package:driversense_app/core/storage/database/daos/privacy_zones_dao.dart';
import 'package:driversense_app/core/storage/database/daos/vehicles_dao.dart';
import 'package:driversense_app/core/storage/database/daos/pending_syncs_dao.dart';
import 'package:driversense_app/core/storage/database/daos/messages_dao.dart';
import 'package:driversense_app/core/storage/database/daos/questions_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Checks,
    Trips,
    TrackPoints,
    Incidents,
    PrivacyZones,
    Vehicles,
    PendingSyncs,
    Messages,
    Questions,
    MoodTiles,
  ],
  daos: [
    ChecksDao,
    TripsDao,
    TrackPointsDao,
    IncidentsDao,
    PrivacyZonesDao,
    VehiclesDao,
    PendingSyncsDao,
    MessagesDao,
    QuestionsDao,
  ],
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Clear all data from the database
  Future<void> clearAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  /// Get database size in bytes
  Future<int> getDatabaseSize() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'driversense.db'));
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'driversense.db'));
    return NativeDatabase.createInBackground(file);
  });
}
