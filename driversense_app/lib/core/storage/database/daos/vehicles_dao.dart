import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/vehicles_table.dart';

part 'vehicles_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehiclesDao extends DatabaseAccessor<AppDatabase> with _$VehiclesDaoMixin {
  VehiclesDao(super.db);

  /// Get all vehicles
  Future<List<Vehicle>> getAllVehicles() {
    return select(vehicles).get();
  }

  /// Get assigned vehicles
  Future<List<Vehicle>> getAssignedVehicles() {
    return (select(vehicles)..where((t) => t.isAssigned.equals(true))).get();
  }

  /// Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) {
    return (select(vehicles)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get vehicle by plate
  Future<Vehicle?> getVehicleByPlate(String plate) {
    return (select(vehicles)..where((t) => t.plate.equals(plate))).getSingleOrNull();
  }

  /// Insert or update a vehicle
  Future<void> upsertVehicle(VehiclesCompanion vehicle) {
    return into(vehicles).insertOnConflictUpdate(vehicle);
  }

  /// Insert or update multiple vehicles
  Future<void> upsertVehicles(List<VehiclesCompanion> vehiclesList) async {
    await batch((batch) {
      for (final vehicle in vehiclesList) {
        batch.insert(vehicles, vehicle, onConflict: DoUpdate((_) => vehicle));
      }
    });
  }

  /// Update vehicle KM reading
  Future<void> updateKmReading(String id, int kmReading) {
    return (update(vehicles)..where((t) => t.id.equals(id))).write(
      VehiclesCompanion(
        lastKmReading: Value(kmReading),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a vehicle
  Future<int> deleteVehicle(String id) {
    return (delete(vehicles)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all vehicles
  Future<int> deleteAllVehicles() {
    return delete(vehicles).go();
  }

  /// Watch all assigned vehicles
  Stream<List<Vehicle>> watchAssignedVehicles() {
    return (select(vehicles)..where((t) => t.isAssigned.equals(true))).watch();
  }

  /// Watch vehicle by ID
  Stream<Vehicle?> watchVehicle(String id) {
    return (select(vehicles)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }
}
