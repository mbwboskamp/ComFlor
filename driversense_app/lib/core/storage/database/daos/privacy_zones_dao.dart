import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/privacy_zones_table.dart';

part 'privacy_zones_dao.g.dart';

@DriftAccessor(tables: [PrivacyZones])
class PrivacyZonesDao extends DatabaseAccessor<AppDatabase> with _$PrivacyZonesDaoMixin {
  PrivacyZonesDao(super.db);

  /// Get all privacy zones
  Future<List<PrivacyZone>> getAllZones() {
    return select(privacyZones).get();
  }

  /// Get active privacy zones
  Future<List<PrivacyZone>> getActiveZones() {
    return (select(privacyZones)..where((t) => t.isActive.equals(true))).get();
  }

  /// Get privacy zone by ID
  Future<PrivacyZone?> getZoneById(String id) {
    return (select(privacyZones)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new privacy zone
  Future<void> insertZone(PrivacyZonesCompanion zone) {
    return into(privacyZones).insert(zone);
  }

  /// Update a privacy zone
  Future<bool> updateZone(PrivacyZone zone) {
    return update(privacyZones).replace(zone);
  }

  /// Toggle zone active status
  Future<void> toggleZone(String id, bool isActive) {
    return (update(privacyZones)..where((t) => t.id.equals(id))).write(
      PrivacyZonesCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update zone location
  Future<void> updateZoneLocation(
    String id, {
    required double latitude,
    required double longitude,
    int? radiusMeters,
  }) {
    return (update(privacyZones)..where((t) => t.id.equals(id))).write(
      PrivacyZonesCompanion(
        latitude: Value(latitude),
        longitude: Value(longitude),
        radiusMeters: radiusMeters != null ? Value(radiusMeters) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a privacy zone
  Future<int> deleteZone(String id) {
    return (delete(privacyZones)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all privacy zones
  Future<int> deleteAllZones() {
    return delete(privacyZones).go();
  }

  /// Watch all privacy zones
  Stream<List<PrivacyZone>> watchAllZones() {
    return select(privacyZones).watch();
  }

  /// Watch active privacy zones
  Stream<List<PrivacyZone>> watchActiveZones() {
    return (select(privacyZones)..where((t) => t.isActive.equals(true))).watch();
  }

  /// Get zone count
  Future<int> getZoneCount() async {
    final count = privacyZones.id.count();
    final query = selectOnly(privacyZones)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
