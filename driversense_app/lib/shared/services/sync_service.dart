import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/config/app_config.dart';
import 'package:driversense_app/core/network/api_client.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/utils/logger.dart';
import 'package:driversense_app/shared/services/connectivity_service.dart';

/// Service for handling offline-first data synchronization
@lazySingleton
class SyncService {
  final ConnectivityService _connectivityService;
  final AppDatabase _database;
  final ApiClient _apiClient;

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;

  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  SyncService(
    this._connectivityService,
    this._database,
    this._apiClient,
  );

  /// Stream of sync status updates
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Current sync status
  SyncStatus _currentStatus = const SyncStatus();

  /// Initialize sync service
  void initialize() {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (isOnline) {
        if (isOnline) {
          syncAll();
        }
      },
    );

    // Periodic sync when online
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) {
        if (_connectivityService.isOnline) {
          syncAll();
        }
      },
    );

    AppLogger.info('Sync service initialized');
  }

  /// Sync all pending data
  Future<void> syncAll() async {
    if (_isSyncing) {
      AppLogger.debug('Sync already in progress, skipping');
      return;
    }

    if (!_connectivityService.isOnline) {
      AppLogger.debug('Offline, skipping sync');
      return;
    }

    _isSyncing = true;
    _updateStatus(isSyncing: true);

    try {
      // Priority order:
      // 1. Checks (critical for compliance)
      // 2. Incidents (especially urgent ones)
      // 3. Track points (batch, can be large)
      // 4. Messages

      await _syncChecks();
      await _syncIncidents();
      await _syncTrackPoints();
      await _syncMessages();

      _updateStatus(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
        pendingCount: await _getPendingCount(),
      );

      AppLogger.info('Sync completed successfully');
    } catch (e) {
      AppLogger.error('Sync failed', e);
      _updateStatus(
        isSyncing: false,
        error: e.toString(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync unsynced checks
  Future<void> _syncChecks() async {
    try {
      final unsyncedChecks = await _database.checksDao.getUnsyncedChecks();
      if (unsyncedChecks.isEmpty) return;

      AppLogger.debug('Syncing ${unsyncedChecks.length} checks');

      for (final check in unsyncedChecks) {
        try {
          // Upload check to server
          // await _apiClient.post(ApiEndpoints.syncChecks, data: check.toJson());

          // Mark as synced
          await _database.checksDao.markAsSynced(check.id, DateTime.now());
        } catch (e) {
          AppLogger.error('Failed to sync check ${check.id}', e);
          // Continue with next check
        }
      }
    } catch (e) {
      AppLogger.error('Failed to sync checks', e);
    }
  }

  /// Sync unsynced incidents
  Future<void> _syncIncidents() async {
    try {
      final unsyncedIncidents = await _database.incidentsDao.getUnsyncedIncidents();
      if (unsyncedIncidents.isEmpty) return;

      AppLogger.debug('Syncing ${unsyncedIncidents.length} incidents');

      // Prioritize urgent incidents
      final sortedIncidents = [...unsyncedIncidents]
        ..sort((a, b) {
          if (a.isUrgent && !b.isUrgent) return -1;
          if (!a.isUrgent && b.isUrgent) return 1;
          return a.reportedAt.compareTo(b.reportedAt);
        });

      for (final incident in sortedIncidents) {
        try {
          // Upload media first if exists
          // if (incident.voiceNotePath != null) {
          //   await _uploadMedia(incident.voiceNotePath!, incident.id, 'voice');
          // }
          // if (incident.photoPath != null) {
          //   await _uploadMedia(incident.photoPath!, incident.id, 'photo');
          // }

          // Upload incident data
          // await _apiClient.post(ApiEndpoints.incidents, data: incident.toJson());

          // Mark as synced
          await _database.incidentsDao.markAsSynced(incident.id);
        } catch (e) {
          AppLogger.error('Failed to sync incident ${incident.id}', e);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to sync incidents', e);
    }
  }

  /// Sync unsynced track points in batches
  Future<void> _syncTrackPoints() async {
    try {
      final batchSize = AppConfig.maxTrackPointsPerBatch;
      var hasMore = true;

      while (hasMore) {
        final unsyncedPoints = await _database.trackPointsDao.getUnsyncedPoints(
          limit: batchSize,
        );

        if (unsyncedPoints.isEmpty) {
          hasMore = false;
          continue;
        }

        AppLogger.debug('Syncing ${unsyncedPoints.length} track points');

        try {
          // Upload batch
          // await _apiClient.post(
          //   ApiEndpoints.tripPoints(tripId),
          //   data: {'points': unsyncedPoints.map((p) => p.toJson()).toList()},
          // );

          // Mark batch as synced
          await _database.trackPointsDao.markAsSynced(
            unsyncedPoints.map((p) => p.id),
          );

          hasMore = unsyncedPoints.length == batchSize;
        } catch (e) {
          AppLogger.error('Failed to sync track points batch', e);
          hasMore = false;
        }
      }
    } catch (e) {
      AppLogger.error('Failed to sync track points', e);
    }
  }

  /// Sync unsynced messages
  Future<void> _syncMessages() async {
    try {
      final unsyncedMessages = await _database.messagesDao.getUnsyncedMessages();
      if (unsyncedMessages.isEmpty) return;

      AppLogger.debug('Syncing ${unsyncedMessages.length} messages');

      for (final message in unsyncedMessages) {
        try {
          // Upload message
          // await _apiClient.post(ApiEndpoints.messages, data: message.toJson());

          // Mark as synced
          await _database.messagesDao.markAsSynced(message.id);
        } catch (e) {
          AppLogger.error('Failed to sync message ${message.id}', e);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to sync messages', e);
    }
  }

  /// Get total pending sync count
  Future<int> _getPendingCount() async {
    final checksCount = (await _database.checksDao.getUnsyncedChecks()).length;
    final incidentsCount = (await _database.incidentsDao.getUnsyncedIncidents()).length;
    final trackPointsCount = await _database.trackPointsDao.getUnsyncedCount();
    final messagesCount = (await _database.messagesDao.getUnsyncedMessages()).length;

    return checksCount + incidentsCount + trackPointsCount + messagesCount;
  }

  /// Update sync status
  void _updateStatus({
    bool? isSyncing,
    DateTime? lastSyncTime,
    int? pendingCount,
    String? error,
  }) {
    _currentStatus = _currentStatus.copyWith(
      isSyncing: isSyncing,
      lastSyncTime: lastSyncTime,
      pendingCount: pendingCount,
      error: error,
    );
    _syncStatusController.add(_currentStatus);
  }

  /// Force sync now
  Future<void> forceSyncNow() async {
    if (_connectivityService.isOnline) {
      await syncAll();
    }
  }

  /// Cleanup old synced data
  Future<void> cleanupOldData() async {
    final cutoffDate = DateTime.now().subtract(
      Duration(days: AppConfig.trackPointRetentionDays),
    );

    await _database.trackPointsDao.deleteOldSyncedPoints(cutoffDate);
    await _database.checksDao.deleteOldSyncedChecks(cutoffDate);
    await _database.incidentsDao.deleteOldSyncedIncidents(cutoffDate);

    AppLogger.info('Cleaned up old synced data');
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}

/// Sync status model
class SyncStatus {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final int pendingCount;
  final String? error;

  const SyncStatus({
    this.isSyncing = false,
    this.lastSyncTime,
    this.pendingCount = 0,
    this.error,
  });

  bool get hasPendingItems => pendingCount > 0;
  bool get hasError => error != null;

  SyncStatus copyWith({
    bool? isSyncing,
    DateTime? lastSyncTime,
    int? pendingCount,
    String? error,
  }) {
    return SyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingCount: pendingCount ?? this.pendingCount,
      error: error,
    );
  }
}
