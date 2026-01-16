import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/incidents_table.dart';

part 'incidents_dao.g.dart';

@DriftAccessor(tables: [Incidents])
class IncidentsDao extends DatabaseAccessor<AppDatabase> with _$IncidentsDaoMixin {
  IncidentsDao(super.db);

  /// Get all incidents
  Future<List<Incident>> getAllIncidents() {
    return (select(incidents)..orderBy([(t) => OrderingTerm.desc(t.reportedAt)])).get();
  }

  /// Get incident by ID
  Future<Incident?> getIncidentById(String id) {
    return (select(incidents)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get incidents by trip ID
  Future<List<Incident>> getIncidentsByTripId(String tripId) {
    return (select(incidents)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.desc(t.reportedAt)]))
        .get();
  }

  /// Get urgent incidents
  Future<List<Incident>> getUrgentIncidents() {
    return (select(incidents)
          ..where((t) => t.isUrgent.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.reportedAt)]))
        .get();
  }

  /// Get unsynced incidents
  Future<List<Incident>> getUnsyncedIncidents() {
    return (select(incidents)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.reportedAt)]))
        .get();
  }

  /// Get incidents within date range
  Future<List<Incident>> getIncidentsByDateRange(DateTime start, DateTime end) {
    return (select(incidents)
          ..where((t) => t.reportedAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.reportedAt)]))
        .get();
  }

  /// Insert a new incident
  Future<void> insertIncident(IncidentsCompanion incident) {
    return into(incidents).insert(incident);
  }

  /// Update an incident
  Future<bool> updateIncident(Incident incident) {
    return update(incidents).replace(incident);
  }

  /// Mark incident as synced
  Future<void> markAsSynced(String id) {
    return (update(incidents)..where((t) => t.id.equals(id))).write(
      const IncidentsCompanion(isSynced: Value(true)),
    );
  }

  /// Update media URLs after upload
  Future<void> updateMediaUrls(
    String id, {
    String? voiceNoteUrl,
    String? photoUrl,
  }) {
    return (update(incidents)..where((t) => t.id.equals(id))).write(
      IncidentsCompanion(
        voiceNoteUrl: Value(voiceNoteUrl),
        photoUrl: Value(photoUrl),
      ),
    );
  }

  /// Delete an incident
  Future<int> deleteIncident(String id) {
    return (delete(incidents)..where((t) => t.id.equals(id))).go();
  }

  /// Delete synced incidents older than specified date
  Future<int> deleteOldSyncedIncidents(DateTime before) {
    return (delete(incidents)
          ..where((t) => t.isSynced.equals(true) & t.reportedAt.isSmallerThanValue(before)))
        .go();
  }

  /// Watch all incidents
  Stream<List<Incident>> watchAllIncidents() {
    return (select(incidents)..orderBy([(t) => OrderingTerm.desc(t.reportedAt)])).watch();
  }

  /// Watch incidents for a trip
  Stream<List<Incident>> watchIncidentsByTripId(String tripId) {
    return (select(incidents)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.desc(t.reportedAt)]))
        .watch();
  }

  /// Get incident count by type
  Future<Map<String, int>> getIncidentCountByType({DateTime? since}) async {
    final query = select(incidents);
    if (since != null) {
      query.where((t) => t.reportedAt.isBiggerOrEqualValue(since));
    }

    final allIncidents = await query.get();
    final counts = <String, int>{};

    for (final incident in allIncidents) {
      counts[incident.type] = (counts[incident.type] ?? 0) + 1;
    }

    return counts;
  }
}
