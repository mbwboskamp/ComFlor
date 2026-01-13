import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/pending_syncs_table.dart';

part 'pending_syncs_dao.g.dart';

@DriftAccessor(tables: [PendingSyncs])
class PendingSyncsDao extends DatabaseAccessor<AppDatabase> with _$PendingSyncsDaoMixin {
  PendingSyncsDao(super.db);

  /// Get all pending syncs
  Future<List<PendingSync>> getAllPendingSyncs() {
    return (select(pendingSyncs)
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  /// Get pending syncs by type
  Future<List<PendingSync>> getPendingSyncsByType(String entityType) {
    return (select(pendingSyncs)
          ..where((t) => t.entityType.equals(entityType))
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  /// Get next batch of pending syncs
  Future<List<PendingSync>> getNextBatch({int limit = 10, int maxRetries = 5}) {
    return (select(pendingSyncs)
          ..where((t) => t.retryCount.isSmallerThanValue(maxRetries))
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Add a pending sync
  Future<int> addPendingSync(PendingSyncsCompanion sync) {
    return into(pendingSyncs).insert(sync);
  }

  /// Update retry info after failed attempt
  Future<void> recordFailedAttempt(int id, String error) {
    return (update(pendingSyncs)..where((t) => t.id.equals(id))).write(
      PendingSyncsCompanion(
        retryCount: pendingSyncs.retryCount + const Constant(1),
        lastAttemptAt: Value(DateTime.now()),
        lastError: Value(error),
      ),
    );
  }

  /// Delete a pending sync (after successful sync)
  Future<int> deletePendingSync(int id) {
    return (delete(pendingSyncs)..where((t) => t.id.equals(id))).go();
  }

  /// Delete pending sync by entity
  Future<int> deletePendingSyncByEntity(String entityType, String entityId) {
    return (delete(pendingSyncs)
          ..where((t) => t.entityType.equals(entityType) & t.entityId.equals(entityId)))
        .go();
  }

  /// Delete failed syncs (exceeded max retries)
  Future<int> deleteFailedSyncs({int maxRetries = 5}) {
    return (delete(pendingSyncs)..where((t) => t.retryCount.isBiggerOrEqualValue(maxRetries))).go();
  }

  /// Get pending sync count
  Future<int> getPendingCount() async {
    final count = pendingSyncs.id.count();
    final query = selectOnly(pendingSyncs)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get pending sync count by type
  Future<Map<String, int>> getPendingCountByType() async {
    final allPending = await select(pendingSyncs).get();
    final counts = <String, int>{};

    for (final sync in allPending) {
      counts[sync.entityType] = (counts[sync.entityType] ?? 0) + 1;
    }

    return counts;
  }

  /// Watch pending sync count
  Stream<int> watchPendingCount() {
    return customSelect(
      'SELECT COUNT(*) as count FROM pending_syncs',
      readsFrom: {pendingSyncs},
    ).map((row) => row.read<int>('count')).watchSingle();
  }
}
