import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/checks_table.dart';

part 'checks_dao.g.dart';

@DriftAccessor(tables: [Checks])
class ChecksDao extends DatabaseAccessor<AppDatabase> with _$ChecksDaoMixin {
  ChecksDao(super.db);

  /// Get all checks
  Future<List<Check>> getAllChecks() => select(checks).get();

  /// Get check by ID
  Future<Check?> getCheckById(String id) {
    return (select(checks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get checks by trip ID
  Future<List<Check>> getChecksByTripId(String tripId) {
    return (select(checks)..where((t) => t.tripId.equals(tripId))).get();
  }

  /// Get checks by type
  Future<List<Check>> getChecksByType(String type) {
    return (select(checks)..where((t) => t.type.equals(type))).get();
  }

  /// Get unsynced checks
  Future<List<Check>> getUnsyncedChecks() {
    return (select(checks)..where((t) => t.isSynced.equals(false))).get();
  }

  /// Get checks within date range
  Future<List<Check>> getChecksByDateRange(DateTime start, DateTime end) {
    return (select(checks)
          ..where((t) => t.completedAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  /// Insert a new check
  Future<void> insertCheck(ChecksCompanion check) {
    return into(checks).insert(check);
  }

  /// Update a check
  Future<bool> updateCheck(Check check) {
    return update(checks).replace(check);
  }

  /// Mark check as synced
  Future<void> markAsSynced(String id, DateTime syncedAt) {
    return (update(checks)..where((t) => t.id.equals(id))).write(
      ChecksCompanion(
        isSynced: const Value(true),
        syncedAt: Value(syncedAt),
      ),
    );
  }

  /// Update trip ID for a check
  Future<void> updateTripId(String checkId, String tripId) {
    return (update(checks)..where((t) => t.id.equals(checkId))).write(
      ChecksCompanion(tripId: Value(tripId)),
    );
  }

  /// Delete a check
  Future<int> deleteCheck(String id) {
    return (delete(checks)..where((t) => t.id.equals(id))).go();
  }

  /// Delete synced checks older than specified date
  Future<int> deleteOldSyncedChecks(DateTime before) {
    return (delete(checks)
          ..where((t) => t.isSynced.equals(true) & t.completedAt.isSmallerThanValue(before)))
        .go();
  }

  /// Watch all checks
  Stream<List<Check>> watchAllChecks() => select(checks).watch();

  /// Watch unsynced check count
  Stream<int> watchUnsyncedCount() {
    return (selectOnly(checks)
          ..where(checks.isSynced.equals(false))
          ..addColumns([checks.id.count()]))
        .map((row) => row.read(checks.id.count()) ?? 0)
        .watchSingle();
  }
}
